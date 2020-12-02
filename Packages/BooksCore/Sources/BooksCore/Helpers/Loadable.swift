import Foundation
import Combine

public protocol LoadableType {
    associatedtype Entity

    func map<V>(_ mapping: (Entity) throws -> V) rethrows -> Loadable<V>

    var value: Entity? { get set }
    var error: Error? { get }
    var isLoading: Bool { get }
}

public enum Loadable<Entity>: LoadableType {
    case none
    case loading(previous: Entity?)
    case error(previous: Entity?, error: Error)
    case some(Entity)
}

public extension Loadable {
    var value: Entity? {
        get {
            switch self {
            case .loading(let previous), .error(let previous, _):
                return previous
            case .some(let value):
                return value
            case .none:
                return nil
            }
        }
        set {
            switch self {
            case .loading(_):
                self = .loading(previous: newValue)
            case let .error(_, error):
                self = .error(previous: newValue, error: error)
            case .some(_):
                guard let new = newValue else { break }
                self = .some(new)
            case .none:
                break
            }
        }
    }

    var error: Error? {
        guard case let .error(_, error) = self else {
            return nil
        }

        return error
    }

    var isLoading: Bool {
        guard case .loading = self else {
            return false
        }

        return true
    }

    mutating func setLoading() {
        self = .loading(previous: value)
    }

    mutating func setError(error: Error) {
        self = .error(previous: value, error: error)
    }

    mutating func setSome(value: Entity) {
        self = .some(value)
    }

    func map<V>(_ mapping: (Entity) throws -> V) rethrows -> Loadable<V> {
        switch self {
        case .none:
            return .none
        case let .loading(previous):
            return .loading(previous: try previous.map(mapping))
        case let .error(previous, error):
            return .error(previous: try previous.map(mapping), error: error)
        case let .some(value):
            return .some(try mapping(value))
        }
    }
}

extension Loadable: Equatable where Entity: Equatable {
    public static func == (lhs: Loadable<Entity>, rhs: Loadable<Entity>) -> Bool {
        switch (lhs, rhs) {
        case let (.error(lhs, lhsError), .error(rhs, rhsError)):
            return lhs == rhs
                && String(reflecting: lhsError) == String(reflecting: rhsError)
        case let (.loading(lhs), .loading(rhs)):
            return lhs == rhs
        case let (.some(lhs), .some(rhs)):
            return lhs == rhs
        case (.none, .none):
            return true
        default:
            return false
        }
    }
}

public extension Array where Element: LoadableType {
    func mapValues<V>(_ mapping: (Element.Entity) throws -> V) rethrows -> [Loadable<V>] {
        try map { element in
            try element.map(mapping)
        }
    }

    func firstValue(where predicate: (Element.Entity) throws -> Bool) rethrows -> Element? {
        try first(where: { element in try element.value.map(predicate) ?? false })
    }

    func filterValues(_ isIncluded: (Element.Entity) throws -> Bool) rethrows -> [Element] {
        try filter { element in try element.value.map(isIncluded) ?? false }
    }

    func sortedValues(by areInIncreasingOrder: (Element.Entity, Element.Entity) throws -> Bool) rethrows -> [Element] {
        try sorted(
            by: { lhs, rhs in
                // move .none cases to the end of the list
                guard let lValue = lhs.value else {
                    return false
                }

                guard let rValue = rhs.value else {
                    return true
                }

                return try areInIncreasingOrder(lValue, rValue)
            }
        )
    }
}
