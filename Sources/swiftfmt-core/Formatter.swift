//
//  Formatter.swift
//  swiftfmt-core
//
//  Created by Kishikawa Katsumi on 2018/02/18.
//

import Foundation

public protocol LineFormatter {
    func format(_ lines: [Line], _ configuration: Configuration) -> [Line]
}

public protocol TokenFormatter {
    func format(_ tokens: [Token], _ configuration: Configuration) -> [Token]
}
