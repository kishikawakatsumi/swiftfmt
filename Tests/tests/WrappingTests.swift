//
//  WrappingTests.swift
//  tests
//
//  Created by Kishikawa Katsumi on 2018/02/19.
//

import XCTest
@testable import swiftfmt_core

class WrappingTests : XCTestCase {
    func testWrappingIfStatementElse() {
        let source = """
            public class Foo {
                func foo(value: String?) {
                    let defValue: String? = ""

                    if (value != nil) {
                        print(value)
                    } else if (defValue != nil) {
                        print(defValue)
                    } else {
                        print("Error")
                    }
                    guard value ?? defValue != nil else {
                        return
                    }
                }
            }
            """

        let expected = """
            public class Foo {
                func foo(value: String?) {
                    let defValue: String? = ""

                    if (value != nil) {
                        print(value)
                    }
                    else if (defValue != nil) {
                        print(defValue)
                    }
                    else {
                        print("Error")
                    }
                    guard value ?? defValue != nil
                    else {
                        return
                    }
                }
            }

            """

        let runner = TestRunner()

        var configuration = Configuration()
        configuration.wrapping.ifStatement.elseOnNewLine = true
        configuration.wrapping.guardStatement.elseOnNewLine = true

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testWrappingRepeatWhileStatementWhile() {
        let source = """
            public class Foo {
                func foo(value: Int) {
                    var value = value

                    repeat {
                        value += 1
                    } while value > 0
                }
            }
            """

        let expected = """
            public class Foo {
                func foo(value: Int) {
                    var value = value

                    repeat {
                        value += 1
                    }
                    while value > 0
                }
            }

            """

        let runner = TestRunner()

        var configuration = Configuration()
        configuration.wrapping.ifStatement.elseOnNewLine = true
        configuration.wrapping.guardStatement.elseOnNewLine = true
        configuration.wrapping.repeatWhileStatement.whileOnNewLine = true

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testWrappingDoStatementCatch() {
        let source = """
            public class Foo {
                func foo() throws {
                    do {
                        try foo()
                    } catch {
                        print(error)
                    }
                }
            }
            """

        let expected = """
            public class Foo {
                func foo() throws {
                    do {
                        try foo()
                    }
                    catch {
                        print(error)
                    }
                }
            }

            """

        let runner = TestRunner()

        var configuration = Configuration()
        configuration.wrapping.ifStatement.elseOnNewLine = true
        configuration.wrapping.guardStatement.elseOnNewLine = true
        configuration.wrapping.repeatWhileStatement.whileOnNewLine = true
        configuration.wrapping.doStatement.catchOnNewLine = true

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testWrapSwitchStatementCaseBranches() {
        let source = """
            public class Foo {
                func foo(x: Int, y: Int, z: Int) {
                    switch x {
                        case 0: break case 1: print(y)
                            print(z)
                        default:
                            print(y)
                            print(z)
                    }
                }
            }
            """

        let expected = """
            public class Foo {
                func foo(x: Int, y: Int, z: Int) {
                    switch x {
                        case 0: break case 1: print(y)
                            print(z)
                        default:
                            print(y)
                            print(z)
                    }
                }
            }

            """

        let runner = TestRunner()

        var configuration = Configuration()
        configuration.indentation.indentCaseBranches = true

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testElseOnSameline() {
        let source = """
            if (headerFooter.header == DefaultHeaderText) {
                self.headerText = nil
            }
            else if (headerFooter.header != "") {
                self.headerText = headerFooter.header
            }
            """

        let expected = """
            if (headerFooter.header == DefaultHeaderText) {
                self.headerText = nil
            } else if (headerFooter.header != "") {
                self.headerText = headerFooter.header
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }
}
