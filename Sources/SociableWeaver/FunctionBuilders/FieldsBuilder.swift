//
//  FieldsBuilder.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

@_functionBuilder
class FieldsBuilder {
    static func buildBlock(_ segments: GQLOption...) -> String {
        var keys: [String] = []
        var exclusions: [String] = []
        var merge: [(key: String, results: String)] = []

        segments.forEach {
            switch $0 {
            case is Keys:
                guard let value = $0 as? Keys else { return }
                keys += value.keys.map { $0.stringValue }
            case is Exclude:
                guard let value = $0 as? Exclude else { return }
                exclusions += value.keys.map { $0.stringValue }
            case is Merge:
                guard let value = $0 as? Merge else { return }
                merge += [(key: value.key.stringValue, results: value.result)]
            default:
                break
            }
        }

        keys = keys.filter { !exclusions.contains($0) }

        merge.forEach {
            guard let index = keys.firstIndex(of: $0.key) else { return }
            keys[index] = $0.key.withSubfields($0.results)
        }

        return keys.joined(separator: " ")
    }
}
