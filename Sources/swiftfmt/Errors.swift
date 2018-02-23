//
//  Errors.swift
//  swiftfmt
//
//  Created by Kishikawa Katsumi on 2018/02/14.
//

import Foundation
import Basic
import Utility

func handle(error: Any) {
    switch error {
    case let anyError as AnyError:
        handle(error: anyError.underlyingError)
    default:
        handle(error)
    }
}

private func handle(_ error: Any) {
    switch error {
    case ArgumentParserError.expectedArguments(let parser, _):
        print(error: error)
        parser.printUsage(on: stderrStream)
    default:
        print(error: error)
    }
}

private func print(error: Any) {
    let writer = InteractiveWriter.stderr
    writer.write("error: ", inColor: .red, bold: true)
    writer.write("\(error)")
    writer.write("\n")
}

final class InteractiveWriter {
    static let stderr = InteractiveWriter(stream: stderrStream)

    let term: TerminalController?
    let stream: OutputByteStream

    init(stream: OutputByteStream) {
        self.term = (stream as? LocalFileOutputByteStream).flatMap(TerminalController.init(stream:))
        self.stream = stream
    }

    func write(_ string: String, inColor color: TerminalController.Color = .noColor, bold: Bool = false) {
        if let term = term {
            term.write(string, inColor: color, bold: bold)
        } else {
            stream <<< string
            stream.flush()
        }
    }
}
