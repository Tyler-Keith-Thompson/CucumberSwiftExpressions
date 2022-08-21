import XCTest
@testable import CucumberSwiftExpressions

final class CucumberSwiftExpressionsTests: XCTestCase {
    func testExample() throws {
        let tokens = Lexer(#"there is/are/were {int} flight(s) from {airport}"#).lex()
        print(tokens)
    }
}
