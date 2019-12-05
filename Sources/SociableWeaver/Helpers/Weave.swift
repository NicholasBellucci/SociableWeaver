//
//  Weave.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

public struct Weave: CustomStringConvertible {
    public let type: OperationType
    public let description: String

    private init(type: OperationType, description: String) {
        self.type = type
        self.description = description
    }
}

extension Weave {
    init(_ type: OperationType, @QueryBuilder _ content: () -> String) {
        self.init(type: type, description: type.rawValue.withSubfields(content()))
    }
}
