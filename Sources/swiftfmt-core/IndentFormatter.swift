//
//  IndentFormatter.swift
//  swiftfmt-core
//
//  Created by Kishikawa Katsumi on 2018/02/18.
//

import Foundation
import SwiftSyntax

public struct IndentFormatter : LineFormatter {
    public func format(_ lines: [Line], _ configuration: Configuration) -> [Line] {
        let indentCounter = IndentCounter()

        return lines.enumerated().map { (lineIndex, line) -> Line in
            let indentCounterInLine = IndentCounter()

            for (tokenIndex, token) in line.tokens.enumerated() {
                switch token {
                case .code(let code):
                    switch code.token.tokenKind {
                    case .leftBrace:
                        indentCounterInLine.add(Brace(indent: true, lineNumber: lineIndex))
                    case .rightBrace:
                        if !indentCounterInLine.braces.isEmpty {
                            indentCounterInLine.removeBrace()
                        } else {
                            indentCounter.removeBrace()
                        }
                    case .leftParen:
                        var alignment = 0
                        let hasText = hasTextAfter(line.tokens, tokenIndex + 1)
                        let hasOpeningBrace = hasOpeningBraceAfter(line.tokens, tokenIndex + 1)
                        var shouldIndent = false
                        if hasText && !hasOpeningBrace {
                            if let context = code.contexts.last {
                                if context.node is FunctionDeclSyntax {
                                    if configuration.wrapping.alignment.functionDeclarationParameters.alignWhenMultiline {
                                        alignment = line.tokens.prefix(through: tokenIndex).reduce(0) { $0 + "\($1)".count }
                                    } else {
                                        shouldIndent = true
                                    }
                                }
                                if context.node is FunctionCallExprSyntax {
                                    if configuration.wrapping.alignment.functionCallArguments.alignWhenMultiline {
                                        alignment = line.tokens.prefix(through: tokenIndex).reduce(0) { $0 + "\($1)".count }
                                    } else {
                                        shouldIndent = true
                                    }
                                }
                            }
                        }
                        indentCounterInLine.add(Parenthesis(indent: shouldIndent || !hasText, alignment: alignment, lineNumber: lineIndex))
                    case .rightParen, .stringInterpolationAnchor:
                        if !indentCounterInLine.parentheses.isEmpty {
                            indentCounterInLine.removeParenthesis()
                        } else {
                            indentCounter.removeParenthesis(deleyed: hasTextBefore(line.tokens, tokenIndex - 1))
                        }
                    case .leftSquareBracket:
                        let alignment: Int
                        let hasText = hasTextAfter(line.tokens, tokenIndex + 1)
                        let hasOpeningBrace = hasOpeningBraceAfter(line.tokens, tokenIndex + 1)
                        if hasText && !hasOpeningBrace {
                            alignment = line.tokens.prefix(through: tokenIndex).reduce(0) { $0 + "\($1)".count }
                        } else {
                            alignment = 0
                        }
                        indentCounterInLine.add(Bracket(indent: !hasText, alignment: alignment, lineNumber: lineIndex))
                    case .rightSquareBracket:
                        if !indentCounterInLine.brackets.isEmpty {
                            indentCounterInLine.brackets.removeLast()
                        } else {
                            indentCounter.removeBracket(deleyed: hasTextBefore(line.tokens, tokenIndex - 1))
                        }
                    case .switchKeyword:
                        indentCounter.add(SwitchStatement(lineNumber: lineIndex))
                    case .caseKeyword:
                        if !indentCounter.switchStatements.isEmpty {
                            indentCounter.add(CaseBranch(lineNumber: lineIndex))
                        }
                    case .defaultKeyword:
                        if !indentCounter.switchStatements.isEmpty {
                            indentCounter.add(CaseBranch(lineNumber: lineIndex))
                        }
                    default:
                        break
                    }
                case .backtick:
                    break
                case .lineComment:
                    break
                case .blockComment:
                    break
                case .whitespace, .newline:
                    break
                }
            }

            var indentLevel = indentCounter.indentLevel - indentCounter.dedent
            if let _ = indentCounter.caseBranches.last {
                if !configuration.indentation.indentCaseBranches {
                    indentLevel -= 1
                }
                indentCounter.removeCaseBranch()
            } else {
                if let statement = indentCounter.switchStatements.last, statement.lineNumber < lineIndex {
                    if configuration.indentation.indentCaseBranches {
                        indentLevel += 1
                    }
                }
            }

            assert(indentLevel >= 0, "indentation level should not be negative")

            let alignment = indentCounter.alignment
            let formatted = Line(tokens: line.tokens, indentationLevel: indentLevel, alignment: alignment)

            indentCounter.add(indentCounterInLine)

            return formatted
        }
    }

    private func hasTextBefore(_ tokens: [Token], _ index: Int) -> Bool {
        guard index > 0 else {
            return false
        }
        for i in stride(from: index, to: 0, by: -1) {
            switch tokens[i] {
            case .code, .backtick, .lineComment, .blockComment:
                return true
            default:
                break
            }
        }
        return false
    }

    private func hasTextAfter(_ tokens: [Token], _ index: Int) -> Bool {
        guard index < tokens.count else {
            return false
        }
        for i in index..<tokens.count {
            switch tokens[i] {
            case .code, .backtick, .lineComment, .blockComment:
                return true
            default:
                break
            }
        }
        return false
    }

    private func hasOpeningBraceAfter(_ tokens: [Token], _ index: Int) -> Bool {
        guard index < tokens.count else {
            return false
        }
        for i in index..<tokens.count {
            switch tokens[i] {
            case .code(let code) where code.token.tokenKind == .leftBrace:
                return true
            default:
                break
            }
        }
        return false
    }
}

fileprivate class IndentCounter {
    var braces = [Brace]()
    var parentheses = [Parenthesis]()
    var brackets = [Bracket]()
    var indentations = [Indentation]()

    var switchStatements = [SwitchStatement]()
    var caseBranches = [CaseBranch]()

    var indentLevel = 0
    var alignment = 0

    var indent = 0
    var dedent = 0

    var delayedRemoveParenthesis = 0
    var delayedRemoveBracket = 0

    func add(_ brace: Brace) {
        braces.append(brace)
        indentations.append(brace)
        if let _ = switchStatements.last {
            switchStatements.removeLast()
            switchStatements.append(SwitchStatement(lineNumber: brace.lineNumber))
        }
    }

    func add(_ parenthesis: Parenthesis) {
        parentheses.append(parenthesis)
        indentations.append(parenthesis)
    }

    func add(_ bracket: Bracket) {
        brackets.append(bracket)
        indentations.append(bracket)
    }

    func add(_ switchStatement: SwitchStatement) {
        switchStatements.append(switchStatement)
    }

    func add(_ caseBranch: CaseBranch) {
        if let branch = caseBranches.last, branch.lineNumber == caseBranch.lineNumber {
            return
        }
        caseBranches.append(caseBranch)
    }

    func add(_ counter: IndentCounter) {
        indentations.removeAll()
        dedent = 0

        for _ in 0..<delayedRemoveParenthesis {
            removeParenthesis()
        }
        for _ in 0..<delayedRemoveBracket {
            removeBracket()
        }
        delayedRemoveParenthesis = 0
        delayedRemoveBracket = 0

        braces.append(contentsOf: counter.braces)
        brackets.append(contentsOf: counter.brackets)
        parentheses.append(contentsOf: counter.parentheses)

        indentations.append(contentsOf: braces)
        indentations.append(contentsOf: brackets)
        indentations.append(contentsOf: parentheses)

        indentLevel = indentations.reduce(0) { $0 + ($1.indent ? 1 : 0) }
        var alignment = 0
        for (index, indentation) in indentations.enumerated() {
            if index > 0 && indentation.lineNumber == indentations[index - 1].lineNumber {
                alignment -= indentations[index - 1].alignment
            }
            alignment += indentation.alignment
        }
        self.alignment = alignment
    }

    func removeBrace() {
        if let last = braces.last {
            if last.indent {
                dedent += 1
            }
            braces.removeLast()

            if let switchStatement = switchStatements.last, switchStatement.lineNumber == last.lineNumber {
                switchStatements.removeLast()
            }
        } else {
            fatalError("unmatched close brace")
        }
    }

    func removeParenthesis(deleyed: Bool = false) {
        if deleyed {
            delayedRemoveParenthesis += 1
            return
        }
        if let last = parentheses.last {
            if last.indent {
                dedent += 1
            }
            parentheses.removeLast()
        } else {
            fatalError("unmatched close parenthesis")
        }
    }

    func removeBracket(deleyed: Bool = false) {
        if deleyed {
            delayedRemoveBracket += 1
            return
        }
        if let last = brackets.last {
            if last.indent {
                dedent += 1
            }
            brackets.removeLast()
        } else {
            fatalError("unmatched close bracket")
        }
    }

    func removeSwitchStatement() {
        switchStatements.removeLast()
    }

    func removeCaseBranch() {
        caseBranches.removeLast()
    }
}

fileprivate class Brace : Indentation {
    var indent: Bool
    var alignment: Int
    var lineNumber: Int

    init(indent: Bool, alignment: Int = 0, lineNumber: Int) {
        self.indent = indent
        self.alignment = alignment
        self.lineNumber = lineNumber
    }
}

fileprivate class Parenthesis : Indentation {
    var indent: Bool
    var alignment: Int
    var lineNumber: Int

    init(indent: Bool, alignment: Int = 0, lineNumber: Int) {
        self.indent = indent
        self.alignment = alignment
        self.lineNumber = lineNumber
    }
}

fileprivate class Bracket : Indentation {
    var indent: Bool
    var alignment: Int
    var lineNumber: Int

    init(indent: Bool, alignment: Int = 0, lineNumber: Int) {
        self.indent = indent
        self.alignment = alignment
        self.lineNumber = lineNumber
    }
}

fileprivate class SwitchStatement {
    var lineNumber: Int

    init(lineNumber: Int) {
        self.lineNumber = lineNumber
    }
}

fileprivate class CaseBranch {
    var lineNumber: Int

    init(lineNumber: Int) {
        self.lineNumber = lineNumber
    }
}

protocol Indentation {
    var indent: Bool { get set }
    var alignment: Int { get set }
    var lineNumber: Int { get set }
}
