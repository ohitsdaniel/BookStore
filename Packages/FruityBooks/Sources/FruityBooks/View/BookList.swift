import SwiftUI

public struct FruityBookList: View {
    @ObservedObject var bookStore: BookStore

    public init(bookStore: BookStore = Stores.bookStore) {
        self.bookStore = bookStore
    }

    public var body: some View {
        NavigationView {
            ZStack {
                content
                navigationLink
            }
            .navigationBarTitle("Fruity Books")
        }
        .onAppear {
            bookStore.loadBooks()
        }
    }

    @ViewBuilder var content: some View {
        switch bookStore.books {
        case .none, .loading(previous: .none):
            Text("Loading")
        case let .loading(previous: .some(books)):
            Text("Loading")
            bookList(books: books)
        case let .error(previous: books, error: error):
            Text("An error occured: \(error.localizedDescription)")
            if let books = books {
                bookList(books: books)
            }
        case let .some(books):
            bookList(books: books)
        }
    }

    @ViewBuilder func bookList(books: [Book]) -> some View {
        List(books) { book in
            BookView(book: book)
        }
        .listStyle(GroupedListStyle())
    }

    var navigationLink: some View {
        NavigationLink(
            destination: Text("Destination"),
            isActive: .constant(false),
            label: {
                EmptyView()
            }
        )
        .accessibility(hidden: true)
    }
}

struct FruityBookList_Previews: PreviewProvider {
    static var previews: some View {
        FruityBookList()
    }
}
