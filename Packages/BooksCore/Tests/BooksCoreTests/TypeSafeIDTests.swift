@testable import BooksCore
import XCTest

final class TypeSafeIDTests: XCTestCase {
    struct Element: Codable, Equatable, TypeSafeIdentifiable {
        let id: ID
    }

    struct IntElement: Codable, Equatable, TypeSafeIdentifiable {
        typealias RawID = Int
        let id: ID
    }

    // MARK: - String based IDs
    func test_decodes() throws {
        let expectedElement = Element(id: "123")

        let data = "{\"id\": \"123\"}".data(using: .utf8)!

        let decodedElement = try JSONDecoder().decode(Element.self, from: data)

        XCTAssertEqual(expectedElement, decodedElement)
    }

    func test_encodes() throws {
        let element = Element(id: "123")
        let expectedData = "{\"id\":\"123\"}".data(using: .utf8)

        let encodedData = try JSONEncoder().encode(element)

        XCTAssertEqual(expectedData, encodedData)
    }

    func test_description() {
        let elementID = Element.ID(id: "123")
        let expectedDescription = "Element(123)"

        XCTAssertEqual(elementID.description, expectedDescription)
    }

    func test_equality() {
        let elementID = Element.ID(id: "123")
        let otherElementID = Element.ID(id: "234")

        XCTAssertEqual(elementID, elementID)
        XCTAssertEqual(otherElementID, otherElementID)
        XCTAssertNotEqual(elementID, otherElementID)
    }

    func test_hash() {
        let id = "123"
        let elementID = Element.ID(id: id)

        XCTAssertEqual(id.hashValue, elementID.hashValue)
    }

    func test_hash_into() {
        let id = "123"
        let elementID = Element.ID(id: id)

        var hasher = Hasher()
        elementID.hash(into: &hasher)

        let hash = hasher.finalize()
        XCTAssertEqual(id.hashValue, hash)
    }

    // MARK: - Int based IDs
    func test_IntIdentifier_decodes() throws {
        let expectedElement = IntElement(id: 123)

        let data = "{\"id\": 123}".data(using: .utf8)!

        let decodedElement = try JSONDecoder().decode(IntElement.self, from: data)

        XCTAssertEqual(expectedElement, decodedElement)
    }

    func test_IntIdentifier_encodes() throws {
        let element = IntElement(id: 123)
        let expectedData = "{\"id\":123}".data(using: .utf8)

        let encodedData = try JSONEncoder().encode(element)

        XCTAssertEqual(expectedData, encodedData)
    }

    func test_IntIdentifier_description() {
        let elementID = IntElement.ID(id: 123)
        let expectedDescription = "IntElement(123)"

        XCTAssertEqual(elementID.description, expectedDescription)
    }

    func test_IntIdentifier_equality() {
        let elementID = IntElement.ID(id: 123)
        let otherElementID = IntElement.ID(id: 234)

        XCTAssertEqual(elementID, elementID)
        XCTAssertEqual(otherElementID, otherElementID)
        XCTAssertNotEqual(elementID, otherElementID)
    }

    func test_IntIdentifier_hash() {
        let id = 123
        let elementID = IntElement.ID(id: id)

        XCTAssertEqual(id.hashValue, elementID.hashValue)
    }

    func test_IntIdentifier_hash_into() {
        let id = 123
        let elementID = IntElement.ID(id: id)

        var hasher = Hasher()
        elementID.hash(into: &hasher)

        let hash = hasher.finalize()
        XCTAssertEqual(id.hashValue, hash)
    }
}
