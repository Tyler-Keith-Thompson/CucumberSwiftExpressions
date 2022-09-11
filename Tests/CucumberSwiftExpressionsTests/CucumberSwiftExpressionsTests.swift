//  swiftlint:disable file_types_order

import XCTest
import CucumberSwiftExpressions

final class CucumberSwiftExpressionsTests: XCTestCase {
    func testPlainCucumberExpression() {
        let expression: CucumberExpression = "the member has A"
        XCTAssertNotNil(expression.match(in: "the member has A"))
        XCTAssertNil(expression.match(in: "the member has B"))
        XCTAssertNil(expression.match(in: "the member has C"))
    }
    
    func testCucumberExpressionGeneratesCorrectRegexForOptional() {
        let expression = CucumberExpression(#"There were 3 flight(s) from LAX."#)
        XCTAssertEqual(expression.regex, #"^There were 3 flight(?:s)? from LAX\.$"#)
    }

    func testOptionalTextIsEscaped() {
        let expression = CucumberExpression(#"There were 3 flight(s.) from LAX."#)
        XCTAssertEqual(expression.regex, #"^There were 3 flight(?:s\.)? from LAX\.$"#)
    }

    func testCucumberExpressionGeneratesCorrectRegexForAlternate() {
        let expression = CucumberExpression(#"There is/are/were 3 flights from LAX."#)
        XCTAssertEqual(expression.regex, #"^There (?:is|are|were) 3 flights from LAX\.$"#)
    }

    func testAlternateTextIsEscaped() {
        let expression = CucumberExpression(#"There is./are/were 3 flights from LAX."#)
        XCTAssertEqual(expression.regex, #"^There (?:is\.|are|were) 3 flights from LAX\.$"#)
    }

    func testCucumberExpressionGeneratesCorrectRegexForStringParameter() {
        let expression = CucumberExpression("The button says {string}.")
        XCTAssertEqual(expression.regex, #"^The button says ("([^"\\]*(\\.[^"\\]*)*)"|'([^'\\]*(\\.[^'\\]*)*)')\.$"#)
    }

    func testStringMatches() throws {
        let expression = CucumberExpression("The {string} says {string}.")
        let match = try XCTUnwrap(expression.match(in: #"The "button" says "sign in"."#))
        XCTAssertEqual(match[\.string, index: 0], "button")
        XCTAssertEqual(match[\.string, index: 1], "sign in")
        XCTAssertEqual(try match.first(\.string), "button")
        XCTAssertEqual(try match.last(\.string), "sign in")
        XCTAssertEqual(try match.allParameters(\.string), ["button", "sign in"])
    }

    func testCucumberExpressionGeneratesCorrectRegexForIntParameter() {
        let expression = CucumberExpression(#"There are {int} flights from LAX."#)
        XCTAssertEqual(expression.regex, #"^There are (-?\d+) flights from LAX\.$"#)
    }

    func testIntMatches() throws {
        let expression = CucumberExpression("There are {int} flights from LAX.")
        let match = try XCTUnwrap(expression.match(in: #"There are 3 flights from LAX."#))
        XCTAssertEqual(match[\.int, index: 0], 3)
        XCTAssertEqual(try match.first(\.int), 3)
        XCTAssertEqual(try match.last(\.int), 3)
        XCTAssertEqual(try match.allParameters(\.int), [3])
    }

    func testCucumberExpressionGeneratesCorrectRegexForWordParameter() {
        let expression = CucumberExpression(#"There are {word} flights from LAX."#)
        XCTAssertEqual(expression.regex, #"^There are ([^\s]+) flights from LAX\.$"#)
    }

    func testWordMatches() throws {
        let expression = CucumberExpression("There are {word} flights from LAX.")
        let match = try XCTUnwrap(expression.match(in: #"There are three flights from LAX."#))
        XCTAssertEqual(match[\.word, index: 0], "three")
        XCTAssertEqual(try match.first(\.word), "three")
        XCTAssertEqual(try match.last(\.word), "three")
        XCTAssertEqual(try match.allParameters(\.word), ["three"])
    }

    func testCucumberExpressionGeneratesCorrectRegexForFloatParameter() {
        let expression = CucumberExpression(#"There are {float} flights from LAX."#)
        XCTAssertEqual(expression.regex, #"^There are ((?=.*\d.*)[-+]?\d*(?:\.(?=\d.*))?\d*(?:\d+[E][+-]?\d+)?) flights from LAX\.$"#)
    }

    func testFloatMatches() throws {
        let expression = CucumberExpression("There are {float} flights from LAX.")
        let match = try XCTUnwrap(expression.match(in: #"There are 3.5 flights from LAX."#))
        XCTAssertEqual(match[\.float, index: 0], 3.5)
        XCTAssertEqual(try match.first(\.float), 3.5)
        XCTAssertEqual(try match.last(\.float), 3.5)
        XCTAssertEqual(try match.allParameters(\.float), [3.5])
    }

    func testCucumberExpressionGeneratesCorrectRegexForDoubleParameter() {
        let expression = CucumberExpression(#"There are {double} flights from LAX."#)
        XCTAssertEqual(expression.regex, #"^There are ((?=.*\d.*)[-+]?\d*(?:\.(?=\d.*))?\d*(?:\d+[E][+-]?\d+)?) flights from LAX\.$"#)
    }

    func testDoubleMatches() throws {
        let expression = CucumberExpression("There are {double} flights from LAX.")
        let match = try XCTUnwrap(expression.match(in: #"There are 3.1 flights from LAX."#))
        XCTAssertEqual(match[\.double, index: 0], 3.1)
        XCTAssertEqual(try match.first(\.double), 3.1)
        XCTAssertEqual(try match.last(\.double), 3.1)
        XCTAssertEqual(try match.allParameters(\.double), [3.1])
    }

    func testCucumberExpressionGeneratesCorrectRegexForAnonymousParameter() {
        let expression = CucumberExpression(#"There are {} flights from LAX."#)
        XCTAssertEqual(expression.regex, #"^There are (.*) flights from LAX\.$"#)
    }

    func testAnonymousMatches() throws {
        let expression = CucumberExpression("There are {} flights from LAX.")
        let match = try XCTUnwrap(expression.match(in: #"There are some number of flights from LAX."#))
        XCTAssertEqual(match[\.anonymous, index: 0], "some number of")
        XCTAssertEqual(try match.first(\.anonymous), "some number of")
        XCTAssertEqual(try match.last(\.anonymous), "some number of")
        XCTAssertEqual(try match.allParameters(\.anonymous), ["some number of"])
    }

    func testCucumberExpressionGeneratesCorrectRegexComplexExpression() {
        let expression = CucumberExpression(#"There is/are/were {int} flight(s) from {airport}."#)
        XCTAssertEqual(expression.regex, #"^There (?:is|are|were) (-?\d+) flight(?:s)? from ([A-Z]{3})\.$"#)
    }

    func testComplexMatches() throws {
        let expression = CucumberExpression(#"There is/are/were {int} flight(s) from {airport}."#)
        let match = try XCTUnwrap(expression.match(in: #"There are 3 flights from LAX."#))
        XCTAssertEqual(match[\.int, index: 0], 3)
        XCTAssertEqual(try match.first(\.int), 3)
        XCTAssertEqual(try match.last(\.int), 3)
        XCTAssertEqual(try match.allParameters(\.int), [3])
        XCTAssertIdentical(match[\.airport, index: 0], Airport.lax)
        XCTAssertIdentical(try match.first(\.airport), Airport.lax)
        XCTAssertIdentical(try match.last(\.airport), Airport.lax)
        XCTAssertEqual(try match.allParameters(\.airport).count, 1)
        XCTAssertIdentical(try match.allParameters(\.airport).first, Airport.lax)
    }
}

// swiftlint:disable:next convenience_type
class Airport {
    static let lax = Airport()
}

extension CucumberExpression: CustomParameters {
    public static var additionalParameters: [CucumberSwiftExpressions.AnyParameter] {
        [
            AirportParameter().eraseToAnyParameter()
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

extension Match {
    var airport: AirportParameter {
        AirportParameter()
    }
}
