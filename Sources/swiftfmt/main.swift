//
//  main.swift
//  swiftfmt
//
//  Created by Kishikawa Katsumi on 2018/02/14.
//

import Foundation
import Basic

do {
    let parser = OptionParser(arguments: Array(CommandLine.arguments.dropFirst()))
    let options = parser.options
    if options.shouldPrintVersion {
        print("0.1.0")
    } else {
        if options.filename.isEmpty {
            parser.printUsage(on: stdoutStream)
        }
        let command = FormatTool(verbose: options.verbose)
        try command.run(source: URL(fileURLWithPath: options.filename), options: [])
    }
} catch {
    handle(error: error)
}
