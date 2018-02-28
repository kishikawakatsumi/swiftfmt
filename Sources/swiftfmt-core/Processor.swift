//
//  Processor.swift
//  swiftfmt-core
//
//  Created by Kishikawa Katsumi on 2018/02/14.
//

import Foundation
import Basic
import SwiftSyntax

public struct Processor {
    public init() {}

    public func processFile(input fileURL: URL, configuration: Configuration, verbose: Bool = false) throws -> String {
        let tokens = try tokenize(fileURL: fileURL, configuration: configuration)

        let formatter = SourceFormatter(tokenFormatters: [SemicolonFormatter(), SpaceFormatter(), BraceFormatter(), WrappingFormatter()],
                                        lineFormatters: [BlankLineFormatter(), IndentFormatter(), AlignmentFormatter()])
        let formatted = formatter.format(tokens, configuration)

        let renderer = Renderer()
        let result = renderer.render(formatted, configuration)

        return result
    }

    private func tokenize(fileURL: URL, configuration: Configuration) throws -> [Token] {
        let sourceFile = try SourceFileSyntax.parse(fileURL)

        let tokenizer = TokenVisitor()
        _ = tokenizer.visit(sourceFile)

        return tokenizer.tokens
    }
}
