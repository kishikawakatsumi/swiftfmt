//
//  main.swift
//  swiftfmt
//
//  Created by Kishikawa Katsumi on 2018/02/14.
//

import Foundation
import Basic
import swiftfmt_core

do {
    let parser = OptionParser(arguments: Array(CommandLine.arguments.dropFirst()))
    let options = parser.options
    if options.shouldPrintVersion {
        print("0.1.0")
    } else {
        if options.filename.isEmpty {
            parser.printUsage(on: stdoutStream)
        }
        let configuration: Configuration
        if !options.configurationFile.isEmpty, let c = Configuration.load(file: URL(fileURLWithPath: options.configurationFile)) {
            configuration = c
        } else if let c = Configuration.load(file: URL(fileURLWithPath: ".swiftfmt.json")) {
            configuration = c
        } else {
            configuration = Configuration()
        }

        let command = FormatTool(verbose: options.verbose)
        try command.run(source: URL(fileURLWithPath: options.filename), configuration: configuration)
    }
} catch {
    handle(error: error)
}
