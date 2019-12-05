//
//  Object.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

struct Object: CustomStringConvertible {
    public let name: String
    public let description: String

    private init(_ name: String, description: String) {
        self.name = name
        self.description = description
    }
}

extension Object {
    init(_ type: Any.Type, caseStyleOption: CaseStyleOption = .lowercase, @ObjectBuilder _ content: () -> String) {
        let name = String(describing: type).convert(with: caseStyleOption)
        self.init(name, description: name.withSubfields(content()))
    }

    init(_ key: CodingKey, @ObjectBuilder _ content: () -> String) {
        let name = key.stringValue
        self.init(name, description: name.withSubfields(content()))
    }
}
