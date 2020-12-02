import BooksCore
import ComposableArchitecture

public struct BookFeatureState: Equatable {
    var books: Loadable<[RawBook]>

    public init(books: Loadable<[RawBook]>) {
        self.books = books
    }

    public var booksState: BooksState {
        get {
            BooksState(books: books)
        }
        set {
            books = newValue.books
        }
    }
}

public enum BookFeatureAction: Equatable {
    case books(BooksAction)
}

public struct BookFeatureEnvironment {
    let service: BooksService

    public init(service: BooksService) {
        self.service = service
    }

    var books: BooksEnvironment {
        BooksEnvironment(service: service)
    }
}

public let bookFeatureReducer = Reducer<
    BookFeatureState,
    BookFeatureAction,
    BookFeatureEnvironment
>.combine(
    booksReducer.pullback(
        state: \.booksState,
        action: /BookFeatureAction.books,
        environment: \.books
    )
)
