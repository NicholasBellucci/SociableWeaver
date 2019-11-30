//
//  Fields.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

public class Fields: GQLOption {
    let name: String
    let result: String

    private init(_ name: String, result: String) {
        self.name = name
        self.result = result
    }
}

extension Fields {
    convenience init(_ name: String, @FieldsBuilder _ content: () -> String) {
        self.init(name, result: content())
    }
}
