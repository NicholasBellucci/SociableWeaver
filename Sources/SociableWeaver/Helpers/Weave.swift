//
//  Weave.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

public struct Weave {
    let type: OperationType
    var result: String

    private init(_ type: OperationType, result: String) {
        self.type = type
        self.result = type.stringValue.withSubfields(result)
    }
}

extension Weave {
    init(_ type: OperationType, @QueryBuilder _ content: () -> String) {
        self.init(type, result: content())
    }
}
