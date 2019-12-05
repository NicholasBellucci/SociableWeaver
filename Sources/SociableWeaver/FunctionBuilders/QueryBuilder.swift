//
//  QueryBuilder.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

@_functionBuilder
class QueryBuilder {
    static func buildBlock(_ children: Object...) -> String {
        var values: [String] = []

        children.forEach {
            values.append($0.description)
        }

        return values.joined(separator: " ")
    }

    static func buildBlock(_ component: Object) -> String {
        return component.description
    }
}
