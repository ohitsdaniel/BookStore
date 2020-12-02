import BooksCore
import Combine
import Foundation

public protocol BookStoreType {
    var books: Loadable<[Book]> { get }

    func loadBooks()
}

public final class BookStore: ObservableObject, BookStoreType {
    private let service: BooksService
    private var bag = Set<AnyCancellable>()

    @Published public var books: Loadable<[Book]>

    init(
        books: Loadable<[Book]> = .none,
        service: BooksService = APIBooksService()
    ) {
        self.books = books
        self.service = service
    }

    public func loadBooks() {
        books.setLoading()

        service.books()
            .map { Result<[RawBook], Error>.success($0) }
            .catch { Just(Result.failure($0)) }
            .sink { [weak self] result in
                switch result {
                case let .success(rawBooks):
                    self?.books.setSome(value: rawBooks.map(Book.init(from:)))
                case let .failure(error):
                    self?.books.setError(error: error)
                }
            }
            .store(in: &bag)
    }
}

public final class Book: ObservableObject, Identifiable {
    public let id: RawBook.ID
    let title: String
    let author: Author
    let rating: Int

    @Published var favorited: Bool

    init(from rawBook: RawBook) {
        self.id = rawBook.id
        self.title = rawBook.title
        self.author = rawBook.author
        self.rating = rawBook.rating
        self.favorited = rawBook.favorited
    }

    init(id: RawBook.ID, title: String, author: Author, rating: Int, favorited: Bool) {
        self.id = id
        self.title = title
        self.author = author
        self.rating = rating
        self.favorited = favorited
    }
}
