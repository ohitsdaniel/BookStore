import BooksCore
import ComposableArchitecture

public struct BooksState: Equatable {
    var books: Loadable<[RawBook]>

    var rawBooks: IdentifiedArrayOf<RawBook> {
        get {
            IdentifiedArrayOf(books.value ?? [])
        }
        set {
            books.value = newValue.elements
        }
    }
}

public enum BooksAction: Equatable {
    case loadBooks
    case loadBookCompleted(result: Result<[RawBook], EquatableError>)

    case book(id: RawBook.ID, action: BookAction)
}

struct BooksEnvironment {
    let service: BooksService

    var book: BookEnvironment {
        BookEnvironment()
    }
}

let booksReducer = Reducer <
    BooksState,
    BooksAction,
    BooksEnvironment
>.combine(
    Reducer { state, action, environment in
        switch action {
        case .loadBooks:
            state.books.setLoading()

            return environment.service
                .books()
                .eraseToEquatableError()
                .catchToEffect()
                .map(BooksAction.loadBookCompleted(result:))

        case let .loadBookCompleted(.success(books)):
            state.books.setSome(value: books)
            return .none

        case let .loadBookCompleted(result: .failure(.error(error))):
            state.books.setError(error: error)
            return .none

        case .book:
            return .none
        }
    },
    bookReducer.forEach(
        state: \.rawBooks,
        action: /BooksAction.book,
        environment: \.book
    )
)
