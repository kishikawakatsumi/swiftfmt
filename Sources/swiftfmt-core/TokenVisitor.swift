//
//  TokenVisitor.swift
//  swiftfmt-core
//
//  Created by Kishikawa Katsumi on 2018/02/18.
//

import Foundation
import SwiftSyntax

class TokenVisitor : SyntaxVisitor {
    var tokens = [Token]()
    private var line = [Token]()
    private var contexts = [Context]()

    override func visit(_ node: ImportDeclSyntax) {
        processNode(node)
    }

    override func visit(_ node: ClassDeclSyntax) {
        processNode(node)
    }
    
    override func visit(_ node: StructDeclSyntax) {
        processNode(node)
    }

    override func visit(_ node: ProtocolDeclSyntax) {
        processNode(node)
    }

    override func visit(_ node: ExtensionDeclSyntax) {
        processNode(node)
    }

    // FIXME: Workaround for enum declaration (e.g. enum Fruit { ... })
    override func visit(_ node: UnknownDeclSyntax) {
        processNode(node)
    }

    override func visit(_ node: TypeInheritanceClauseSyntax) {
        processNode(node)
    }

    override func visit(_ node: VariableDeclSyntax) {
        processNode(node)
    }

    override func visit(_ node: DictionaryExprSyntax) {
        processNode(node)
    }

    override func visit(_ node: DictionaryElementSyntax) {
        processNode(node)
    }

    override func visit(_ node: DictionaryTypeSyntax) {
        processNode(node)
    }

    override func visit(_ node: TypeAnnotationSyntax) {
        processNode(node)
    }

    override func visit(_ node: FunctionDeclSyntax) {
        processNode(node)
    }

    override func visit(_ node: FunctionParameterSyntax) {
        processNode(node)
    }

    override func visit(_ node: FunctionCallExprSyntax) {
        processNode(node)
    }

    override func visit(_ node: FunctionCallArgumentSyntax) {
        processNode(node)
    }

    override func visit(_ node: GenericParameterSyntax) {
        processNode(node)
    }

    override func visit(_ node: GenericWhereClauseSyntax) {
        processNode(node)
    }

    override func visit(_ node: ClosureExprSyntax) {
        processNode(node)
    }

    override func visit(_ node: TernaryExprSyntax) {
        processNode(node)
    }

    override func visit(_ node: IfStmtSyntax) {
        processNode(node)
    }

    override func visit(_ node: ElseBlockSyntax) {
        processNode(node)
    }

    override func visit(_ node: ElseIfContinuationSyntax) {
        processNode(node)
    }

    override func visit(_ node: GuardStmtSyntax) {
        processNode(node)
    }

    override func visit(_ node: ForInStmtSyntax) {
        processNode(node)
    }

    override func visit(_ node: WhileStmtSyntax) {
        processNode(node)
    }

    override func visit(_ node: RepeatWhileStmtSyntax) {
        processNode(node)
    }

    override func visit(_ node: DoStmtSyntax) {
        processNode(node)
    }

    override func visit(_ node: CatchClauseSyntax) {
        processNode(node)
    }

    // FIXME: Workaround for while, switch and AvailabilityConditionSyntax statements
    override func visit(_ node: UnknownStmtSyntax) {
        processNode(node)
    }

    override func visit(_ node: SwitchStmtSyntax) {
        processNode(node)
    }

    override func visit(_ node: SwitchCaseSyntax) {
        processNode(node)
    }

    override func visit(_ node: SwitchCaseLabelSyntax) {
        processNode(node)
    }

    override func visit(_ node: SwitchDefaultLabelSyntax) {
        processNode(node)
    }

    override func visit(_ node: AttributeSyntax) {
        processNode(node)
    }
    
    override func visit(_ node: CodeBlockItemSyntax) {
        processNode(node)
    }

    override func visit(_ node: UnknownExprSyntax) {
        processNode(node)
    }

    override func visit(_ node: AvailabilityConditionSyntax) {
        processNode(node)
    }

    override func visit(_ token: TokenSyntax) {
        token.leadingTrivia.forEach { (piece) in
            processTriviaPiece(piece)
        }

        processToken(token)

        token.trailingTrivia.forEach { (piece) in
            processTriviaPiece(piece)
        }
    }

    private func processNode<NodeType: Syntax>(_ node: NodeType)  {
        let context = Context(node: node)
        contexts.append(context)
        defer {
            if let index = contexts.index(where: { return $0.node == context.node }) {
                contexts.remove(at: index)
            }
        }
        for child in node.children {
            visit(child)
        }
    }

    private func processToken(_ token: TokenSyntax) {
        line.append(.code(Code(text: token.withoutTrivia().text, token: token, contexts: contexts)))
        if token.tokenKind == .eof {
            tokens.append(contentsOf: line.dropLast())
        }
    }

    private func processTriviaPiece(_ piece: TriviaPiece) {
        switch piece {
        case .spaces(let count):
            if !line.isEmpty {
                line.append(.whitespace(Whitespace(character: " ", count: count, triviaPiece: piece)))
            }
        case .tabs(let count):
            if !line.isEmpty {
                line.append(.whitespace(Whitespace(character: "\t", count: count, triviaPiece: piece)))
            }
        case .verticalTabs(let count):
            if !line.isEmpty {
                line.append(.whitespace(Whitespace(character: "\u{000B}", count: count, triviaPiece: piece)))
            }
        case .formfeeds(let count):
            if !line.isEmpty {
                line.append(.whitespace(Whitespace(character: "\u{000C}", count: count, triviaPiece: piece)))
            }
        case .newlines(let count), .carriageReturns(let count), .carriageReturnLineFeeds(let count):
            line.append(.newline(Newline(character: "\n", count: count, triviaPiece: piece)))
            tokens.append(contentsOf: line)
            line.removeAll()
        case .backticks(let count):
            line.append(.backtick(Backtick(character: "`", count: count, triviaPiece: piece)))
        case .lineComment(let text):
            line.append(.lineComment(LineComment(text: text, triviaPiece: piece)))
        case .docLineComment(let text), .blockComment(let text), .docBlockComment(let text):
            let comments = text.split(separator: "\n", omittingEmptySubsequences: false)
            for (index, comment) in comments.enumerated() {
                let trimmed: String
                if index == 0 {
                    trimmed = comment.trimmingCharacters(in: .whitespaces)
                } else {
                    trimmed = " " + comment.trimmingCharacters(in: .whitespaces)
                }
                line.append(.blockComment(BlockComment(text: trimmed, triviaPiece: piece)))
                if index < comments.count - 1 {
                    line.append(.newline(Newline(character: "\n", count: 1, triviaPiece: TriviaPiece.newlines(1))));
                }
            }
        case .garbageText(let text):
            fatalError("garbage text found: \(text)")
        }
    }
}
