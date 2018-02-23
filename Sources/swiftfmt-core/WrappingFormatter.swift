//
//  WrappingFormatter.swift
//  swiftfmt-core
//
//  Created by Kishikawa Katsumi on 2018/02/19.
//

import Foundation
import SwiftSyntax

public struct WrappingFormatter : TokenFormatter {
    public func format(_ tokens: [Token], _ configuration: Configuration) -> [Token] {
        var line = [Token]()
        var formatted = [Token]()
        var iterator = tokens.makeIterator()
        while let token = iterator.next() {
            switch token {
            case .code(let code):
                switch code.token.tokenKind {
                case .elseKeyword:
                    if let context = code.contexts.last {
                        switch context.node {
                        case is IfStmtSyntax:
                            if let tokens = findClosingBraceOrToken(line: line) {
                                if configuration.wrapping.ifStatement.elseOnNewLine {
                                    wrap(token: token, code: code, line: tokens, formatted: &formatted)
                                } else {
                                    noWrap(token: token, line: tokens, formatted: &formatted)
                                }
                                line.removeAll()
                            }
                        case is GuardStmtSyntax:
                            if let tokens = findClosingBraceOrToken(line: line) {
                                if configuration.wrapping.guardStatement.elseOnNewLine {
                                    wrap(token: token, code: code, line: tokens, formatted: &formatted)
                                } else {
                                    noWrap(token: token, line: tokens, formatted: &formatted)
                                }
                                line.removeAll()
                            }
                        default:
                            line.append(token)
                        }
                    }
                case .whileKeyword:
                    if let context = code.contexts.last {
                        switch context.node {
                        case is RepeatWhileStmtSyntax:
                            if let tokens = findClosingBraceOrToken(line: line) {
                                if configuration.wrapping.repeatWhileStatement.whileOnNewLine {
                                    wrap(token: token, code: code, line: tokens, formatted: &formatted)
                                } else {
                                    noWrap(token: token, line: tokens, formatted: &formatted)
                                }
                                line.removeAll()
                            }
                        default:
                            line.append(token)
                        }
                    }
                case .catchKeyword:
                    if let context = code.contexts.last {
                        switch context.node {
                        case is CatchClauseSyntax:
                            if let tokens = findClosingBraceOrToken(line: line) {
                                if configuration.wrapping.doStatement.catchOnNewLine {
                                    wrap(token: token, code: code, line: tokens, formatted: &formatted)
                                } else {
                                    noWrap(token: token, line: tokens, formatted: &formatted)
                                }
                                line.removeAll()
                            }
                        default:
                            line.append(token)
                        }
                    }
                default:
                    line.append(token)
                }
            case .backtick, .lineComment, .blockComment, .whitespace:
                line.append(token)
            case .newline:
                line.append(token)
            }
        }
        if !line.isEmpty {
            formatted.append(contentsOf: line)
        }
        return formatted
    }

    func findClosingBraceOrToken(line: [Token]) -> [Token]? {
        var line = line
        while let token = line.last {
            switch token {
            case .code:
                return line
            case .backtick:
                break
            case .lineComment, .blockComment:
                return nil
            case .whitespace, .newline:
                line = Array(line.dropLast())
            }
        }
        return nil
    }

    private func noWrap(token: Token, line: [Token], formatted: inout [Token]) {
        formatted.append(contentsOf: line)
        formatted.append(token)
    }

    private func wrap(token: Token, code: Code, line: [Token], formatted: inout [Token]) {
        formatted.append(contentsOf: line)
        formatted.append(.newline(Newline(character: "\n", count: 1, triviaPiece: TriviaPiece.newlines(1))))
        formatted.append(.code(Code(text: code.text.trimmingCharacters(in: .whitespaces), token: code.token, contexts: code.contexts)))
    }
}
