import BooksCore
import SwiftUI

struct BookView: View {
    let book: RawBook
    let onFavorite: () -> Void

    init(book: RawBook, onFavorite: @escaping () -> Void) {
        self.book = book
        self.onFavorite = onFavorite
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                title
                author
                rating
            }
            Spacer()

            Button(
                action: onFavorite,
                label: {
                    book.favorited ? Image(systemName: "heart.fill") : Image(systemName: "heart")
                }
            )
            .foregroundColor(.red)
        }
    }

    var title: some View {
        Text(book.title)
    }

    var author: some View {
        HStack {
            Text(book.author.name)
                .bold()
            Text(book.author.surname)
        }
    }

    var rating: some View {
        Text("Rating: \(book.rating) / 5")
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(
            book: RawBook(
                id: "1",
                title: "Book title",
                author: Author(
                    name: "Person",
                    surname: "Name"
                ),
                rating: 1,
                favorited: false
            ),
            onFavorite: {}
        )
        .previewLayout(.sizeThatFits)

        BookView(
            book: RawBook(
                id: "1",
                title: "Book title",
                author: Author(
                    name: "Person",
                    surname: "Name"
                ),
                rating: 1,
                favorited: true
            ),
            onFavorite: {}
        )
        .previewLayout(.sizeThatFits)
    }
}
