//
//  Weave.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

public struct Weave {
    let type: OperationType
    var result: String
}

extension Weave {
    init(_ type: OperationType, @QueryBuilder _ content: () -> String) {
        self.init(type: type, result: type.stringValue.withSubfields(content()))
    }
}
