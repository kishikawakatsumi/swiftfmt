//
//  AlignmentFormatter.swift
//  swiftfmt-core
//
//  Created by Kishikawa Katsumi on 2018/02/21.
//

import Foundation
import SwiftSyntax

public struct AlignmentFormatter : LineFormatter {
    public func format(_ lines: [Line], _ configuration: Configuration) -> [Line] {
        var formatted = [Line]()
        var temp = [Line]()
        var iterator = lines.enumerated().makeIterator()
        while let (index, line) = iterator.next() {
            if let token = ifStatementToken(line: line) {
                switch token {
                case .code(let code):
                    if let context = code.contexts.last {
                        switch context.node {
                        case (let node) as IfStmtSyntax:
                            let visitor = TokenVisitor()
                            _ = visitor.visit(node.conditions)
                            if visitor.newlines > 0 {
                                let align = alignment(lines: lines, startIndex: index, target: visitor.tokens[0])
                                while let (i, line) = iterator.next() {
                                    temp.append(Line(tokens: line.tokens, indentationLevel: line.indentationLevel, alignment: line.alignment + align))
                                    if i >= index + visitor.newlines {
                                        break
                                    }
                                }
                            }
                        default:
                            break
                        }
                    }
                default:
                    break
                }
            }
            formatted.append(line)
            formatted.append(contentsOf: temp)
            temp.removeAll()
        }
        return formatted
    }

    private class TokenVisitor : SyntaxVisitor {
        var tokens = [TokenSyntax]()
        var newlines = 0

        override func visit(_ token: TokenSyntax) {
            tokens.append(token)
            token.leadingTrivia.forEach { (piece) in
                countNewlines(piece)
            }
            token.trailingTrivia.forEach { (piece) in
                countNewlines(piece)
            }
        }

        private func countNewlines(_ piece: TriviaPiece) {
            switch piece {
            case .newlines(let count), .carriageReturns(let count), .carriageReturnLineFeeds(let count):
                newlines += count
            default:
                break
            }
        }
    }

    private func ifStatementToken(line: Line) -> Token? {
        for token in line.tokens {
            switch token {
            case .code(let code):
                if let context = code.contexts.last, context.node is IfStmtSyntax, code.text == "if" {
                    return token
                }
            default:
                break
            }
        }
        return nil
    }

    private func alignment(lines: [Line], startIndex: Int, target: TokenSyntax) -> Int {
        for i in startIndex..<lines.count {
            var alignment = 0
            let line = lines[i]
            for token in line.tokens {
                if case .code(let code) = token, code.token == target {
                    return alignment
                }
                alignment += "\(token)".count
            }
        }
        return 0
    }
}
