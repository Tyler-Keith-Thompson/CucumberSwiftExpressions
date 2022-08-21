//  swiftlint:disable file_types_order

import XCTest
import CucumberSwiftExpressions

final class CucumberSwiftExpressionsTests: XCTestCase {
    func testCucumberExpressionGeneratesCorrectRegexForOptional() {
        var expression = CucumberExpression(#"There were 3 flight(s) from LAX."#)
        XCTAssertEqual(expression.regex, #"^There were 3 flight(s)? from LAX\.$"#)
    }

    func testOptionalTextIsEscaped() {
        var expression = CucumberExpression(#"There were 3 flight(s.) from LAX."#)
        XCTAssertEqual(expression.regex, #"^There were 3 flight(s\.)? from LAX\.$"#)
    }

    func testCucumberExpressionGeneratesCorrectRegexForAlternate() {
        var expression = CucumberExpression(#"There is/are/were 3 flights from LAX."#)
        XCTAssertEqual(expression.regex, #"^There (is|are|were) 3 flights from LAX\.$"#)
    }

    func testAlternateTextIsEscaped() {
        var expression = CucumberExpression(#"There is./are/were 3 flights from LAX."#)
        XCTAssertEqual(expression.regex, #"^There (is\.|are|were) 3 flights from LAX\.$"#)
    }

    func testCucumberExpressionGeneratesCorrectRegexForStringParameter() {
        var expression = CucumberExpression("The button says {string}.")
        XCTAssertEqual(expression.regex, #"^The button says ("([^"\\]*(\\.[^"\\]*)*)"|'([^'\\]*(\\.[^'\\]*)*)')\.$"#)
    }

    func testCucumberExpressionGeneratesCorrectRegexForIntParameter() {
        var expression = CucumberExpression(#"There are {int} flights from LAX."#)
        XCTAssertEqual(expression.regex, #"^There are (-?\d+) flights from LAX\.$"#)
    }

    func testCucumberExpressionGeneratesCorrectRegexForWordParameter() {
        var expression = CucumberExpression(#"There are {word} flights from LAX."#)
        XCTAssertEqual(expression.regex, #"^There are ([^\s]+) flights from LAX\.$"#)
    }

    func testCucumberExpressionGeneratesCorrectRegexForFloatParameter() {
        var expression = CucumberExpression(#"There are {float} flights from LAX."#)
        XCTAssertEqual(expression.regex, #"^There are ((?=.*\d.*)[-+]?\d*(?:\.(?=\d.*))?\d*(?:\d+[E][+-]?\d+)?) flights from LAX\.$"#)
    }

    func testCucumberExpressionGeneratesCorrectRegexForDoubleParameter() {
        var expression = CucumberExpression(#"There are {double} flights from LAX."#)
        XCTAssertEqual(expression.regex, #"^There are ((?=.*\d.*)[-+]?\d*(?:\.(?=\d.*))?\d*(?:\d+[E][+-]?\d+)?) flights from LAX\.$"#)
    }

    func testCucumberExpressionGeneratesCorrectRegexForAnonymousParameter() {
        var expression = CucumberExpression(#"There are {} flights from LAX."#)
        XCTAssertEqual(expression.regex, #"^There are (.*) flights from LAX\.$"#)
    }

    func testCucumberExpressionGeneratesCorrectRegexComplexExpression() {
        var expression = CucumberExpression(#"There is/are/were {int} flight(s) from {airport}."#)
        XCTAssertEqual(expression.regex, #"^There (is|are|were) (-?\d+) flight(s)? from ([A-Z]{3})\.$"#)
    }
}

// swiftlint:disable:next convenience_type
struct Airport {
    static let lax = Airport()
}

extension CucumberExpression: CustomParameters {
    public static var additionalParameters: [CucumberSwiftExpressions.AnyParameter] {
        [
            Parameters.airport.eraseToAnyParameter()
        ]
    }
}

struct AirportParameter: Parameter {
    enum ParameterError: Error {
        case airportNotFound
    }

    static let name = "airport"

    let regexMatch = #"[A-Z]{3}"#

    func convert(input: String) throws -> Airport {
        switch input.lowercased() {
            case "lax": return Airport.lax
            default:
                throw ParameterError.airportNotFound
        }
    }
}

extension Parameters {
    static let airport = AirportParameter()
}
