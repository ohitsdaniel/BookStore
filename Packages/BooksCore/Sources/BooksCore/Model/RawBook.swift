import Foundation

public struct Author: Codable, Hashable {
    public let name: String
    public let surname: String

    public init(name: String, surname: String) {
        self.name = name
        self.surname = surname
    }
}

public struct RawBook: Codable, TypeSafeIdentifiable, Hashable {
    public let id: ID
    public let title: String
    public let author: Author
    public let rating: Int
    public var favorited: Bool

    public init(id: TypeSafeID<RawBook>, title: String, author: Author, rating: Int, favorited: Bool) {
        self.id = id
        self.title = title
        self.author = author
        self.rating = rating
        self.favorited = favorited
    }
}
