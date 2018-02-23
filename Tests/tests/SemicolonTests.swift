//
//  SemicolonTests.swift
//  tests
//
//  Created by Kishikawa Katsumi on 2018/02/19.
//

import XCTest
@testable import swiftfmt_core

class SemicolonTests : XCTestCase {
    func testFormatSemicolons() {
        let source = """
            import Foundation; import SwiftSyntax; class Foo {}; protocol FooProtocol {};

            struct Bar {};
            enum Baz {}; struct FooBar {};
            """

        let expected = """
            import Foundation;
            import SwiftSyntax;

            class Foo {};

            protocol FooProtocol {};

            struct Bar {};

            enum Baz {};

            struct FooBar {};

            """

        let runner = TestRunner()
        var configuration = Configuration()
        configuration.shouldRemoveSemicons = false

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testRemoveSemicolons() {
        let source = """
            import Foundation; import SwiftSyntax; class Foo {}; protocol FooProtocol {};

            struct Bar {};
            enum Baz {}; struct FooBar {};
            """

        let expected = """
            import Foundation
            import SwiftSyntax

            class Foo {}

            protocol FooProtocol {}

            struct Bar {}

            enum Baz {}

            struct FooBar {}

            """

        let runner = TestRunner()
        var configuration = Configuration()
        configuration.shouldRemoveSemicons = true

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }
}
