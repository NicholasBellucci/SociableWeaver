//
//  ObjectBuilder.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

import Foundation

@_functionBuilder
class ObjectBuilder {
    static func buildBlock(_ children: CustomStringConvertible...) -> String {
        var descriptions: [String] = []

        children.forEach {
            if let value = $0 as? CodingKey {
                descriptions.append(value.stringValue)
            } else if let value = $0 as? Object {
                descriptions.append(value.description)
            }
        }

        return descriptions.joined(separator: " ")
    }
}
