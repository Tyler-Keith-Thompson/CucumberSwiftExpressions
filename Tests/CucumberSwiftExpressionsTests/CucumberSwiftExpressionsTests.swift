import XCTest
import CucumberSwiftExpressions

final class CucumberSwiftExpressionsTests: XCTestCase {
    func testCucumberExpressionGeneratesCorrectRegexForOptional() {
        var expression = CucumberExpression(#"There were 3 flight(s) from LAX."#)
        XCTAssertEqual(expression.regex, #"^There were 3 flight(?:s)? from LAX\.$"#)
    }

    func testOptionalTextIsEscaped() {
        var expression = CucumberExpression(#"There were 3 flight(s.) from LAX."#)
        XCTAssertEqual(expression.regex, #"^There were 3 flight(?:s\.)? from LAX\.$"#)
    }

    func testCucumberExpressionGeneratesCorrectRegexForAlternate() {
        var expression = CucumberExpression(#"There is/are/were 3 flights from LAX."#)
        XCTAssertEqual(expression.regex, #"^There (?:is|are|were) 3 flights from LAX\.$"#)
    }

    func testAlternateTextIsEscaped() {
        var expression = CucumberExpression(#"There is./are/were 3 flights from LAX."#)
        XCTAssertEqual(expression.regex, #"^There (?:is\.|are|were) 3 flights from LAX\.$"#)
    }

    func testCucumberExpressionGeneratesCorrectRegexForStringParameter() {

    }
//    func testExample() throws {
//        let tokens = Lexer(#"there is/are/were {int} flight(s) from {airport}"#).lex()
//        print(tokens)
//    }
}
