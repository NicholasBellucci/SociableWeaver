//
//  KeysBuilder.swift
//  
//
//  Created by Nicholas Bellucci on 12/4/19.
//

@_functionBuilder
class KeysBuilder {
    static func buildBlock(_ children: Object...) -> [KeyFieldsPair] {
        var pairs: [KeyFieldsPair] = []

        children.forEach {
            pairs.append(KeyFieldsPair(key: $0.name, result: $0.name.withSubfields($0.result)))
        }

        return pairs
    }

    static func buildBlock(_ component: Object) -> KeyFieldsPair {
        return KeyFieldsPair(key: component.name, result: component.name.withSubfields(component.result))
    }
}
