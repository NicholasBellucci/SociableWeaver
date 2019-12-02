//
//  FieldsBuilder.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

import Foundation

@_functionBuilder
class FieldsBuilder {
    static func buildBlock(_ children: GQLOption...) -> String {
        var keys: [String] = []
        var exclusions: [String] = []
        var merge: [(key: String, results: String)] = []

        children.forEach {
            if let value = $0 as? Keys {
                keys += value.keys.map { $0.stringValue }
            } else if let value = $0 as? Exclude {
                exclusions += value.keys.map { $0.stringValue }
            } else if let value = $0 as? Merge {
                merge += [(key: value.key.stringValue, results: value.result)]
            }
        }

        keys = keys.filter { !exclusions.contains($0) }

        merge.forEach {
            guard let index = keys.firstIndex(of: $0.key) else { return }
            keys[index] = $0.key.withSubfields($0.results)
        }

        return keys.joined(separator: " ")
    }

    static func buildBlock(_ component: GQLOption) -> String {
        guard let component = component as? Keys else { return "" }
        return component.keys.map { $0.stringValue }.joined(separator: " ")
    }
}
