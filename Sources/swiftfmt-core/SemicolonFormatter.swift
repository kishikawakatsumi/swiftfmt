//
//  SemicolonFormatter.swift
//  swiftfmt-core
//
//  Created by Kishikawa Katsumi on 2018/02/19.
//

import Foundation
import SwiftSyntax

public struct SemicolonFormatter : TokenFormatter {
    public func format(_ tokens: [Token], _ configuration: Configuration) -> [Token] {
        var results = [Token]()
        var whitespaces = [Token]()
        var skipWhitespaces = false
        for (index, token) in tokens.enumerated() {
            switch token {
            case .code(let code):
                switch code.token.tokenKind {
                case .semicolon:
                    if !configuration.shouldRemoveSemicons {
                        results.append(token)
                    }
                    if !hasNewlineBeforeToken(tokens, index + 1) {
                        results.append(.newline(Newline(character: "\n", count: 1, triviaPiece: TriviaPiece.newlines(1))))
                    }
                    skipWhitespaces = true
                default:
                    if !skipWhitespaces && !whitespaces.isEmpty {
                        results.append(contentsOf: whitespaces)
                    }
                    results.append(token)
                    whitespaces.removeAll()
                    skipWhitespaces = false
                }
            case .whitespace:
                whitespaces.append(token)
            default:
                if !skipWhitespaces && !whitespaces.isEmpty {
                    results.append(contentsOf: whitespaces)
                }
                results.append(token)
                whitespaces.removeAll()
                skipWhitespaces = false
            }
        }
        return results
    }

    private func hasNewlineBeforeToken(_ tokens: [Token], _ index: Int) -> Bool {
        guard index < tokens.count else {
            return true
        }
        for i in index..<tokens.count {
            switch tokens[i] {
            case .code:
                return false
            case .backtick:
                return false
            case .lineComment, .blockComment, .whitespace:
                break
            case .newline:
                return true
            }
        }
        return true
    }
}
