//
//  OptionParser.swift
//  swiftfmt
//
//  Created by Kishikawa Katsumi on 2018/02/14.
//

import Utility
import Basic
import POSIX

struct OptionParser {
    let options: Options
    private let parser: ArgumentParser

    init(arguments: [String]) {
        parser = ArgumentParser(commandName: "swiftfmt", usage: "swiftfmt filename [options]", overview: "Format Swift source code")

        let binder = ArgumentBinder<Options>()
        binder.bind(positional: parser.add(positional: "filename", kind: String.self)) { $0.filename = $1 }
        binder.bind(option: parser.add(option: "--version", kind: Bool.self)) { $0.shouldPrintVersion = $1 }
        binder.bind(option: parser.add(option: "--verbose", kind: Bool.self, usage: "Show more debugging information")) { $0.verbose = $1 }

        do {
            let result = try parser.parse(arguments)
            var options = Options()
            binder.fill(result, into: &options)
            self.options = options
        } catch {
            handle(error: error)
            POSIX.exit(1)
        }
    }

    func printUsage(on stream: OutputByteStream) {
        parser.printUsage(on: stream)
    }
}

struct Options {
    var filename = ""
    var verbose = false
    var shouldPrintVersion: Bool = false
}
