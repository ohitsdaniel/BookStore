import BooksCore
import SwiftUI

struct BookView: View {
    @ObservedObject var book: Book

    init(book: Book) {
        self.book = book
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
                action: favorite,
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

    func favorite() {
        book.favorited.toggle()
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(
            book: Book(
                id: "1",
                title: "Book title",
                author: Author(
                    name: "Person",
                    surname: "Name"
                ),
                rating: 1,
                favorited: false
            )
        )
        .previewLayout(.sizeThatFits)

        BookView(
            book: Book(
                id: "1",
                title: "Book title",
                author: Author(
                    name: "Person",
                    surname: "Name"
                ),
                rating: 1,
                favorited: true
            )
        )
        .previewLayout(.sizeThatFits)
    }
}
