//
//  Request.swift
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
    public let type: RequestType
    public let description: String

    private init(type: RequestType, description: String) {
        self.type = type
        self.description = description
    }
}

public extension Request {
    /**
    Request initializer using the request function builder.

    - parameter type: The request type to be created.
    - parameter content: The request builder accepts `Object` models.
    */
    init(_ type: RequestType, @RequestBuilder _ content: () -> String) {
        self.init(type: type, description: type.rawValue.withSubfields(content()))
    }

    /**
    Workaround for function builders not accepting one element yet due to it still being a prototype.
     TODO - Remove when functionBuilders are fully implemented.
     
     Request initializer using the request function builder.

    - parameter type: The request type to be created.
    - parameter content: The request builder accepts `Object` models.
    */
    init(_ type: RequestType, _ content: () -> Object) {
        self.init(type: type, description: type.rawValue.withSubfields(content().description))
    }
}
