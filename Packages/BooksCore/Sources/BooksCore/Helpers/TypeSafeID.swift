public protocol TypeSafeIdentifiable: Identifiable {
    associatedtype RawID: Codable, Hashable = String
    associatedtype ID: Codable = TypeSafeID<Self>
}

public struct TypeSafeID<Element: TypeSafeIdentifiable>: Identifiable {
    public let id: Element.RawID
}

extension TypeSafeID: ExpressibleByUnicodeScalarLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByStringLiteral where Element.RawID == String {
    public typealias ExtendedGraphemeClusterLiteralType = String
    public typealias UnicodeScalarLiteralType = String

    public var rawID: String { id }

    public init(stringLiteral value: String) {
        self.id = value
    }
}

extension TypeSafeID: ExpressibleByIntegerLiteral where Element.RawID == Int {
    public init(integerLiteral value: Int) {
        self.id = value
    }
}

extension TypeSafeID: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        id = try container.decode(Element.RawID.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(id)
    }
}

extension TypeSafeID: CustomStringConvertible {
    public var description: String { "\(String(describing: Element.self))(\(id))" }
}

extension TypeSafeID: Equatable {
    public static func == (lhs: TypeSafeID, rhs: TypeSafeID) -> Bool {
        lhs.id == rhs.id
    }
}

extension TypeSafeID: Hashable {
    public var hashValue: Int { id.hashValue }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
