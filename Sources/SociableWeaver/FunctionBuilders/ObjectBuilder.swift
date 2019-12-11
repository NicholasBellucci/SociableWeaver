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
            guard let value = $0 as? Directive else { return }
            if value.skip || !value.include { return }
            if let object = value as? Object, object.remove { return }

            descriptions.append(String(describing: $0))
        }

        return descriptions.joined(separator: " ")
    }
}
