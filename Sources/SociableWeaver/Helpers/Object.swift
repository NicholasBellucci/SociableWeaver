//
//  Object.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

/**
`Object` is a model consisting of a name and description.

 `Object.name`
 The name of the object that will be returned.

 `Object.description`
 The requested object represented as a string. This string includes the name of the object as well
 as the wrapped aggregated fields requested by the user.

 Example `Object.description`: `post { id title content }`
*/
public struct Object: CustomStringConvertible {
    public let name: String
    public let description: String

    private init(_ name: String, description: String) {
        self.name = name
        self.description = description
    }
}

public extension Object {
    init(_ type: Any.Type, caseStyleOption: CaseStyleOption = .lowercase, @ObjectBuilder _ content: () -> String) {
        let name = String(describing: type).convert(with: caseStyleOption)
        self.init(name, description: name.withSubfields(content()))
    }

    init(_ key: CodingKey, @ObjectBuilder _ content: () -> String) {
        let name = key.stringValue
        self.init(name, description: name.withSubfields(content()))
    }
}
