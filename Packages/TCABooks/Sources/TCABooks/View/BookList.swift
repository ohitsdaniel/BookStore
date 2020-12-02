import BooksCore
import ComposableArchitecture
import SwiftUI

public struct BookList: View {
    private let bookStore: Store<BooksState, BooksAction>

    public init(bookStore: Store<BooksState, BooksAction>) {
        self.bookStore = bookStore
    }

    public var body: some View {
        WithViewStore(bookStore) { viewStore in
            NavigationView {
                content(bookStore: viewStore)
                .navigationBarTitle("TCA Books")
            }
            .onAppear {
                viewStore.send(.loadBooks)
            }
        }
    }

    @ViewBuilder func content(bookStore: ViewStore<BooksState, BooksAction>) -> some View {
        switch bookStore.books {
        case .none, .loading(previous: .none):
            Text("Loading")
        case let .loading(previous: .some(books)):
            Text("Loading")
            bookList(books: books, bookStore: bookStore)
        case let .error(previous: books, error: error):
            Text("An error occured: \(error.localizedDescription)")
            if let books = books {
                bookList(books: books, bookStore: bookStore)
            }
        case let .some(books):
            bookList(books: books, bookStore: bookStore)
        }
    }

    @ViewBuilder func bookList(
        books: [RawBook],
        bookStore: ViewStore<BooksState, BooksAction>
    ) -> some View {
        List(books) { book in
            BookView(
                book: book,
                onFavorite: {
                    bookStore.send(.book(id: book.id, action: .favorite))
                }
            )
        }
        .listStyle(GroupedListStyle())
    }
}

struct TCABookList_Previews: PreviewProvider {
    static var previews: some View {
        BookList(
            bookStore: Store(
                initialState: BooksState(books: .none),
                reducer: booksReducer,
                environment: BooksEnvironment(service: APIBooksService())
            )
        )
    }
}
