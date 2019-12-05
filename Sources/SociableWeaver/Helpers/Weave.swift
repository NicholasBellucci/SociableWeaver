//
//  Weave.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

public struct Weave: CustomStringConvertible {
    let type: OperationType
    public var description: String

    private init(type: OperationType, description: String) {
        self.type = type
        self.description = description
    }
}

extension Weave {
    init(_ type: OperationType, @QueryBuilder _ content: () -> String) {
        self.init(type: type, description: type.stringValue.withSubfields(content()))
    }
}
