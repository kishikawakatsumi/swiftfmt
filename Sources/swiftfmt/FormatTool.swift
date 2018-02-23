//
//  FormatTool.swift
//  swiftfmt
//
//  Created by Kishikawa Katsumi on 2018/02/14.
//

import Foundation
import Basic
import swiftfmt_core

struct FormatTool {
    private let verbose: Bool
    private let fileSystem = Basic.localFileSystem

    init(verbose: Bool) {
        self.verbose = verbose
    }

    func run(source: URL, options: [String]) throws {
        let processor = Processor(options: options)
        let configuration = Configuration.load(file: URL(fileURLWithPath: ".swiftfmt.json"))

        let path = AbsolutePath(source.absoluteURL.path)
        if fileSystem.isFile(path) {
            try processFile(path, processor: processor, configuration: configuration)
        } else if fileSystem.isDirectory(path) {
            try processDirectory(path, processor: processor, configuration: configuration)
        } else {
            print("no input files or directory")
        }
    }

    func processFile(_ path: AbsolutePath, processor: Processor, configuration: Configuration) throws {
        if let ext = path.extension, ext == "swift" {
            let result = try processor.processFile(input: URL(fileURLWithPath: path.asString), configuration: configuration, verbose: verbose)
            try fileSystem.writeFileContents(path, bytes: ByteString(encodingAsUTF8: result))
        }
    }

    func processDirectory(_ directory: AbsolutePath, processor: Processor, configuration: Configuration) throws {
        for relPath in try fileSystem.getDirectoryContents(directory) {
            let path = AbsolutePath(directory, relPath)
            if fileSystem.isFile(path) {
                try processFile(path, processor: processor, configuration: configuration)
            } else {
                try processDirectory(path, processor: processor, configuration: configuration)
            }
        }
    }
}
