import Combine
import Foundation

public protocol BooksService {
    func books() -> AnyPublisher<[RawBook], Error>
}

public struct APIBooksService: BooksService {
    public init() {}

    public func books() -> AnyPublisher<[RawBook], Error> {
        let dummyBooks = (0..<100)
            .map { index in
                RawBook(
                    id: .init(stringLiteral: "\(index)"),
                    title: "Book #\(index)",
                    author: Author(name: "Tim", surname: "Apple"),
                    rating: index % 6,
                    favorited: index.isMultiple(of: 3)
                )
            }

        return Just(dummyBooks)
            .setFailureType(to: Error.self)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main).eraseToAnyPublisher()
    }
}
