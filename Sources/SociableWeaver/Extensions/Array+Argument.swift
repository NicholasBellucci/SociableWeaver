//
//  Array+Argument.swift
//  
//
//  Created by Nicholas Bellucci on 12/6/19.
//

extension Array where Element == Argument {
    var graphQLRepresentable: String {
        var components: [String] = []

        forEach {
            components.append("\($0.key): \($0.value.argumentValue)")
        }

        return components.joined(separator: ", ")
    }
}