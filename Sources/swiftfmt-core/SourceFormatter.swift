//
//  SourceFormatter.swift
//  swiftfmt-core
//
//  Created by Kishikawa Katsumi on 2018/02/18.
//

import Foundation

public struct SourceFormatter {
    public let tokenFormatters: [TokenFormatter]
    public let lineFormatters: [LineFormatter]

    public init(tokenFormatters: [TokenFormatter], lineFormatters: [LineFormatter]) {
        self.tokenFormatters = tokenFormatters
        self.lineFormatters = lineFormatters
    }

    public func format(_ tokens: [Token], _ configuration: Configuration) -> [Line] {
        let formattedTokens = format(tokens: tokens, configuration: configuration)
        let lines = SourceFile(tokens: formattedTokens).lines
        return format(lines: lines, configuration: configuration)
    }

    private func format(tokens: [Token], configuration: Configuration) -> [Token] {
        return tokenFormatters.reduce(tokens) { (tokens, formatter) -> [Token] in
            return formatter.format(tokens, configuration)
        }
    }

    private func format(lines: [Line], configuration: Configuration) -> [Line] {
        return lineFormatters.reduce(lines) { (lines, formatter) -> [Line] in
            return formatter.format(lines, configuration)
        }
    }
}
