//
//  OperationType.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

public enum OperationType: String {
    case query = "query"
    case mutation = "mutation"

    var stringValue: String {
        return self.rawValue
    }
}
