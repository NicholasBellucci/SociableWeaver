//
//  Object.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

public struct Object {
    let name: String
    let result: String

    private init(_ name: String, result: String) {
        self.name = name
        self.result = result
    }
}

extension Object {
    init(_ name: String, @FieldsBuilder _ content: () -> String) {
        self.init(name, result: content())
    }
}
