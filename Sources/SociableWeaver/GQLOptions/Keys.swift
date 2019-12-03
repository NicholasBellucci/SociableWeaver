//
//  Keys.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

public struct Keys: GQLOption {
    let keys: [CodingKey]

    init(_ keys: [CodingKey]) {
        self.keys = keys
    }
}