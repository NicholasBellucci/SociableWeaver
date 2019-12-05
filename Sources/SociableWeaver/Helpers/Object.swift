//
//  Object.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

struct Object: CustomStringConvertible {
    let name: String
    var description: String

    init(_ name: String, description: String) {
        self.name = name
        self.description = description
    }
}

extension Object {
    init(_ type: Any.Type, caseStyleOption: CaseStyleOption = .lowercase, @ObjectBuilder _ content: () -> String) {
        self.init(String(describing: type).convert(with: caseStyleOption), description: content())
    }

    init(_ key: CodingKey, @ObjectBuilder _ content: () -> String) {
        self.init(key.stringValue, description: content())
    }
}
