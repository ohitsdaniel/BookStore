// Inspired by https://kandelvijaya.com/2018/04/21/blog_equalityonerror/

import Combine
import Foundation

public enum EquatableError: Equatable, Error {
    public static func == (lhs: EquatableError, rhs: EquatableError) -> Bool {
        lhs.reflectedString == rhs.reflectedString
    }

    case error(Error)

    private var reflectedString: String {
        switch self {
        case let .error(error):
            return String(reflecting: error)
        }
    }
}

extension Publisher {
    public func eraseToEquatableError() -> Publishers.MapError<Self, EquatableError> {
        self.mapError { error in EquatableError.error(error) }
    }
}
