//
//  ObjectBuilder.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

import Foundation

@_functionBuilder
struct ObjectBuilder {
    public static func buildBlock(_ children: ObjectWeavable...) -> String {
        var descriptions: [String] = []

        children.forEach {
            guard let directive = $0 as? Directive else { return }
            if directive.skip || !directive.include { return }
            if let removable = directive as? Removable, removable.remove { return }

            descriptions.append(String(describing: $0))
        }

        return descriptions.joined(separator: " ")
    }
}
