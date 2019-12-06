//
//  RequestBuilder.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

@_functionBuilder
internal struct RequestBuilder {
    static func buildBlock(_ children: Object...) -> String {
        var values: [String] = []

        children.forEach {
            values.append(String(describing: $0))
        }

        return values.joined(separator: " ")
    }

    static func buildBlock(_ component: Object) -> String {
        String(describing: component)
    }
}
