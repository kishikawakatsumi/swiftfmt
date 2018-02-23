//
//  Line.swift
//  swiftfmt-core
//
//  Created by Kishikawa Katsumi on 2018/02/18.
//

import Foundation
import SwiftSyntax

public struct Line {
    public let tokens: [Token]
    public let indentationLevel: Int
    public let alignment: Int

    public init(tokens: [Token], indentationLevel: Int, alignment: Int) {
        self.tokens = tokens
        self.indentationLevel = indentationLevel
        self.alignment = alignment
    }

    var isEmpty: Bool {
        return tokens.filter {
            switch $0 {
            case .code, .backtick, .lineComment, .blockComment:
                return true
            case .whitespace, .newline:
                return false
            }
        }.isEmpty
    }

    public static func blank() -> Line {
        return Line(tokens: [], indentationLevel: 0, alignment: 0)
    }
}

extension Line : CustomStringConvertible {
    public var description: String {
        return tokens.map { "\($0)" }.joined()
    }
}
