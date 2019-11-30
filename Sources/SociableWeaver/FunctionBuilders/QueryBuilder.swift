//
//  QueryBuilder.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

@_functionBuilder
class QueryBuilder {
    static func buildBlock(_ children: Fields...) -> String {
        var values: [String] = []

        children.forEach {
            values.append($0.name.withSubfields($0.result))
        }

        return values.joined(separator: " ")
    }

    static func buildBlock(_ component: Fields) -> String {
        return component.name.withSubfields(component.result)
    }
}