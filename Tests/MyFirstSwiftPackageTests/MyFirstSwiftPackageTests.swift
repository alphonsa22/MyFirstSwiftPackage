import XCTest
@testable import MyFirstSwiftPackage

final class MyFirstSwiftPackageTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MyFirstSwiftPackage().text, "Hello, World!")
    }
}
