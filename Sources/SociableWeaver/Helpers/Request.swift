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

 `Object.fields`
 The aggregated fields that make up the request.
*/

public struct Request {
    public let type: OperationType
    public let fields: String

    private init(type: OperationType, fields: String) {
        self.type = type
        self.fields = fields
    }
}

/**
Request conforms to CustomStringConvertible as well as CustomDebugStringConvertible in order to provide
 a description as well as a debugDescription of the request model in question.

 Example `String(describing: request)`: `query { post { id title content } }`
 Example `String(reflecting: request)`: `query { post { id title content } }`
 */
extension Request: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        "\(type) \(fields)"
    }

    public var debugDescription: String {
        "\(type) \(fields)"
    }
}

public extension Request {
    /**
    Request initializer using the request function builder.

    - parameter type: The request type to be created.
    - parameter content: The request builder accepts `Object` models.
    */
    init(_ type: OperationType, @RequestBuilder _ content: () -> String) {
        self.init(type: type, fields: String(describing: content()))
    }

    /**
    Workaround for function builders not accepting one element yet due to it still being a prototype.
     TODO - Remove when functionBuilders are fully implemented.

     Request initializer using the request function builder.

    - parameter type: The request type to be created.
    - parameter content: The individual `Object`.
    */
    init(_ type: OperationType, individual: Bool = true, _ content: () -> Object) {
        self.init(type: type, fields: "{ \(String(describing: content())) }")
    }
}
