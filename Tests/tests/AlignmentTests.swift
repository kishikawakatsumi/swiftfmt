//
//  AlignmentTests.swift
//  tests
//
//  Created by Kishikawa Katsumi on 2018/02/21.
//

import XCTest
@testable import swiftfmt_core

class AlignmentTests : XCTestCase {
    func testAlignFunctionDeclarationParameters1() {
        let source = """
            func bar(name: String,
                _ title: String,
                _ order: Int,
                label text: String) {

            }
            """

        let expected = """
            func bar(name: String,
                     _ title: String,
                     _ order: Int,
                     label text: String) {

            }

            """

        let runner = TestRunner()
        var configuration = Configuration()
        configuration.wrapping.alignment.functionDeclarationParameters.alignWhenMultiline = true

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testAlignFunctionDeclarationParameters2() {
        let source = """
            func bar(name: String,
                     _ title: String,
                     _ order: Int,
                     label text: String) {

            }
            """

        let expected = """
            func bar(name: String,
                _ title: String,
                _ order: Int,
                label text: String) {

            }

            """

        let runner = TestRunner()
        var configuration = Configuration()
        configuration.wrapping.alignment.functionDeclarationParameters.alignWhenMultiline = false

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testAlignFunctionDeclarationParameters3() {
        let source = """
            func bar(
                     name: String,
                     _ title: String,
                     _ order: Int,
                     label text: String) {

            }
            """

        let expected = """
            func bar(
                name: String,
                _ title: String,
                _ order: Int,
                label text: String) {

            }

            """

        let runner = TestRunner()
        var configuration = Configuration()
        configuration.wrapping.alignment.functionDeclarationParameters.alignWhenMultiline = false

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testAlignFunctionCallArguments1() {
        let source = """
            foobar(name: "name",
                "title",
                0,
                label: "name")
            """

        let expected = """
            foobar(name: "name",
                   "title",
                   0,
                   label: "name")

            """

        let runner = TestRunner()
        var configuration = Configuration()
        configuration.wrapping.alignment.functionCallArguments.alignWhenMultiline = true

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }

    func testAlignFunctionCallArguments2() {
        let source = """
            foobar(name: "name",
                   "title",
                   0,
                   label: "name")
            """

        let expected = """
            foobar(name: "name",
                "title",
                0,
                label: "name")

            """

        let runner = TestRunner()
        var configuration = Configuration()
        configuration.wrapping.alignment.functionCallArguments.alignWhenMultiline = false

        let result = runner.run(source: source, configuration: configuration)
        XCTAssertEqual(result, expected)
    }
}
