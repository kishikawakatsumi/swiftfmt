//
//  Renderer.swift
//  swiftfmt-core
//
//  Created by Kishikawa Katsumi on 2018/02/18.
//

import Foundation

public struct Renderer {
    public func render(_ lines: [Line], _ configuration: Configuration) -> String {
        return lines.reduce("") {
            let indentation = indent($1, $1.indentationLevel, configuration.indentation)
            let alignment = String(repeating: " ", count: $1.alignment)
            return $0 + "\(indentation)\(alignment)\($1.tokens.map { "\($0)" }.joined())\n"
        }
    }

    private func indent(_ line: Line, _ level: Int, _ configuration: Configuration.Indentation) -> String {
        if !configuration.keepIndentsOnEmptyLines && line.isEmpty {
            return ""
        }
        let indentSize = configuration.indent * level
        let tabSize = configuration.tabSize
        if configuration.useTabCharacter {
            let tabCount = indentSize / tabSize
            let ramaining = indentSize % tabSize
            return String(repeating: "\t", count: tabCount) + String(repeating: " ", count: ramaining)
        } else {
            return String(repeating: " ", count: indentSize)
        }
    }
}
