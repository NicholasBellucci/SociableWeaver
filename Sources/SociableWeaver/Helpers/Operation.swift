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

public class Operation {
    private let type: OperationType
    private let fields: String
    
    private var name: String?

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
        buildDescription()
    }

    public var debugDescription: String {
        buildDescription()
    }
}

public extension Operation {
    /**
    Sets the operation name.

     - Parameter name: The desired name of the operation.
     - Returns: An `Operation` with the name as the parent field.
     */
    func name(_ name: String) -> Operation {
        self.name = name
        return self
    }
}

public extension Operation {
    /**
    Operation initializer using the operation function builder.

    - parameter type: The operation type to be created.
    - parameter content: The operation builder accepts `Weavable` models.
    */
    convenience init(_ type: OperationType, @OperationBuilder _ content: () -> String) {
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
    convenience init(_ type: OperationType, _ buildType: BuilderType = .individual, _ content: () -> Weavable) {
        self.init(type: type, fields: "{ \(String(describing: content())) }")
    }
}

private extension Operation {
    /// Determines which format is needed based on the parameters provided on initialization.
    func buildDescription() -> String {
        switch name {
        case let .some(name):
            return "\(type) \(name) \(fields)"
        default:
            return "\(type) \(fields)"
        }
    }
}
