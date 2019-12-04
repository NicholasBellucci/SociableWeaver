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
        var pairs: [KeyFieldsPair] = []
        var exclusions: [String] = []

        children.forEach {
            if let value = $0 as? Keys {
                keys += value.keys.map { $0.stringValue }
                pairs += value.pairs
            } else if let value = $0 as? Exclude {
                exclusions += value.keys.map { $0.stringValue }
            }
        }

        keys = keys.filter { !exclusions.contains($0) }
        pairs = pairs.filter { !exclusions.contains($0.key) }

        var results = keys.joined(separator: " ")

        pairs.forEach {
            results = results.replacingOccurrences(of: $0.key, with: $0.result)
        }

        return results
    }

    static func buildBlock(_ component: GQLOption) -> String {
        guard let component = component as? Keys else { return "" }
        return component.keys.map { $0.stringValue }.joined(separator: " ")
    }
}
