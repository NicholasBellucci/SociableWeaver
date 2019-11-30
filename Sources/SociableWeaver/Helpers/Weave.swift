//
//  Weave.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

public class Weave {
    let type: OperationType
    var result: String

    private init(_ type: OperationType, result: String) {
        self.type = type
        self.result = "{ \(result) }"
    }
}

extension Weave {
    convenience init(_ type: OperationType, @QueryBuilder _ content: () -> String) {
        self.init(type, result: content())
    }
}
