//
//  Keys.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

typealias KeyFieldsPair = (key: String, result: String)

public struct Keys: GQLOption {
    let keys: [CodingKey]
    var pairs: [KeyFieldsPair] = []

    init(_ keys: [CodingKey]) {
        self.keys = keys
    }

    private init(_ keys: [CodingKey], pairs: [KeyFieldsPair]) {
        self.keys = keys
        self.pairs = pairs
    }
}

extension Keys {
    init(_ keys: [CodingKey], @KeysBuilder _ content: () -> [KeyFieldsPair]) {
        self.init(keys, pairs: content())
    }
}
