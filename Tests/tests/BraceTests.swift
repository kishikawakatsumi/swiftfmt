//
//  BraceTests.swift
//  tests
//
//  Created by Kishikawa Katsumi on 2018/02/18.
//

import XCTest
@testable import swiftfmt_core

class BraceTests : XCTestCase {
    func testWrapLeftBracesInTypeDeclaration() {
        let source = """
            public class Foo {
                func foo() {

                }
            }
            """

        let expected = """
            public class Foo
            {
                func foo() {

                }
            }

            """

        let runner = TestRunner()

        var configuration = Configuration()
        configuration.braces.placement.inTypeDeclarations = .nextLine

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testWrapLeftBracesInFunctionDeclaration() {
        let source = """
            public class Foo
            {
                func foo() {

                }
            }
            """

        let expected = """
            public class Foo {
                func foo()
                {

                }
            }

            """

        let runner = TestRunner()

        var configuration = Configuration()
        configuration.braces.placement.inTypeDeclarations = .endOfLine
        configuration.braces.placement.inFunctions = .nextLine

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testWrapLeftBraces() {
        let source = """
            public class Foo {
                func foo() {
                    let x = 0
                    if x > 0 {

                    } else if x > 1 {

                    } else {

                    }
                }
            }
            """

        let expected = """
            public class Foo
            {
                func foo()
                {
                    let x = 0
                    if x > 0
                    {

                    } else if x > 1
                    {

                    } else
                    {

                    }
                }
            }

            """

        let runner = TestRunner()

        var configuration = Configuration()
        configuration.braces.placement.inTypeDeclarations = .nextLine
        configuration.braces.placement.inFunctions = .nextLine
        configuration.braces.placement.inOther = .nextLine

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testWrapClosingBraces() {
        let source = """
            public class Foo {
                func foo() {
                    let x = 0
                    if x > 0 {
                        print(x)
                        print(x)
                    } else if x > 1 {

                    } else {
                        print(x)
                        print(x) } } }
            """

        let expected = """
            public class Foo {
                func foo() {
                    let x = 0
                    if x > 0 {
                        print(x)
                        print(x)
                    } else if x > 1 {

                    } else {
                        print(x)
                        print(x)
                    }
                }
            }

            """

        let runner = TestRunner()

        var configuration = Configuration()
        configuration.braces.placement.inTypeDeclarations = .endOfLine
        configuration.braces.placement.inFunctions = .endOfLine
        configuration.braces.placement.inOther = .endOfLine

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }
}
