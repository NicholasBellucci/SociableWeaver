//
//  ObjectBuilder.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

import Foundation

@_functionBuilder
internal struct ObjectBuilder {
    static func buildBlock(_ children: Weavable...) -> String {
        var descriptions: [String] = []

        children.forEach {
            descriptions.append(String(describing: $0))
        }

        return descriptions.joined(separator: " ")
    }
}
