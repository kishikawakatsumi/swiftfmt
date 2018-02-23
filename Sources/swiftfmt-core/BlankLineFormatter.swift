//
//  BlankLineFormatter.swift
//  swiftfmt-core
//
//  Created by Kishikawa Katsumi on 2018/02/19.
//

import Foundation
import SwiftSyntax

public struct BlankLineFormatter : LineFormatter {
    public func format(_ lines: [Line], _ configuration: Configuration) -> [Line] {
        var formatted = [Line]()
        var previousKind = Kind.blank
        var isInFunctionBody = false

        var groups = [LineGroup]()
        var group = LineGroup()
        var previousNode: Syntax?
        var pendingLines = [Line]()
        for line in lines {
            if let node = lineNode(of: line) {
                if previousNode == nil {
                    if lineKind(of: line) == .importDeclaration {
                        group.lines.append(line)
                        groups.append(group)
                        for pendingLine in pendingLines.reversed() {
                            if pendingLine.isEmpty {
                                group.lines.insert(pendingLine, at: 0)
                            } else {
                                group = LineGroup()
                                group.lines.insert(pendingLine, at: 0)
                                groups.insert(group, at: 0)
                            }
                        }
                    } else {
                        group.lines.append(contentsOf: pendingLines)
                        group.lines.append(line)
                        groups.append(group)
                    }
                    previousNode = node
                    pendingLines.removeAll()
                    continue
                } else if !(previousNode! == node) {
                    group = LineGroup()
                    groups.append(group)
                }
                group.lines.append(contentsOf: pendingLines)
                group.lines.append(line)
                pendingLines.removeAll()
                previousNode = node
            } else {
                pendingLines.append(line)
            }
        }
        if !pendingLines.isEmpty {
            group = LineGroup()
            groups.append(group)
            group.lines.append(contentsOf: pendingLines)
        }

        for (index, group) in groups.enumerated() {
            let kind = groupKind(of: group)
            defer {
                if kind != .attribute && kind != .blank && kind != .other {
                    previousKind = kind
                }
            }

            if (index == 0) {
                let keepMaximumBlankLines = configuration.blankLines.keepMaximumBlankLines.inDeclarations
                format(formattedLines: &formatted, configuration: configuration.blankLines, currentGroup: group, keepMaximumBlankLines: keepMaximumBlankLines)
                continue
            }

            switch kind {
            case .importDeclaration:
                let minimumBlankLines = max(configuration.blankLines.minimumBlankLines.beforeImports,
                                            minimumBlankLinesAfterPreviousDeclaration(previousLineKind: previousKind, configuration: configuration))
                let keepMaximumBlankLines = configuration.blankLines.keepMaximumBlankLines.inDeclarations
                format(formattedLines: &formatted,
                       configuration: configuration.blankLines,
                       currentGroup: group,
                       previousLineKind: previousKind,
                       minimumBlankLines: minimumBlankLines,
                       keepMaximumBlankLines: keepMaximumBlankLines)
                isInFunctionBody = false
            case .typeDeclaration:
                let minimumBlankLines: Int
                if !isEndOfCodeBlock(line: group.lines[0]) {
                    minimumBlankLines = max(configuration.blankLines.minimumBlankLines.aroundTypeDeclarations,
                                            minimumBlankLinesAfterPreviousDeclaration(previousLineKind: previousKind, configuration: configuration))
                } else {
                    minimumBlankLines = 0
                }
                let keepMaximumBlankLines = configuration.blankLines.keepMaximumBlankLines.inDeclarations
                format(formattedLines: &formatted,
                       configuration: configuration.blankLines,
                       currentGroup: group,
                       previousLineKind: previousKind,
                       minimumBlankLines: minimumBlankLines,
                       keepMaximumBlankLines: keepMaximumBlankLines)
                isInFunctionBody = false
            case .propertyDeclarationInProtocol:
                let minimumBlankLinesAfterPrevious: Int
                if previousKind == .propertyDeclarationInProtocol || previousKind == .functionDeclarationInProtocol {
                    minimumBlankLinesAfterPrevious = minimumBlankLinesAfterPreviousDeclaration(previousLineKind: previousKind, configuration: configuration)
                } else {
                    minimumBlankLinesAfterPrevious = 0
                }
                let minimumBlankLines: Int
                if !isEndOfCodeBlock(line: group.lines[0]) {
                    minimumBlankLines = max(configuration.blankLines.minimumBlankLines.aroundPropertyInProtocol, minimumBlankLinesAfterPrevious)
                } else {
                    minimumBlankLines = 0
                }
                let keepMaximumBlankLines = configuration.blankLines.keepMaximumBlankLines.inDeclarations
                format(formattedLines: &formatted,
                       configuration: configuration.blankLines,
                       currentGroup: group,
                       previousLineKind: previousKind,
                       minimumBlankLines: minimumBlankLines,
                       keepMaximumBlankLines: keepMaximumBlankLines)
                isInFunctionBody = false
            case .propertyDeclaration:
                let minimumBlankLinesAfterPrevious: Int
                if previousKind == .propertyDeclaration || previousKind == .functionDeclaration {
                    minimumBlankLinesAfterPrevious = minimumBlankLinesAfterPreviousDeclaration(previousLineKind: previousKind, configuration: configuration)
                } else {
                    minimumBlankLinesAfterPrevious = 0
                }
                let minimumBlankLines = max(configuration.blankLines.minimumBlankLines.aroundProperty, minimumBlankLinesAfterPrevious)
                let keepMaximumBlankLines = configuration.blankLines.keepMaximumBlankLines.inDeclarations
                format(formattedLines: &formatted,
                       configuration: configuration.blankLines,
                       currentGroup: group,
                       previousLineKind: previousKind,
                       minimumBlankLines: minimumBlankLines,
                       keepMaximumBlankLines: keepMaximumBlankLines)
                isInFunctionBody = false
            case .functionDeclarationInProtocol:
                let minimumBlankLinesAfterPrevious: Int
                if previousKind == .propertyDeclarationInProtocol || previousKind == .functionDeclarationInProtocol {
                    minimumBlankLinesAfterPrevious = minimumBlankLinesAfterPreviousDeclaration(previousLineKind: previousKind, configuration: configuration)
                } else {
                    minimumBlankLinesAfterPrevious = 0
                }
                let minimumBlankLines = max(configuration.blankLines.minimumBlankLines.aroundFunctionInProtocol, minimumBlankLinesAfterPrevious)
                let keepMaximumBlankLines = configuration.blankLines.keepMaximumBlankLines.inDeclarations
                format(formattedLines: &formatted,
                       configuration: configuration.blankLines,
                       currentGroup: group,
                       previousLineKind: previousKind,
                       minimumBlankLines: minimumBlankLines,
                       keepMaximumBlankLines: keepMaximumBlankLines)
                isInFunctionBody = false
            case .functionDeclaration:
                let minimumBlankLinesAfterPrevious: Int
                if previousKind == .propertyDeclaration || previousKind == .functionDeclaration {
                    minimumBlankLinesAfterPrevious = minimumBlankLinesAfterPreviousDeclaration(previousLineKind: previousKind, configuration: configuration)
                } else {
                    minimumBlankLinesAfterPrevious = 0
                }
                let minimumBlankLines: Int
                if previousKind != .typeDeclaration && !isEndOfCodeBlock(line: group.lines[0]) {
                    minimumBlankLines = max(configuration.blankLines.minimumBlankLines.aroundFunction, minimumBlankLinesAfterPrevious)
                } else {
                    minimumBlankLines = 0
                }
                let keepMaximumBlankLines = configuration.blankLines.keepMaximumBlankLines.inDeclarations
                format(formattedLines: &formatted,
                       configuration: configuration.blankLines,
                       currentGroup: group,
                       previousLineKind: previousKind,
                       minimumBlankLines: minimumBlankLines,
                       keepMaximumBlankLines: keepMaximumBlankLines)
                if !isEndOfCodeBlock(line: group.lines[0]) {
                    isInFunctionBody = true
                }
            case .attribute, .blank, .other:
                let keepMaximumBlankLines = configuration.blankLines.keepMaximumBlankLines.inCode
                format(formattedLines: &formatted, configuration: configuration.blankLines, currentGroup: group, keepMaximumBlankLines: keepMaximumBlankLines)
            }
        }

        return formatted
    }

    private func format(formattedLines: inout [Line], configuration: Configuration.BlankLines, currentGroup: LineGroup, previousLineKind: Kind,
                        minimumBlankLines: Int, keepMaximumBlankLines: Int) {
        var lines = [Line]()
        var preservedBlankLines = [Line]()
        
        var iterator = currentGroup.lines.makeIterator()
        while let line = iterator.next() {
            if line.isEmpty {
                preservedBlankLines.append(line)
            } else {
                lines.append(line)
                break
            }
        }

        let currentLineKind = lineKind(of: currentGroup.lines.last!)
        if currentLineKind != previousLineKind || currentLineKind == .typeDeclaration ||
            currentLineKind == .propertyDeclarationInProtocol || currentLineKind == .propertyDeclaration ||
            currentLineKind == .functionDeclarationInProtocol || currentLineKind == .functionDeclaration {
            if preservedBlankLines.count < minimumBlankLines {
                formattedLines.append(contentsOf: preservedBlankLines)
                for _ in 0..<(minimumBlankLines - preservedBlankLines.count) {
                    formattedLines.append(Line.blank())
                }
            } else {
                formattedLines.append(contentsOf: preservedBlankLines.prefix(keepMaximumBlankLines))
            }
        }

        formattedLines.append(contentsOf: lines)
        lines.removeAll()

        preservedBlankLines.removeAll()
        while let line = iterator.next() {
            if line.isEmpty {
                preservedBlankLines.append(line)
            } else {
                if isEndOfCodeBlock(line: line) {
                    lines.append(contentsOf: preservedBlankLines.prefix(configuration.keepMaximumBlankLines.beforeClosingBrace))
                } else {
                    lines.append(contentsOf: preservedBlankLines.prefix(keepMaximumBlankLines))
                }
                lines.append(line)
                preservedBlankLines.removeAll()
            }
        }
        if !preservedBlankLines.isEmpty {
            if let line = lines.last, isEndOfCodeBlock(line: line) {
                lines.append(contentsOf: preservedBlankLines.prefix(configuration.keepMaximumBlankLines.beforeClosingBrace))
            } else {
                lines.append(contentsOf: preservedBlankLines.prefix(keepMaximumBlankLines))
            }
        }
        formattedLines.append(contentsOf: lines)
    }

    private func format(formattedLines: inout [Line], configuration: Configuration.BlankLines, currentGroup: LineGroup, keepMaximumBlankLines: Int) {
        var lines = [Line]()
        var preservedBlankLines = [Line]()
        var iterator = currentGroup.lines.makeIterator()
        while let line = iterator.next() {
            if line.isEmpty {
                preservedBlankLines.append(line)
            } else {
                if isEndOfCodeBlock(line: line) {
                    lines.append(contentsOf: preservedBlankLines.prefix(configuration.keepMaximumBlankLines.beforeClosingBrace))
                } else {
                    lines.append(contentsOf: preservedBlankLines.prefix(keepMaximumBlankLines))
                }
                lines.append(line)
                preservedBlankLines.removeAll()
            }
        }
        if !preservedBlankLines.isEmpty {
            if let line = lines.last, isEndOfCodeBlock(line: line) {
                lines.append(contentsOf: preservedBlankLines.prefix(configuration.keepMaximumBlankLines.beforeClosingBrace))
            } else {
                lines.append(contentsOf: preservedBlankLines.prefix(keepMaximumBlankLines))
            }
        }
        formattedLines.append(contentsOf: lines)
    }

    private func minimumBlankLinesAfterPreviousDeclaration(previousLineKind: Kind, configuration: Configuration) -> Int {
        switch previousLineKind {
        case .importDeclaration:
            return configuration.blankLines.minimumBlankLines.afterImports
        case .typeDeclaration:
            return configuration.blankLines.minimumBlankLines.aroundTypeDeclarations
        case .propertyDeclarationInProtocol:
            return configuration.blankLines.minimumBlankLines.aroundPropertyInProtocol
        case .propertyDeclaration:
            return configuration.blankLines.minimumBlankLines.aroundProperty
        case .functionDeclarationInProtocol:
            return configuration.blankLines.minimumBlankLines.aroundFunctionInProtocol
        case .functionDeclaration:
            return configuration.blankLines.minimumBlankLines.aroundFunction
        case .attribute, .blank, .other:
            return 0
        }
    }

    private func isOneLineDeclarationBlock(line: Line) -> Bool {
        let kind = lineKind(of: line)
        guard kind == .typeDeclaration || kind == .functionDeclaration || kind == .functionDeclarationInProtocol else {
            return false
        }
        let code = "\(line)".trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ";", with: "")
        return code.hasSuffix("}") && code.filter { $0 == "{" }.count == code.filter { $0 == "}" }.count
    }

    private func isEndOfCodeBlock(line: Line) -> Bool {
        let code = "\(line)".trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ";", with: "")
        return code.hasSuffix("}") && code.filter { $0 == "{" }.count != code.filter { $0 == "}" }.count // Exclude one line declaration case
    }

    private func isClosingBrace(line: Line) -> Bool {
        let code = "\(line)".trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ";", with: "")
        return code.hasSuffix("}")
    }

    private func lineNode(of line: Line) -> Syntax? {
        for token in line.tokens.reversed() {
            switch token {
            case .code(let code):
                if let context = code.contexts.last {
                    switch context.node {
                    case is ImportDeclSyntax, is StructDeclSyntax, is ClassDeclSyntax, is UnknownDeclSyntax, is ExtensionDeclSyntax, is ProtocolDeclSyntax,
                         is VariableDeclSyntax, is FunctionDeclSyntax:
                        return context.node
                    case is AttributeSyntax:
                        if let previousContext = code.contexts.dropLast().last {
                            switch previousContext.node {
                            case is StructDeclSyntax, is ClassDeclSyntax, is UnknownDeclSyntax, is ExtensionDeclSyntax, is ProtocolDeclSyntax,
                                 is VariableDeclSyntax, is FunctionDeclSyntax:
                                return previousContext.node
                            default:
                                return context.node
                            }
                        } else {
                            return context.node
                        }
                    default:
                        return context.node
                    }
                }
            case .backtick:
                break
            case .lineComment, .blockComment:
                break
            case .whitespace, .newline:
                break
            }
        }
        return nil
    }

    private func lineKind(of line: Line) -> Kind {
        var texts = [Token]()
        for token in line.tokens.reversed() {
            switch token {
            case .code(let code):
                if let context = code.contexts.last {
                    switch context.node {
                    case is ImportDeclSyntax:
                        return .importDeclaration
                    case is StructDeclSyntax, is ClassDeclSyntax, is UnknownDeclSyntax, is ExtensionDeclSyntax, is ProtocolDeclSyntax: // UnknownDecl is enum
                        return .typeDeclaration
                    case is VariableDeclSyntax:
                        if let context = code.contexts.dropLast().last {
                            switch context.node {
                            case is StructDeclSyntax, is ClassDeclSyntax, is UnknownDeclSyntax, is ExtensionDeclSyntax:
                                return .propertyDeclaration
                            case is ProtocolDeclSyntax:
                                return .propertyDeclarationInProtocol
                            default:
                                break
                            }
                        } else {
                            return .propertyDeclaration
                        }
                        texts.append(token)
                    case is FunctionDeclSyntax:
                        if let context = code.contexts.dropLast().last {
                            switch context.node {
                            case is StructDeclSyntax, is ClassDeclSyntax, is UnknownDeclSyntax, is ExtensionDeclSyntax:
                                return .functionDeclaration
                            case is ProtocolDeclSyntax:
                                return .functionDeclarationInProtocol
                            default:
                                break
                            }
                        } else {
                            return .functionDeclaration
                        }
                        texts.append(token)
                    case is AttributeSyntax:
                        return .attribute
                    default:
                        texts.append(token)
                    }
                } else {
                    texts.append(token)
                }
            case .backtick:
                texts.append(token)
            case .lineComment, .blockComment:
                texts.append(token)
            case .whitespace, .newline:
                break
            }
        }
        if texts.isEmpty {
            return .blank
        } else {
            return .other
        }
    }

    private func groupKind(of group: LineGroup) -> Kind {
        var texts = [Token]()
        let tokens = group.lines.flatMap { $0.tokens }
        for token in tokens.reversed() {
            switch token {
            case .code(let code):
                if let context = code.contexts.last {
                    switch context.node {
                    case is ImportDeclSyntax:
                        return .importDeclaration
                    case is StructDeclSyntax, is ClassDeclSyntax, is UnknownDeclSyntax, is ExtensionDeclSyntax, is ProtocolDeclSyntax: // UnknownDecl is enum
                        if code.text == "struct" || code.text == "class" || code.text == "enum" || code.text == "extension" || code.text == "protocol" {
                            return .typeDeclaration
                        }
                    case is VariableDeclSyntax:
                        if code.text == "let" || code.text == "var" {
                            if let context = code.contexts.dropLast().last {
                                switch context.node {
                                case is StructDeclSyntax, is ClassDeclSyntax, is UnknownDeclSyntax, is ExtensionDeclSyntax:
                                    return .propertyDeclaration
                                case is ProtocolDeclSyntax:
                                    return .propertyDeclarationInProtocol
                                default:
                                    break
                                }
                            } else {
                                return .propertyDeclaration
                            }
                        }
                        texts.append(token)
                    case is FunctionDeclSyntax:
                        if code.text == "func" {
                            if let context = code.contexts.dropLast().last {
                                switch context.node {
                                case is StructDeclSyntax, is ClassDeclSyntax, is UnknownDeclSyntax, is ExtensionDeclSyntax:
                                    return .functionDeclaration
                                case is ProtocolDeclSyntax:
                                    return .functionDeclarationInProtocol
                                default:
                                    break
                                }
                            } else {
                                return .functionDeclaration
                            }
                        }
                        texts.append(token)
                    case is AttributeSyntax:
                        return .attribute
                    default:
                        texts.append(token)
                    }
                } else {
                    texts.append(token)
                }
            case .backtick:
                texts.append(token)
            case .lineComment, .blockComment:
                texts.append(token)
            case .whitespace, .newline:
                break
            }
        }
        if texts.isEmpty {
            return .blank
        } else {
            return .other
        }
    }

    private enum Kind {
        case importDeclaration
        case typeDeclaration
        case propertyDeclarationInProtocol
        case propertyDeclaration
        case functionDeclarationInProtocol
        case functionDeclaration
        case attribute
        case blank
        case other
    }

    class LineGroup {
        var lines = [Line]()
    }
}
