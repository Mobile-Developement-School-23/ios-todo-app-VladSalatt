import XCTest
@testable import TodoList

final class TodoListTests: XCTestCase {

    var fileCache: FileCache?

    override func setUpWithError() throws {
        try super.setUpWithError()
        fileCache = FileCache(fileManager: .default)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        fileCache = nil
    }

    func testValidParseJSON() {
        // given
        let validJson = Seeds.validJSON

        // when
        let item = TodoItem.parse(with: validJson)

        // then
        XCTAssertNotNil(item)
    }

    func testInvalidParseJSON() {
        // given
        let invalidJson = Seeds.invalidJSON

        // when
        let item = TodoItem.parse(with: invalidJson)

        // then
        XCTAssertNil(item)
    }

    func testValidParseCSV() {
        // given
        let validCSV = Seeds.validCSV

        // when
        let item = TodoItem.parse(with: validCSV)

        // then
        XCTAssertNotNil(item)
    }
    func testInvalidParseCSV() {
        // given
        let invalidCSV = Seeds.invalidCSV

        // when
        let item = TodoItem.parse(with: invalidCSV)

        // then
        XCTAssertNil(item)
    }

    func testAddToFileCache() {
        // given
        let items = Seeds.todoItems

        // when
        items.forEach { fileCache?.add($0) }

        // then
        XCTAssertTrue(fileCache?.items.values.count == 3)
    }

    func testDeleteFromFileCache() {
        // given
        Seeds.todoItems.forEach { fileCache?.add($0) }

        // when
        fileCache?.deleteItem(with: "2")

        // then
        XCTAssertNil(fileCache?.items.values.firstIndex(where: { $0.id == "2"}))
    }

    func testDateAsTimestampInJson() throws {
        // given
        let item = Seeds.todoItem

        // when
        let dict = try XCTUnwrap(item.json as? [String: Any])
        let date = try XCTUnwrap(dict["created_at"])

        // then
        XCTAssertTrue(date is TimeInterval)
    }

    func testDateAsTimestampInCsv() {
        // given
        let item = Seeds.todoItem

        // when
        let date = item.csv.split(separator: ",").map(String.init)[5]
        let timeInterval = TimeInterval(date)

        // then
        XCTAssertNotNil(timeInterval)
    }
}

private enum Seeds {
    static let validJSON: [String: Any] = [
        "id": "1",
        "text": "text",
        "importance": "low",
        "deadline": 44343.1,
        "done": true,
        "created_at": 443434.1,
        "changed_at": 434433.1
    ]

    static let invalidJSON: [String: Any] = [
        "id": 1,
        "text": "text",
        "importance": "low",
        "deadline": 44343.1,
        "done": true,
        "created_at": 443434.1,
        "changed_at": 434433.1
    ]

    static let validCSV: String = "1, test, basic, 434343.3, false, 545433.3, 432432.2"
    static let invalidCSV: String = "test, basic, 434343.3, false, 545433.3, 432432.2"

    static let todoItem: TodoItem = TodoItem(
        id: "1",
        text: "test",
        importance: .low,
        deadline: Date(),
        isDone: false,
        createdAt: Date(),
        changedAt: Date()
    )

    static let todoItems: [TodoItem] = [
        TodoItem(id: "1", text: "one"),
        TodoItem(id: "2", text: "second"),
        TodoItem(id: "3", text: "third")
    ]
}
