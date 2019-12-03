//
//  Merge.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

public struct Merge: GQLOption {
    let key: CodingKey
    let result: String

    private init(_ key: CodingKey, result: String) {
        self.key = key
        self.result = result
    }
}

extension Merge {
    init(_ key: CodingKey, @FieldsBuilder _ content: () -> String) {
        self.init(key, result: content())
    }
}
