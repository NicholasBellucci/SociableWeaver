//
//  QueryBuilder.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

@_functionBuilder
class QueryBuilder {
    static func buildBlock(_ segments: Fields...) -> String {
        var values: [String] = []

        segments.forEach {
            values.append($0.name.withSubfields($0.result))
        }

        return values.joined(separator: " ")
    }
}
