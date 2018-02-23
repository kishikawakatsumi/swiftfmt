//
//  SourceFile.swift
//  swiftfmt-core
//
//  Created by Kishikawa Katsumi on 2018/02/19.
//

import Foundation

public struct SourceFile {
    public let lines: [Line]

    public init(tokens: [Token]) {
        var lines = [Line]()
        var line = [Token]()
        for token in tokens {
            switch token {
            case .code, .backtick, .lineComment, .blockComment, .whitespace:
                line.append(token)
            case .newline(let newline):
                for _ in 0..<newline.count {
                    lines.append(Line(tokens: line, indentationLevel: 0, alignment: 0))
                    line.removeAll()
                }
            }
        }
        if !line.isEmpty {
            lines.append(Line(tokens: line, indentationLevel: 0, alignment: 0))
        }
        self.lines = lines
    }
}
