//
//  Object.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

public struct Object {
    let name: String
    let result: String
}

extension Object {
    init(_ name: String, @FieldsBuilder _ content: () -> String) {
        self.init(name: name, result: content())
    }
}
