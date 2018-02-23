//
//  Token.swift
//  swiftfmt-core
//
//  Created by Kishikawa Katsumi on 2018/02/18.
//

import Foundation
import SwiftSyntax

public enum Token {
    case code(Code)
    case backtick(Backtick)
    case lineComment(LineComment)
    case blockComment(BlockComment)
    case whitespace(Whitespace)
    case newline(Newline)
}

extension Token : CustomStringConvertible {
    public var description: String {
        switch self {
        case .code(let code):
            return code.text
        case .backtick(let backtick):
            return String(repeating: backtick.character, count: backtick.count)
        case .lineComment(let comment):
            return comment.text
        case .blockComment(let comment):
            return comment.text
        case .whitespace(let whitespace):
            return String(repeating: whitespace.character, count: whitespace.count)
        case .newline(let newline):
            return String(repeating: newline.character, count: newline.count)
        }
    }
}

public struct Code {
    public let text: String
    public let token: TokenSyntax
    let contexts: [Context]

    init(text: String, token: TokenSyntax, contexts: [Context]) {
        self.text = text
        self.token = token
        self.contexts = contexts
    }
}

public struct Backtick {
    public let character: String
    public let count: Int
    public let triviaPiece: TriviaPiece
}

public struct BlockComment {
    public let text: String
    public let triviaPiece: TriviaPiece
}

public struct LineComment {
    public let text: String
    public let triviaPiece: TriviaPiece
}

public struct Whitespace {
    public let character: String
    public let count: Int
    public let triviaPiece: TriviaPiece
}

public struct Newline {
    public let character: String
    public let count: Int
    public let triviaPiece: TriviaPiece
}

struct Context {
    let node: Syntax
}
