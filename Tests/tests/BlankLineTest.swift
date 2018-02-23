//
//  BlankLineTest.swift
//  tests
//
//  Created by Kishikawa Katsumi on 2018/02/19.
//

import XCTest
@testable import swiftfmt_core

class BlankLineTests : XCTestCase {
    func testFormatBlankLines() {
        let source = """
            // swiftfmt
            import Foundation
            import SwiftSyntax
            class Foo {
                let string = "string"
                let integer = 0
                func foo() -> String {
                    if integer > 0 {

                    }
                }
                func bar() -> Int {

                }
            }
            protocol FooProtocol {
                let string: String
                let integer: Int
                func foo() -> String
                func bar() -> Int
            }
            struct Bar {}
            enum Baz {}
            struct FooBar {}
            """

        let expected = """
            // swiftfmt

            import Foundation
            import SwiftSyntax

            class Foo {
                let string = "string"
                let integer = 0

                func foo() -> String {
                    if integer > 0 {

                    }
                }

                func bar() -> Int {

                }
            }

            protocol FooProtocol {
                let string: String
                let integer: Int
                func foo() -> String
                func bar() -> Int
            }

            struct Bar {}

            enum Baz {}

            struct FooBar {}

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testImportDeclarationAfterBlankLines() {
        let source = """
            // swiftfmt

            import Foundation
            import SwiftSyntax
            class Foo {
                let string = "string"
                let integer = 0
                func foo() -> String {
                    if integer > 0 {

                    }
                }
                func bar() -> Int {

                }
            }
            protocol FooProtocol {
                let string: String
                let integer: Int
                func foo() -> String
                func bar() -> Int
            }
            struct Bar {}
            enum Baz {}
            struct FooBar {}
            """

        let expected = """
            // swiftfmt

            import Foundation
            import SwiftSyntax

            class Foo {
                let string = "string"
                let integer = 0

                func foo() -> String {
                    if integer > 0 {

                    }
                }

                func bar() -> Int {

                }
            }

            protocol FooProtocol {
                let string: String
                let integer: Int
                func foo() -> String
                func bar() -> Int
            }

            struct Bar {}

            enum Baz {}

            struct FooBar {}

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testFormatDeclarationInMultipleLines() {
        let source = """
            import Foundation
            import
            SwiftSyntax
            public
            class Foo {
                @available(*,unavailable,renamed: "bar()")
                func foo() {

                }

                @available(*, unavailable, renamed: "bar()")
                func bar() {

                }

                @objc
                func baz() {

                }

                public
                func
                    barbaz() {

                }
            }
            """

        let expected = """
            import Foundation
            import
            SwiftSyntax

            public
            class Foo {
                @available(*, unavailable, renamed: "bar()")
                func foo() {

                }

                @available(*, unavailable, renamed: "bar()")
                func bar() {

                }

                @objc
                func baz() {

                }

                public
                func
                barbaz() {

                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testKeepMaximumBlankLines() {
        let source = """
            // swiftfmt
            import Foundation
            import SwiftSyntax




            class Foo {
                let string = "string"
                let integer = 0




                func foo() -> String {




                    if integer > 0 {




                        let x = integer
                        let y = integer




                        print(x + y)




                    }




                }
                func bar() -> Int {

                }
            }
            """

        let expected = """
            // swiftfmt

            import Foundation
            import SwiftSyntax



            class Foo {
                let string = "string"
                let integer = 0



                func foo() -> String {


                    if integer > 0 {


                        let x = integer
                        let y = integer


                        print(x + y)

                    }

                }

                func bar() -> Int {

                }
            }

            """

        let runner = TestRunner()
        var configuration = Configuration()
        configuration.blankLines.keepMaximumBlankLines.inDeclarations = 3
        configuration.blankLines.keepMaximumBlankLines.inCode = 2
        configuration.blankLines.keepMaximumBlankLines.beforeClosingBrace = 1

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testShouldNotInsertBlankLineBeforeFunctionsAfterComment() {
        let source = """
            public class Foo : NSObject {
                /// Doc comment
                let string = "string"
                let integer = 0

                /// Doc comment
                func foo() -> String {
                    var x = 1
                    var y: Int = 1
                    x += (x ^ 0x123) << 2
                }
            }
            """

        let expected = """
            public class Foo : NSObject {
                /// Doc comment
                let string = "string"
                let integer = 0

                /// Doc comment
                func foo() -> String {
                    var x = 1
                    var y: Int = 1
                    x += (x ^ 0x123) << 2
                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testBlockComments() {
        let source = """
            public class Foo : NSObject {
                /* comment */
                let string = "string"
                let integer = 0

                /*
                 comment
                 */
                func foo() -> String {
                    /*
                     comment
                     */
                    var x = 1
                    var y: Int = 1
                    x += (x ^ 0x123) << 2
                }
            }
            """
        let expected = """
            public class Foo : NSObject {
                /* comment */
                let string = "string"
                let integer = 0

                /*
                 comment
                 */
                func foo() -> String {
                    /*
                     comment
                     */
                    var x = 1
                    var y: Int = 1
                    x += (x ^ 0x123) << 2
                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testShouldNotChangeFunctionBody() {
        let source = """
            public class Foo : NSObject {
                func foo() -> String {
                    var x = 1
                    var y: Int = 1
                    x += (x ^ 0x123) << 2
                }
            }
            """

        let expected = """
            public class Foo : NSObject {
                func foo() -> String {
                    var x = 1
                    var y: Int = 1
                    x += (x ^ 0x123) << 2
                }
            }

            """

        let runner = TestRunner()
        let configuration = Configuration()

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }
}
