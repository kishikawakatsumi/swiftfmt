//
//  SpaceFormatter.swift
//  swiftfmt-core
//
//  Created by Kishikawa Katsumi on 2018/02/18.
//

import Foundation
import SwiftSyntax

struct SpaceFormatter : TokenFormatter {
    func format(_ tokens: [Token], _ configuration: Configuration) -> [Token] {
        var formatted = [Token]()
        let tokens = removeExtraWhitespaces(tokens)
        var iterator = tokens.enumerated().makeIterator()
        while let (index, token) = iterator.next() {
            switch token {
            case .code(let code):
                switch code.token.tokenKind {
                case .leftBrace:
                    let c: Code
                    if isPlacedAtEndOfLine(tokens, index + 1) || hasTrailingWhitespace(tokens, index + 1) {
                        c = code
                    } else {
                        if isEmptyBraces(tokens, index + 1, false) {
                            c = code
                        } else {
                            c = Code(text: format(code, configuration.spaces.within), token: code.token, contexts: code.contexts)
                        }
                    }
                    if hasLeadingWhitespace(tokens, index - 1) {
                        formatted.append(.code(c))
                    } else {
                        formatted.append(.code(Code(text: format(c, configuration.spaces.before.leftBrace), token: code.token, contexts: code.contexts)))
                    }
                case .rightBrace:
                    if isPlacedAtFirstOfLine(tokens, index - 1) || hasLeadingWhitespace(tokens, index - 1) {
                        formatted.append(token)
                    } else {
                        let c: Code
                        if isEmptyBraces(tokens, index - 1, true) {
                            c = code
                        } else {
                            c = Code(text: format(code, configuration.spaces.within), token: code.token, contexts: code.contexts)
                        }
                        formatted.append(.code(c))
                    }
                case .leftParen:
                    if isEmptyFunctionParenthese(tokens, index + 1, false) {
                        formatted.append(.code(Code(text: format(code, configuration.spaces.before.parentheses), token: code.token, contexts: code.contexts)))
                    } else {
                        let c = Code(text: format(code, configuration.spaces.within), token: code.token, contexts: code.contexts)
                        if isPlacedAtFirstOfLine(tokens, index - 1) || hasLeadingWhitespace(tokens, index - 1) {
                            formatted.append(.code(c))
                        } else {
                            formatted.append(.code(Code(text: format(c, configuration.spaces.before.parentheses), token: code.token, contexts: code.contexts)))
                        }
                    }
                case .rightParen:
                    let isEmptyFunction = isEmptyFunctionParenthese(tokens, index - 1, true)
                    if isEmptyFunction {
                        if configuration.spaces.within.emptyFunctionDeclarationParentheses || configuration.spaces.within.emptyFunctionCallParentheses {
                            formatted.append(.code(Code(text: format(code, configuration.spaces.within, isEmpty: isEmptyFunction), token: code.token, contexts: code.contexts)))
                        } else {
                            formatted.append(token)
                        }
                    } else {
                        formatted.append(.code(Code(text: format(code, configuration.spaces.within), token: code.token, contexts: code.contexts)))
                    }
                case .leftSquareBracket:
                    if !isEmptyArrayOrDictionaryLiteral(tokens, index + 1, false) {
                        formatted.append(.code(Code(text: format(code, configuration.spaces.within), token: code.token, contexts: code.contexts)))
                    } else {
                        formatted.append(token)
                    }
                case .rightSquareBracket:
                    if !isEmptyArrayOrDictionaryLiteral(tokens, index - 1, true) {
                        formatted.append(.code(Code(text: format(code, configuration.spaces.within), token: code.token, contexts: code.contexts)))
                    } else {
                        formatted.append(token)
                    }
                case .unspacedBinaryOperator, .spacedBinaryOperator, .equal, .arrow:
                    formatted.append(.code(Code(text: format(code, configuration.spaces.around.operators, isPlacedAtEndOfLine: isPlacedAtEndOfLine(tokens, index + 1)), token: code.token, contexts: code.contexts)))
                case .elseKeyword, .whileKeyword, .catchKeyword:
                    formatted.append(.code(Code(text: format(code, configuration.spaces.before.keywords), token: code.token, contexts: code.contexts)))
                case .colon:
                    let c: Code
                    if !isPlacedAtEndOfLine(tokens, index + 1) {
                        c = Code(text: format(code, configuration.spaces.around.colons), token: code.token, contexts: code.contexts)
                    } else {
                        c = code
                    }
                    formatted.append(.code(Code(text: format(c, configuration.spaces.inTernaryOperator), token: code.token, contexts: code.contexts)))
                case .infixQuestionMark:
                    formatted.append(.code(Code(text: format(code, configuration.spaces.inTernaryOperator), token: code.token, contexts: code.contexts)))
                case .comma:
                    formatted.append(.code(Code(text: format(code, tokens, index, configuration.spaces.comma), token: code.token, contexts: code.contexts)))
                case .semicolon:
                    formatted.append(.code(Code(text: format(code, tokens, index + 1, configuration.spaces.semicolon), token: code.token, contexts: code.contexts)))
                case .forKeyword: // 'For' statement is often misidentified to function call (e.g. `for i in (0..<array.count).reversed()`)
                    formatted.append(token)
                    if let (_, token) = iterator.next() {
                        if case .code(let code) = token, case .leftParen = code.token.tokenKind {
                            formatted.append(.code(Code(text: " " + code.text, token: code.token, contexts: code.contexts)))
                        } else {
                            formatted.append(token)
                        }
                    }
                    while let (_, token) = iterator.next() {
                        if case .code(let code) = token {
                            if case .rightParen = code.token.tokenKind {
                                if let (_, nextToken) = iterator.next() {
                                    if case .code(let nextCode) = nextToken, case .inKeyword = nextCode.token.tokenKind {
                                        formatted.append(.code(Code(text: code.text + " ", token: code.token, contexts: code.contexts)))
                                        formatted.append(nextToken)
                                        if let (_, token) = iterator.next() {
                                            if case .code(let code) = token, case .leftParen = code.token.tokenKind {
                                                formatted.append(.code(Code(text: " " + code.text, token: code.token, contexts: code.contexts)))
                                            } else {
                                                formatted.append(token)
                                            }
                                        }
                                        break
                                    } else {
                                        formatted.append(token)
                                        formatted.append(nextToken)
                                    }
                                }
                                continue
                            } else if case .inKeyword = code.token.tokenKind {
                                formatted.append(token)
                                if let (_, token) = iterator.next() {
                                    if case .code(let code) = token, case .leftParen = code.token.tokenKind {
                                        formatted.append(.code(Code(text: " " + code.text, token: code.token, contexts: code.contexts)))
                                    } else {
                                        formatted.append(token)
                                    }
                                }
                                break
                            }
                        }
                        formatted.append(token)
                    }
                default:
                    formatted.append(token)
                }
            case .backtick, .lineComment, .blockComment, .whitespace, .newline:
                formatted.append(token)
            }
        }
        return formatted
    }

    private func removeExtraWhitespaces(_ tokens: [Token]) -> [Token] {
        var results = [Token]()
        var whitespaces = [Token]()
        var skipWhitespaces = false
        for token in tokens {
            switch token {
            case .code(let code):
                switch code.token.tokenKind {
                case .leftBrace:
                    if !skipWhitespaces && !whitespaces.isEmpty {
                        if let context = code.contexts.last {
                            if !shouldRemoveWhitespacesBeforeLeftBrace(context: context) {
                                results.append(.whitespace(Whitespace(character: " ", count: 1, triviaPiece: TriviaPiece.spaces(1))))
                            }
                        } else {
                            results.append(.whitespace(Whitespace(character: " ", count: 1, triviaPiece: TriviaPiece.spaces(1))))
                        }
                    }
                    results.append(token)
                    whitespaces.removeAll()
                    skipWhitespaces = true
                case .leftParen:
                    if !skipWhitespaces && !whitespaces.isEmpty {
                        if let context = code.contexts.last {
                            if !shouldRemoveWhitespacesBeforeLeftParenthesis(context: context) {
                                results.append(.whitespace(Whitespace(character: " ", count: 1, triviaPiece: TriviaPiece.spaces(1))))
                            }
                        } else {
                            results.append(.whitespace(Whitespace(character: " ", count: 1, triviaPiece: TriviaPiece.spaces(1))))
                        }
                    }
                    results.append(token)
                    whitespaces.removeAll()
                    skipWhitespaces = true
                case .rightParen:
                    results.append(token)
                    whitespaces.removeAll()
                    skipWhitespaces = false
                case .leftSquareBracket:
                    if !skipWhitespaces && !whitespaces.isEmpty {
                        results.append(.whitespace(Whitespace(character: " ", count: 1, triviaPiece: TriviaPiece.spaces(1))))
                    }
                    results.append(token)
                    whitespaces.removeAll()
                    skipWhitespaces = true
                case .rightSquareBracket:
                    results.append(token)
                    whitespaces.removeAll()
                    skipWhitespaces = false
                case .unspacedBinaryOperator, .spacedBinaryOperator:
                    if ["=", "+=", "-=", "*=", "/=", "%=", "&=", "|=", "^=", "&&", "||", "==", "===", "<", ">", "<=", ">=", "&", "|", "^", "+", "-", "*", "/", "%", "<<", ">>", "..<", "...", "->"].contains(code.text) {
                        results.append(token)
                        whitespaces.removeAll()
                        skipWhitespaces = true
                    } else {
                        if !skipWhitespaces && !whitespaces.isEmpty {
                            results.append(.whitespace(Whitespace(character: " ", count: 1, triviaPiece: TriviaPiece.spaces(1))))
                        }
                        results.append(token)
                        whitespaces.removeAll()
                        skipWhitespaces = false
                    }
                case .equal, .arrow, .comma, .colon, .semicolon:
                    results.append(token)
                    whitespaces.removeAll()
                    skipWhitespaces = true
                case .elseKeyword, .whileKeyword, .catchKeyword:
                    results.append(token)
                    whitespaces.removeAll()
                    skipWhitespaces = false
                case .infixQuestionMark:
                    if !skipWhitespaces && !whitespaces.isEmpty {
                        results.append(.whitespace(Whitespace(character: " ", count: 1, triviaPiece: TriviaPiece.spaces(1))))
                    }
                    results.append(token)
                    whitespaces.removeAll()
                    skipWhitespaces = true
                default:
                    if !skipWhitespaces && !whitespaces.isEmpty {
                        results.append(.whitespace(Whitespace(character: " ", count: 1, triviaPiece: TriviaPiece.spaces(1))))
                    }
                    results.append(token)
                    whitespaces.removeAll()
                    skipWhitespaces = false
                }
            case .backtick, .lineComment:
                if !skipWhitespaces && !whitespaces.isEmpty {
                    results.append(.whitespace(Whitespace(character: " ", count: 1, triviaPiece: TriviaPiece.spaces(1))))
                }
                results.append(token)
                whitespaces.removeAll()
                skipWhitespaces = false
            case .blockComment:
                results.append(contentsOf: whitespaces)
                results.append(token)
                whitespaces.removeAll()
                skipWhitespaces = false
            case .whitespace:
                whitespaces.append(token)
            case .newline:
                results.append(token)
                whitespaces.removeAll()
                skipWhitespaces = false
            }
        }
        return results
    }

    private func format(_ code: Code, _ configuration: Configuration.Spaces.Before.Parentheses) -> String {
        let text = code.text
        var prefix = ""

        guard let context = code.contexts.last else {
            return text
        }

        switch context.node {
        case is FunctionDeclSyntax:
            if configuration.functionDeclaration {
                prefix = " "
            }
        case is FunctionCallExprSyntax:
            if configuration.functionCall {
                prefix = " "
            }
        case is IfStmtSyntax:
            if configuration.if {
                prefix = " "
            }
        case is WhileStmtSyntax, is RepeatWhileStmtSyntax:
            if configuration.while {
                prefix = " "
            }
        case is SwitchStmtSyntax:
            if configuration.switch {
                prefix = " "
            }
        case is CatchClauseSyntax:
            if configuration.catch {
                prefix = " "
            }
        case is AttributeSyntax:
            if configuration.attribute {
                prefix = " "
            }
        case is UnknownStmtSyntax:
            if let token = context.node.child(at: 0) as? TokenSyntax, case .whileKeyword = token.tokenKind {
                if configuration.while {
                    prefix = " "
                }
            } else if let token = context.node.child(at: 0) as? TokenSyntax, case .switchKeyword = token.tokenKind {
                if configuration.switch {
                    prefix = " "
                }
            }
        default:
            break
        }
        return prefix + text
    }

    private func format(_ code: Code, _ configuration: Configuration.Spaces.Around.Operators, isPlacedAtEndOfLine: Bool) -> String {
        let text = code.text
        var prefix = ""
        var suffix = ""

        if text == "=" || text == "+=" || text == "-=" || text == "*=" || text == "/=" || text == "%=" || text == "&=" || text == "|=" || text == "^=" {
            if configuration.assignmentOperators {
                prefix = " "
                suffix = " "
            }
        }
        if text == "&&" || text == "||" {
            if configuration.logicalOperators {
                prefix = " "
                suffix = " "
            }
        }
        if text == "==" || text == "===" {
            if configuration.equalityOperators {
                prefix = " "
                suffix = " "
            }
        }
        if text == "<" || text == ">" || text == "<=" || text == ">=" {
            if configuration.relationalOperators {
                prefix = " "
                suffix = " "
            }
        }
        if text == "&" || text == "|" || text == "^" {
            if configuration.bitwiseOperators {
                prefix = " "
                suffix = " "
            }
        }
        if text == "+" || text == "-" {
            if configuration.additiveOperators {
                prefix = " "
                suffix = " "
            }
        }
        if text == "*" || text == "/" || text == "%" {
            if configuration.multiplicativeOperators {
                // Exclude '*' in attribute like '@available(*, unavailable)' and
                // availability condition line 'if #available(iOS 9.0, *)'.
                // But 'AvailabilityConditionSyntax' doesn't work in current libSyntax.
                // Use 'UnknownStmtSyntax' instead for workaround for now.
                if !(code.contexts.last?.node is AttributeSyntax) && !(code.contexts.last?.node is UnknownStmtSyntax) {
                    prefix = " "
                    suffix = " "
                }
            }
        }
        if text == "<<" || text == ">>" {
            if configuration.shiftOperators {
                prefix = " "
                suffix = " "
            }
        }
        if text == "..<" || text == "..." {
            if configuration.rangeOperators {
                prefix = " "
                suffix = " "
            }
        }
        if text == "->" {
            if configuration.closureArrow {
                prefix = " "
                suffix = " "
            }
        }
        return prefix + text + (isPlacedAtEndOfLine ? "" : suffix)
    }

    private func format(_ code: Code, _ configuration: Configuration.Spaces.Before.LeftBrace) -> String {
        let text = code.text
        var prefix = ""

        guard let context = code.contexts.last else {
            return text
        }

        switch context.node {
        case is StructDeclSyntax, is ClassDeclSyntax, is ProtocolDeclSyntax, is UnknownDeclSyntax,
             is ExtensionDeclSyntax, is TypeInheritanceClauseSyntax:
            if configuration.typeDeclaration {
                prefix = " "
            }
        case is FunctionDeclSyntax:
            if configuration.function {
                prefix = " "
            }
        case is IfStmtSyntax:
            if configuration.if {
                prefix = " "
            }
        case is ElseBlockSyntax, is GuardStmtSyntax:
            if configuration.else {
                prefix = " "
            }
        case is ForInStmtSyntax:
            if configuration.for {
                prefix = " "
            }
        case is RepeatWhileStmtSyntax:
            if configuration.while {
                prefix = " "
            }
        case is DoStmtSyntax:
            if configuration.do {
                prefix = " "
            }
        case is SwitchStmtSyntax:
            if configuration.switch {
                prefix = " "
            }
        case is CatchClauseSyntax:
            if configuration.catch {
                prefix = " "
            }
        case is UnknownStmtSyntax:
            if let token = context.node.child(at: 0) as? TokenSyntax, case .whileKeyword = token.tokenKind {
                if configuration.while {
                    prefix = " "
                }
            } else if let token = context.node.child(at: 0) as? TokenSyntax, case .switchKeyword = token.tokenKind {
                if configuration.switch {
                    prefix = " "
                }
            }
        default:
            break
        }
        return prefix + text
    }

    private func format(_ code: Code, _ configuration: Configuration.Spaces.Before.Keywords) -> String {
        let text = code.text
        var prefix = ""

        guard let context = code.contexts.last else {
            return text
        }

        // Workaround for availability conditions (e.g. 'if #available(iOS 9.0, *) {} else {}')
        if context.node is IfStmtSyntax || context.node is GuardStmtSyntax || context.node is UnknownStmtSyntax, case .elseKeyword = code.token.tokenKind {
            if configuration.else {
                prefix = " "
            }
        } else if context.node is RepeatWhileStmtSyntax, case .whileKeyword = code.token.tokenKind {
            if configuration.while {
                prefix = " "
            }
        } else if context.node is CatchClauseSyntax, case .catchKeyword = code.token.tokenKind {
            if configuration.catch {
                prefix = " "
            }
        }
        return prefix + text
    }

    private func format(_ code: Code, _ configuration: Configuration.Spaces.Around.Colons) -> String {
        let text = code.text
        var prefix = ""
        var suffix = ""

        guard let context = code.contexts.last else {
            return text
        }

        switch context.node {
        case is TypeInheritanceClauseSyntax:
            if configuration.beforeTypeInheritanceClauses {
                prefix = " "
            }
            if configuration.afterTypeInheritanceClauses {
                suffix = " "
            }
        case is GenericParameterSyntax, is GenericWhereClauseSyntax:
            if configuration.beforeTypeInheritanceClausesInTypeArguments {
                prefix = " "
            }
            if configuration.afterTypeInheritanceClausesInTypeArguments {
                suffix = " "
            }
        case is DictionaryTypeSyntax:
            if configuration.beforeDictionaryTypes {
                prefix = " "
            }
            if configuration.afterDictionaryTypes {
                suffix = " "
            }
        case let node as DictionaryExprSyntax:
            // Empty dictionary literal
            if "\(node)".components(separatedBy: CharacterSet.whitespacesAndNewlines).joined() == "[:]" {
                return text
            }
            if configuration.afterDictionaryLiteralKeyValuePair {
                prefix = " "
            }
            if configuration.afterDictionaryLiteralKeyValuePair {
                suffix = " "
            }
        case let node as DictionaryElementSyntax:
            // Empty dictionary literal
            if "\(node)".components(separatedBy: CharacterSet.whitespacesAndNewlines).joined() == "[:]" {
                return text
            }
            if configuration.beforeDictionaryLiteralKeyValuePair {
                prefix = " "
            }
            if configuration.afterDictionaryLiteralKeyValuePair {
                suffix = " "
            }
        case is TypeAnnotationSyntax, is FunctionParameterSyntax, is FunctionCallArgumentSyntax:
            if configuration.beforeTypeAnnotations {
                prefix = " "
            }
            if configuration.afterTypeAnnotations {
                suffix = " "
            }
        case is AttributeSyntax:
            if configuration.beforeAttributeArguments {
                prefix = " "
            }
            if configuration.afterAttributeArguments {
                suffix = " "
            }
        case is UnknownStmtSyntax:
            // Maybe swich case statement
            suffix = " "
        case is UnknownExprSyntax:
            // Workaround for #selector(_:) expression
            break
        default:
            break
        }

        return prefix + text + suffix
    }

    private func format(_ code: Code, _ configuration: Configuration.Spaces.Within, isEmpty: Bool = false) -> String {
        let text = code.text
        var prefix = ""
        var suffix = ""

        guard let context = code.contexts.last else {
            return text
        }
        if case .leftBrace = code.token.tokenKind {
            if configuration.codeBraces {
                suffix = " "
            }
        } else if case .rightBrace = code.token.tokenKind {
            if configuration.codeBraces {
                prefix = " "
            }
        } else if case .leftSquareBracket = code.token.tokenKind {
            if configuration.brackets {
                suffix = " "
            }
        } else if case .rightSquareBracket = code.token.tokenKind {
            if configuration.brackets {
                prefix = " "
            }
        } else if case .leftParen = code.token.tokenKind {
            switch context.node {
            case is FunctionDeclSyntax:
                if configuration.functionDeclarationParentheses {
                    suffix = " "
                }
            case is FunctionCallExprSyntax:
                if configuration.functionCallParentheses {
                    suffix = " "
                }
            case is IfStmtSyntax:
                if configuration.ifParentheses {
                    suffix = " "
                }
            case is WhileStmtSyntax, is RepeatWhileStmtSyntax:
                if configuration.whileParentheses {
                    suffix = " "
                }
            case is SwitchStmtSyntax:
                if configuration.switchParentheses {
                    suffix = " "
                }
            case is CatchClauseSyntax:
                if configuration.catchParentheses {
                    suffix = " "
                }
            case is AttributeSyntax:
                if configuration.attributeParentheses {
                    suffix = " "
                }
            case is ExpressionStmtSyntax, is CodeBlockItemSyntax:
                if configuration.groupingParentheses {
                    suffix = " "
                }
            case is UnknownStmtSyntax:
                if let token = context.node.child(at: 0) as? TokenSyntax, case .whileKeyword = token.tokenKind {
                    if configuration.whileParentheses {
                        suffix = " "
                    }
                } else if let token = context.node.child(at: 0) as? TokenSyntax, case .switchKeyword = token.tokenKind {
                    if configuration.switchParentheses {
                        suffix = " "
                    }
                }
            default:
                break
            }
        } else if case .rightParen = code.token.tokenKind {
            switch context.node {
            case is FunctionDeclSyntax:
                if isEmpty && configuration.emptyFunctionDeclarationParentheses {
                    prefix = " "
                } else if configuration.functionDeclarationParentheses {
                    prefix = " "
                }
            case is FunctionCallExprSyntax:
                if isEmpty && configuration.emptyFunctionCallParentheses {
                    prefix = " "
                } else if configuration.functionCallParentheses  {
                    prefix = " "
                }
            case is IfStmtSyntax:
                if configuration.ifParentheses {
                    prefix = " "
                }
            case is WhileStmtSyntax, is RepeatWhileStmtSyntax:
                if configuration.whileParentheses {
                    prefix = " "
                }
            case is SwitchStmtSyntax:
                if configuration.switchParentheses {
                    prefix = " "
                }
            case is CatchClauseSyntax:
                if configuration.catchParentheses {
                    prefix = " "
                }
            case is AttributeSyntax:
                if configuration.attributeParentheses {
                    prefix = " "
                }
            case is ExpressionStmtSyntax, is CodeBlockItemSyntax:
                if configuration.groupingParentheses {
                    prefix = " "
                }
            case is UnknownStmtSyntax:
                if let token = context.node.child(at: 0) as? TokenSyntax, case .whileKeyword = token.tokenKind {
                    if configuration.whileParentheses {
                        prefix = " "
                    }
                } else if let token = context.node.child(at: 0) as? TokenSyntax, case .switchKeyword = token.tokenKind {
                    if configuration.switchParentheses {
                        prefix = " "
                    }
                }
            default:
                break
            }
        }

        return prefix + text + suffix
    }

    private func format(_ code: Code, _ configuration: Configuration.Spaces.InTernaryOperator) -> String {
        let text = code.text
        var prefix = ""
        var suffix = ""

        guard let context = code.contexts.last else {
            return text
        }

        switch context.node {
        case is TernaryExprSyntax:
            switch code.token.tokenKind {
            case .infixQuestionMark:
                if configuration.afterQuestionMark {
                    suffix = " "
                }
            case .colon:
                if configuration.beforeColon {
                    prefix = " "
                }
                if configuration.afterColon {
                    suffix = " "
                }
            default:
                break
            }
        default:
            break
        }

        return prefix + text + suffix
    }

    private func format(_ code: Code, _ tokens: [Token], _ index: Int, _ configuration: Configuration.Spaces.Comma) -> String {
        let text = code.text

        guard let context = code.contexts.last else {
            return text
        }

        switch context.node {
        case is GenericParameterSyntax, is GenericWhereClauseSyntax:
            if configuration.afterWithinTypeArguments {
                return text + " "
            } else {
                return text
            }
        default:
            break
        }

        // Other commas
        var prefix = ""
        var suffix = ""
        if configuration.before && !isPlacedAtFirstOfLine(tokens, index - 1) {
            prefix = " "
        }
        if configuration.after && !isPlacedAtEndOfLine(tokens, index + 1) {
            suffix = " "
        }

        return prefix + text + suffix
    }

    private func format(_ code: Code, _ tokens: [Token], _ index: Int, _ configuration: Configuration.Spaces.Semicolon) -> String {
        let text = code.text
        var prefix = ""
        var suffix = ""

        if configuration.before {
            prefix = " "
        }
        if configuration.after {
            if !isSemicolonAtEndOfLine(tokens, index) {
                suffix = " "
            }
        }
        return prefix + text + suffix
    }

    private func isSemicolonAtEndOfLine(_ tokens: [Token], _ index: Int) -> Bool {
        guard index < tokens.count else {
            return true
        }
        for i in index..<tokens.count {
            switch tokens[i] {
            case .code, .backtick:
                return false
            case .lineComment, .blockComment, .whitespace:
                break
            case .newline:
                return true
            }
        }
        return true
    }

    private func isEmptyArrayOrDictionaryLiteral(_ tokens: [Token], _ index: Int, _ reverse: Bool) -> Bool {
        if reverse {
            guard index > 0 else {
                return false
            }
            for i in stride(from: index, to: 0, by: -1) {
                switch tokens[i] {
                case .code(let code):
                    if case .leftSquareBracket = code.token.tokenKind {
                        return true
                    }
                    if case .colon = code.token.tokenKind {
                        break
                    } else {
                        return false
                    }
                case .backtick:
                    return false
                case .lineComment, .blockComment, .whitespace, .newline:
                    break
                }
            }
            return false
        } else {
            guard index < tokens.count else {
                return false
            }
            for i in index..<tokens.count {
                switch tokens[i] {
                case .code(let code):
                    if case .rightSquareBracket = code.token.tokenKind {
                        return true
                    }
                    if case .colon = code.token.tokenKind {
                        break
                    } else {
                        return false
                    }
                case .backtick:
                    return false
                case .lineComment, .blockComment, .whitespace, .newline:
                    break
                }
            }
            return false
        }
    }

    private func isEmptyBraces(_ tokens: [Token], _ index: Int, _ reverse: Bool) -> Bool {
        if reverse {
            guard index > 0 else {
                return false
            }
            for i in stride(from: index, to: 0, by: -1) {
                switch tokens[i] {
                case .code(let code):
                    if case .leftBrace = code.token.tokenKind {
                        return true
                    }
                    return false
                case .backtick:
                    return false
                case .lineComment, .blockComment, .whitespace, .newline:
                    break
                }
            }
            return false
        } else {
            guard index < tokens.count else {
                return false
            }
            for i in index..<tokens.count {
                switch tokens[i] {
                case .code(let code):
                    if case .rightBrace = code.token.tokenKind {
                        return true
                    }
                    return false
                case .backtick:
                    return false
                case .lineComment, .blockComment, .whitespace, .newline:
                    break
                }
            }
            return false
        }
    }

    private func isEmptyFunctionParenthese(_ tokens: [Token], _ index: Int, _ reverse: Bool) -> Bool {
        if reverse {
            guard index > 0 else {
                return false
            }
            for i in stride(from: index, to: 0, by: -1) {
                switch tokens[i] {
                case .code(let code):
                    if case .leftParen = code.token.tokenKind {
                        return true
                    }
                    return false
                case .backtick:
                    return false
                case .lineComment, .blockComment, .whitespace, .newline:
                    break
                }
            }
            return false
        } else {
            guard index < tokens.count else {
                return false
            }
            for i in index..<tokens.count {
                switch tokens[i] {
                case .code(let code):
                    if case .rightParen = code.token.tokenKind {
                        return true
                    }
                    return false
                case .backtick:
                    return false
                case .lineComment, .blockComment, .whitespace, .newline:
                    break
                }
            }
            return false
        }
    }

    private func isPlacedAtEndOfLine(_ tokens: [Token], _ index: Int) -> Bool {
        guard index < tokens.count else {
            return true
        }
        for i in index..<tokens.count {
            switch tokens[i] {
            case .code, .backtick:
                return false
            case .lineComment, .blockComment, .whitespace:
                break
            case .newline:
                return true
            }
        }
        return true
    }

    private func isPlacedAtFirstOfLine(_ tokens: [Token], _ index: Int) -> Bool {
        guard index > 0 else {
            return false
        }
        for i in stride(from: index, to: 0, by: -1) {
            switch tokens[i] {
            case .code, .backtick:
                return false
            case .lineComment, .blockComment, .whitespace:
                break
            case .newline:
                return true
            }
        }
        return true
    }

    private func hasTrailingWhitespace(_ tokens: [Token], _ index: Int) -> Bool {
        guard index < tokens.count else {
            return true
        }
        for i in index..<tokens.count {
            switch tokens[i] {
            case .code, .backtick:
                return false
            case .lineComment, .blockComment:
                break
            case .whitespace:
                return true
            case .newline:
                return false
            }
        }
        return false
    }

    private func hasLeadingWhitespace(_ tokens: [Token], _ index: Int) -> Bool {
        guard index > 0 else {
            return false
        }
        for i in stride(from: index, to: 0, by: -1) {
            switch tokens[i] {
            case .code, .backtick:
                return false
            case .lineComment, .blockComment:
                break
            case .whitespace:
                return true
            case .newline:
                return false
            }
        }
        return false
    }

    private func shouldRemoveWhitespacesBeforeLeftBrace(context: Context) -> Bool {
        switch context.node {
        case is StructDeclSyntax, is ClassDeclSyntax, is ProtocolDeclSyntax, is UnknownDeclSyntax, is ExtensionDeclSyntax, is TypeInheritanceClauseSyntax,
             is FunctionDeclSyntax, is IfStmtSyntax, is ElseBlockSyntax, is GuardStmtSyntax, is ForInStmtSyntax, is RepeatWhileStmtSyntax, is DoStmtSyntax, is SwitchStmtSyntax, is CatchClauseSyntax:
            return true
        case is UnknownStmtSyntax:
            if let token = context.node.child(at: 0) as? TokenSyntax, case .whileKeyword = token.tokenKind {
                return true
            } else if let token = context.node.child(at: 0) as? TokenSyntax, case .switchKeyword = token.tokenKind {
                return true
            }
        default:
            return false
        }
        return false
    }

    private func shouldRemoveWhitespacesBeforeLeftParenthesis(context: Context) -> Bool {
        switch context.node {
        case is FunctionDeclSyntax, is FunctionCallExprSyntax, is IfStmtSyntax, is WhileStmtSyntax, is RepeatWhileStmtSyntax,
             is SwitchStmtSyntax, is CatchClauseSyntax, is AttributeSyntax:
            return true
        case is UnknownStmtSyntax:
            if let token = context.node.child(at: 0) as? TokenSyntax, case .whileKeyword = token.tokenKind {
                return true
            } else if let token = context.node.child(at: 0) as? TokenSyntax, case .switchKeyword = token.tokenKind {
                return true
            }
        default:
            return false
        }
        return false
    }
}
