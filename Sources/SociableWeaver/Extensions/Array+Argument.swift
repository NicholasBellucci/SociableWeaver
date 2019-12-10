//
//  Array+Argument.swift
//  
//
//  Created by Nicholas Bellucci on 12/6/19.
//

extension Array where Element == (key: String, value: ArgumentValueRepresentable) {
    /// The GraphQL Representation of an arguments array
    var graphQLRepresentable: String {
        var components: [String] = []

        forEach {
            components.append("\($0.key): \($0.value.argumentValue)")
        }

        return components.joined(separator: ", ")
    }
}
