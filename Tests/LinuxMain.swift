import XCTest
@testable import swiftfmt_core

extension AlignmentTests {
    static var allTests: [(String, (AlignmentTests) -> () throws -> Void)] = [
        ("testAlignFunctionDeclarationParameters1()", testAlignFunctionDeclarationParameters1),
        ("testAlignFunctionDeclarationParameters2()", testAlignFunctionDeclarationParameters2),
        ("testAlignFunctionDeclarationParameters3()", testAlignFunctionDeclarationParameters3),
        ("testAlignFunctionCallArguments1()", testAlignFunctionCallArguments1),
        ("testAlignFunctionCallArguments2()", testAlignFunctionCallArguments2),
    ]
}

extension BlankLineTest {
    static var allTests: [(String, (BlankLineTest) -> () throws -> Void)] = [
        ("testFormatBlankLines()", testFormatBlankLines),
        ("testImportDeclarationAfterBlankLines()", testImportDeclarationAfterBlankLines),
        ("testFormatDeclarationInMultipleLines()", testFormatDeclarationInMultipleLines),
        ("testKeepMaximumBlankLines()", testKeepMaximumBlankLines),
        ("testShouldNotInsertBlankLineBeforeFunctionsAfterComment()", testShouldNotInsertBlankLineBeforeFunctionsAfterComment),
        ("testBlockComments()", testBlockComments),
        ("testShouldNotChangeFunctionBody()", testShouldNotChangeFunctionBody),
    ]
}

XCTMain([
    testCase(AlignmentTests.allTests),
    testCase(BlankLineTest.allTests),
//    testCase(BraceTests.allTests),
//    testCase(ConfigurationTests.allTests),
//    testCase(IndentationTests.allTests),
//    testCase(SemicolonTests.allTests),
//    testCase(SpaceTests.allTests),
//    testCase(WrappingTests.allTests),
])
