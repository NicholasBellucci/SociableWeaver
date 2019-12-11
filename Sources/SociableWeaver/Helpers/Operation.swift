//
//  Operation.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

/**
`Operation` is a model consisting of a type and description.

 `Operation.type`
 The type of GraphQL operation to be created.

 `Operation.fields`
 The aggregated fields that make up the operation.
*/

public struct Operation {
    private let type: OperationType
    private let fields: String

    private init(type: OperationType, fields: String) {
        self.type = type
        self.fields = fields
    }
}

/**
Operation conforms to CustomStringConvertible as well as CustomDebugStringConvertible in order to provide
 a description as well as a debugDescription of the operation model in question.

 Example `String(describing: operation)`: `query { post { id title content } }`
 Example `String(reflecting: operation)`: `query { post { id title content } }`
 */
extension Operation: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        "\(type) \(fields)"
    }

    public var debugDescription: String {
        "\(type) \(fields)"
    }
}

public extension Operation {
    /**
    Operation initializer using the operation function builder.

    - parameter type: The operation type to be created.
    - parameter content: The operation builder accepts `Weavable` models.
    */
    init(_ type: OperationType, @OperationBuilder _ content: () -> String) {
        self.init(type: type, fields: String(describing: content()))
    }

    /**
    Workaround for function builders not accepting one element yet due to it still being a prototype.
     TODO - Remove when functionBuilders are fully implemented.

     Operation initializer using the operation function builder.

    - parameter type: The operation type to be created.
    - parameter buildType: The builder type only exists to avoid ambiguous init error.
    - parameter content: The individual `Weavable` model.
    */
    init(_ type: OperationType, _ buildType: BuilderType = .individual, _ content: () -> Weavable) {
        self.init(type: type, fields: "{ \(String(describing: content())) }")
    }
}
