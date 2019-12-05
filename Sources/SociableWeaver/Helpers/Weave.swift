//
//  Weave.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

/**
`Request` is a model consisting of a type and description.

 `Request.type`
 The type of GraphQL request to be created.

 `Request.description`
 The request represented as a string. This string includes the type of request as well
 as the wrapped objects requested by the user.

 Example `Request.description`: `query { post { id title content } }`
*/

public struct Request: CustomStringConvertible {
    public let type: OperationType
    public let description: String

    private init(type: OperationType, description: String) {
        self.type = type
        self.description = description
    }
}

public extension Request {
    init(_ type: OperationType, @QueryBuilder _ content: () -> String) {
        self.init(type: type, description: type.rawValue.withSubfields(content()))
    }
}
