import Combine
@testable import BooksCore
import XCTest

final class LoadableTests: XCTestCase {
    private var bag: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        bag = []
    }
    
    func test_equality() {
        let variations: [Loadable<Int>] = [
            .none,
            .loading(previous: .none),
            .loading(previous: 1),
            .loading(previous: 2),
            .error(previous: .none, error: TestError.error),
            .error(previous: .none, error: TestError.other),
            .error(previous: 1, error: TestError.error),
            .error(previous: 2, error: TestError.error),
            .error(previous: 1, error: TestError.other),
            .error(previous: 2, error: TestError.other),
            .some(1),
            .some(2)
        ]
        
        variations.enumerated().forEach { outerIndex, outerElement in
            variations.enumerated().forEach { innerIndex, innerElement in
                if outerIndex == innerIndex {
                    XCTAssertEqual(outerElement, innerElement)
                } else {
                    XCTAssertNotEqual(outerElement, innerElement)
                }
            }
        }
    }
    
    // MARK: - None
    func test_none_transitionTo_loading() {
        var sut = Loadable<Int>.none
        sut.setLoading()
        XCTAssertEqual(sut, .loading(previous: .none))
    }
    
    func test_none_transitionTo_error() {
        var sut = Loadable<Int>.none
        sut.setError(error: TestError.error)
        XCTAssertEqual(sut, .error(previous: .none, error: TestError.error))
    }
    
    func test_none_transitionTo_some() {
        var sut = Loadable<Int>.none
        sut.setSome(value: 1)
        XCTAssertEqual(sut, .some(1))
    }
    
    // MARK: - Loading w/o previous value
    func test_loading_noValue_transitionTo_loading() {
        var sut = Loadable<Int>.loading(previous: nil)
        sut.setLoading()
        XCTAssertEqual(sut, .loading(previous: nil))
    }
    
    func test_loading_noValue_transitionTo_error() {
        var sut = Loadable<Int>.loading(previous: nil)
        sut.setError(error: TestError.error)
        XCTAssertEqual(sut, .error(previous: .none, error: TestError.error))
    }
    
    func test_loading_noValue_transitionTo_some() {
        var sut = Loadable<Int>.loading(previous: nil)
        sut.setSome(value: 1)
        XCTAssertEqual(sut, .some(1))
    }
    
    // MARK: - Loading with previous value
    func test_loading_withValue_transitionTo_loading() {
        var sut = Loadable<Int>.loading(previous: 1)
        sut.setLoading()
        XCTAssertEqual(sut, .loading(previous: 1))
    }
    
    func test_loading_withValue_transitionTo_error() {
        var sut = Loadable<Int>.loading(previous: 1)
        sut.setError(error: TestError.error)
        XCTAssertEqual(sut, .error(previous: 1, error: TestError.error))
    }
    
    func test_loading_withValue_transitionTo_some() {
        var sut = Loadable<Int>.loading(previous: 0)
        sut.setSome(value: 1)
        XCTAssertEqual(sut, .some(1))
    }
    
    // MARK: - Error w/o previous value
    func test_error_noValue_transitionTo_loading() {
        var sut = Loadable<Int>.error(previous: .none, error: TestError.error)
        sut.setLoading()
        XCTAssertEqual(sut, .loading(previous: nil))
    }
    
    func test_error_noValue_transitionTo_error() {
        var sut = Loadable<Int>.error(previous: .none, error: TestError.error)
        sut.setError(error: TestError.other)
        XCTAssertEqual(sut, .error(previous: .none, error: TestError.other))
    }
    
    func test_error_noValue_transitionTo_some() {
        var sut = Loadable<Int>.error(previous: .none, error: TestError.error)
        sut.setSome(value: 1)
        XCTAssertEqual(sut, .some(1))
    }
    
    // MARK: - Error with previous value
    func test_error_withValue_transitionTo_loading() {
        var sut = Loadable<Int>.error(previous: 1, error: TestError.error)
        sut.setLoading()
        XCTAssertEqual(sut, .loading(previous: 1))
    }
    
    func test_error_withValue_transitionTo_error() {
        var sut = Loadable<Int>.error(previous: 1, error: TestError.error)
        sut.setError(error: TestError.other)
        XCTAssertEqual(sut, .error(previous: 1, error: TestError.other))
    }
    
    func test_error_withValue_transitionTo_some() {
        var sut = Loadable<Int>.error(previous: 0, error: TestError.error)
        sut.setSome(value: 1)
        XCTAssertEqual(sut, .some(1))
    }
    
    // MARK: Some
    func test_some_transitionTo_loading() {
        var sut = Loadable<Int>.some(1)
        sut.setLoading()
        XCTAssertEqual(sut, .loading(previous: 1))
    }
    
    func test_some_transitionTo_error() {
        var sut = Loadable<Int>.some(1)
        sut.setError(error: TestError.error)
        XCTAssertEqual(sut, .error(previous: 1, error: TestError.error))
    }
    
    func test_some_transitionTo_some() {
        var sut = Loadable<Int>.some(0)
        sut.setSome(value: 1)
        XCTAssertEqual(sut, .some(1))
    }

    //MARK: - Map
    func test_map_none() {
        let sut = Loadable<Int>.none
        let new = sut.map { value in 2 }

        XCTAssertEqual(new, .none)
    }

    func test_map_loading_no_previousValue() {
        let sut = Loadable<String>.loading(previous: nil)
        let new = sut.map { value in value.count }

        XCTAssertEqual(new, .loading(previous: nil))
    }

    func test_map_loading_with_previousValue() {
        let sut = Loadable<String>.loading(previous: "Value")
        let new = sut.map { value in value.count }

        XCTAssertEqual(new, .loading(previous: 5))
    }

    func test_map_error_no_previousValue() {
        let sut = Loadable<String>.error(previous: nil, error: TestError.error)
        let new = sut.map { value in value.count }

        XCTAssertEqual(new, .error(previous: nil, error: TestError.error))
    }

    func test_map_error_with_previousValue() {
        let sut = Loadable<String>.loading(previous: "Value")
        let new = sut.map { value in value.count }

        XCTAssertEqual(new, .loading(previous: 5))
    }

    func test_map_some() {
        let sut = Loadable<String>.some("Value")
        let new = sut.map { value in value.count }

        XCTAssertEqual(new, .some(5))
    }

    //MARK: Map Loadable Array
    func test_array_mapValues() {
        let sut: [Loadable<String>] = [
            .none,
            .loading(previous: nil),
            .loading(previous: "Value"),
            .error(previous: nil, error: TestError.error),
            .error(previous: "Value", error: TestError.error),
            .some("Value")
        ]

        let expected: [Loadable<Int>] = [
            .none,
            .loading(previous: nil),
            .loading(previous: 5),
            .error(previous: nil, error: TestError.error),
            .error(previous: 5, error: TestError.error),
            .some(5)
        ]

        let mapped = sut.mapValues { value in value.count }

        XCTAssertEqual(mapped, expected)
    }

    //MARK: Filter Loadable Array
    func test_array_filterValues() {
        let sut: [Loadable<String>] = [
            .none,
            .loading(previous: nil),
            .loading(previous: "Value"),
            .error(previous: nil, error: TestError.error),
            .error(previous: "Value", error: TestError.error),
            .some("Value")
        ]

        let expected: [Loadable<String>] = [
            .loading(previous: "Value"),
            .error(previous: "Value", error: TestError.error),
            .some("Value")
        ]

        let mapped = sut.filterValues { value in value == "Value" }

        XCTAssertEqual(mapped, expected)
    }

    //MARK: First Value
    func test_array_firstValue() {
        let sut: [Loadable<String>] = [
            .none,
            .loading(previous: nil),
            .loading(previous: "Value"),
            .error(previous: nil, error: TestError.error),
            .error(previous: "Value", error: TestError.error),
            .some("Value")
        ]

        let expected = Loadable<String>.loading(previous: "Value")

        let mapped = sut.firstValue { value in value == "Value" }

        XCTAssertEqual(mapped, expected)
    }

    //MARK: Sorting
    func test_sorted_by_ascending() {
        let input: [Loadable<String>] = [
            .none,
            .loading(previous: nil),
            .error(previous: nil, error: TestError.error),
            .loading(previous: "c"),
            .error(previous: "b", error: TestError.error),
            .some("a")
        ]

        let expectedOutput: [Loadable<String>] = [
            .some("a"),
            .error(previous: "b", error: TestError.error),
            .loading(previous: "c"),
            .none,
            .loading(previous: nil),
            .error(previous: nil, error: TestError.error)
        ]

        let output = input.sortedValues(by: <)

        XCTAssertEqual(expectedOutput, output)
    }

    func test_sorted_by_descending() {
        let input: [Loadable<String>] = [
            .none,
            .loading(previous: nil),
            .error(previous: nil, error: TestError.error),
            .loading(previous: "c"),
            .error(previous: "b", error: TestError.error),
            .some("a")
        ]

        let expectedOutput: [Loadable<String>] = [
            .loading(previous: "c"),
            .error(previous: "b", error: TestError.error),
            .some("a"),
            .none,
            .loading(previous: nil),
            .error(previous: nil, error: TestError.error)
        ]

        let output = input.sortedValues(by: >)

        XCTAssertEqual(expectedOutput, output)
    }
}
