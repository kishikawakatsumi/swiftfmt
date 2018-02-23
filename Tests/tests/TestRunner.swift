//
//  TestRunner.swift
//  tests
//
//  Created by Kishikawa Katsumi on 2018/02/18.
//

import Foundation
import Basic
@testable import swiftfmt_core

class TestRunner {
    func run(source: String, configuration: Configuration) -> String {
        let temporaryDirectory = try! TemporaryDirectory(prefix: "com.kishikawakatsumi.swiftfmt", removeTreeOnDeinit: true)
        let temporaryFile = try! TemporaryFile(dir: temporaryDirectory.path, prefix: "Tests", suffix: ".swift").path
        let sourceFilePath = temporaryFile.asString

        try! source.write(toFile: sourceFilePath, atomically: true, encoding: .utf8)

        let processor = Processor()
        let result = try! processor.processFile(input: URL(fileURLWithPath: sourceFilePath), configuration: configuration, verbose: true)
        print(result)

        return result
    }
}
