//
//  BraceFormatter.swift
//  swiftfmt-core
//
//  Created by Kishikawa Katsumi on 2018/02/18.
//

import Foundation
import SwiftSyntax

public struct BraceFormatter : TokenFormatter {
    public func format(_ tokens: [Token], _ configuration: Configuration) -> [Token] {
        var line = [Token]()
        var formatted = [Token]()
        for token in tokens {
            switch token {
            case .code(let code):
                switch code.token.tokenKind {
                case .leftBrace:
                    if let context = code.contexts.last {
                        switch context.node {
                        case is StructDeclSyntax, is ClassDeclSyntax, is ProtocolDeclSyntax, is UnknownDeclSyntax, is ExtensionDeclSyntax:
                            switch configuration.braces.placement.inTypeDeclarations {
                            case .endOfLine:
                                noWrap(token: token, line: &line, formatted: &formatted)
                            case .nextLine:
                                wrap(token: token, code: code, line: &line, formatted: &formatted)
                            }
                        case is FunctionDeclSyntax:
                            switch configuration.braces.placement.inFunctions {
                            case .endOfLine:
                                noWrap(token: token, line: &line, formatted: &formatted)
                            case .nextLine:
                                wrap(token: token, code: code, line: &line, formatted: &formatted)
                            }
                        default:
                            switch configuration.braces.placement.inOther {
                            case .endOfLine:
                                noWrap(token: token, line: &line, formatted: &formatted)
                            case .nextLine:
                                wrap(token: token, code: code, line: &line, formatted: &formatted)
                            }
                        }
                    }
                case .rightBrace:
                    let hasOtherText = line.filter {
                        if case .code = $0 {
                            return true
                        }
                        return false
                    }.isEmpty
                    guard !hasOtherText else {
                        line.append(token)
                        break
                    }

                    var braces = [Token]()
                    braces.append(token)

                    for token in line.reversed() {
                        if case .code(let code) = token, case .leftBrace = code.token.tokenKind {
                            if braces.isEmpty {
                                break
                            } else {
                                braces.removeLast()
                            }
                        } else if case .code(let code) = token, case .rightBrace = code.token.tokenKind {
                            braces.append(token)
                        }
                    }
                    if configuration.wrapping.keepWhenReformatting.simpleBlocksAndTrailingClosuresInOneLine {
                        // FIXME
                    }
                    if configuration.wrapping.keepWhenReformatting.simpleFunctionsInOneLine {
                        // FIXME
                    }
                    if configuration.wrapping.keepWhenReformatting.simpleClosureArgumentsInOneLine {
                        // FIXME
                    }
                    if !braces.isEmpty {
                        line = removeTrailingWhitespaces(line)
                        line.append(.newline(Newline(character: "\n", count: 1, triviaPiece: TriviaPiece.newlines(1))))
                    }
                    line.append(token)
                default:
                    line.append(token)
                }
            case .backtick, .lineComment, .blockComment, .whitespace:
                line.append(token)
            case .newline:
                formatted.append(contentsOf: line)
                formatted.append(token)
                line.removeAll()
            }
        }
        if !line.isEmpty {
            formatted.append(contentsOf: line)
        }
        return formatted
    }

    private func noWrap(token: Token, line: inout [Token], formatted: inout [Token]) {
        if line.isEmpty {
            formatted = removePreviousNewline(formatted)
            formatted.append(token)
            line.removeAll()
        } else {
            line.append(token)
        }
    }

    private func wrap(token: Token, code: Code, line: inout [Token], formatted: inout [Token]) {
        if line.isEmpty {
            line.append(token)
        } else {
            formatted.append(contentsOf: line)
            formatted.append(.newline(Newline(character: "\n", count: 1, triviaPiece: TriviaPiece.newlines(1))))
            formatted.append(.code(Code(text: code.text.trimmingCharacters(in: .whitespacesAndNewlines), token: code.token, contexts: code.contexts)))
            line.removeAll()
        }
    }

    private func removePreviousNewline(_ tokens: [Token]) -> [Token] {
        var tokens = tokens
        while true {
            if let last = tokens.last {
                tokens = Array(tokens.dropLast())
                switch last {
                case .newline:
                    return tokens
                default:
                    break
                }
            }
        }
    }

    private func removeTrailingWhitespaces(_ tokens: [Token]) -> [Token] {
        var tokens = tokens
        while true {
            if let last = tokens.last, case .whitespace = last {
                tokens = Array(tokens.dropLast())
            } else {
                return tokens
            }
        }
    }
}
