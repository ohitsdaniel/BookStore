import BooksCore
import ComposableArchitecture
import FruityBooks
import SwiftUI
import TCABooks

@main
struct BookStoreApp: App {
    let bookStore = Store<BookFeatureState, BookFeatureAction>(
        initialState: .init(books: .none),
        reducer: bookFeatureReducer,
        environment: BookFeatureEnvironment(service: APIBooksService())
    )

    var body: some Scene {
        WindowGroup {
            HStack(spacing: 2) {
                FruityBookList()
                TCABooks.BookList(
                    bookStore: bookStore.scope(
                        state: \.booksState,
                        action: BookFeatureAction.books
                    )
                )
            }
            .background(Color.black)
        }
    }
}
