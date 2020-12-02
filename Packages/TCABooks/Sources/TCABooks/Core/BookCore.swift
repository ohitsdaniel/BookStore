import BooksCore
import ComposableArchitecture

public enum BookAction {
    case favorite
}

struct BookEnvironment {}

let bookReducer = Reducer<
    RawBook,
    BookAction,
    BookEnvironment
> { state, action, environment in
    switch action {
    case .favorite:
        state.favorited.toggle()
        return .none
    }
}
