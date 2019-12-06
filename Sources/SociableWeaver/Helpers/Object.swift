//
//  Object.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

/**
`Object` is a model consisting of a name and description.

 `Object.name`
 The name of the object that will be returned.

 `Object.fields`
 The aggregated fields that make up the object.
*/
public struct Object {
    public let name: String
    public let fields: String

    private init(_ name: String, fields: String) {
        self.name = name
        self.fields = fields
    }
}

/**
Object conforms to CustomStringConvertible as well as CustomDebugStringConvertible in order to provide
 a description as well as a debugDescription of the object model in question.

 Example `String(describing: object)`: `post { id title content }`
 Example `String(reflecting: object)`: `post { id title content }`
 */
extension Object: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        name.withSubfields(fields)
    }

    public var debugDescription: String {
        name.withSubfields(fields)
    }
}

public extension Object {
    /**
    Object initializer using the object function builder.
     This initializer accepts a type which will be converted to a string representation and used as the name.

    - parameter type: The object type to be converted.
    - parameter caseStyleOption: The case style for the converted type string.
    - parameter content: The object builder accepts structs/classes conforming to `CustomStringConvertable`.
    */
    init(_ type: Any.Type, caseStyleOption: CaseStyleOption = .lowercase, @ObjectBuilder _ content: () -> String) {
        let name = String(describing: type).convert(with: caseStyleOption)
        self.init(name, fields: content())
    }

    /**
    Workaround for function builders not accepting one element yet due to it still being a prototype.
     TODO - Remove when functionBuilders are fully implemented.

     Object initializer using the object function builder.
     This initializer accepts a type which will be converted to a string representation and used as the name.

    - parameter type: The object type to be converted.
    - parameter caseStyleOption: The case style for the converted type string.
    - parameter content: The object builder accepts structs/classes conforming to `CustomStringConvertable`.
    */
    init(_ type: Any.Type, caseStyleOption: CaseStyleOption = .lowercase, _ content: () -> CustomStringConvertible) {
        let name = String(describing: type).convert(with: caseStyleOption)
        var stringRepresentation: String = ""

        if let value = content() as? CodingKey {
            stringRepresentation = value.stringValue
        } else if let value = content() as? Object {
            stringRepresentation = value.fields
        }

        self.init(name, fields: stringRepresentation)
    }

    /**
    Object initializer using the object function builder.
     This initializer accepts a coding key which will be used as the name.

    - parameter key: The coding key to be used.
    - parameter content: The object builder accepts structs/classes conforming to `CustomStringConvertable`.
    */
    init(_ key: CodingKey, @ObjectBuilder _ content: () -> String) {
        let name = key.stringValue
        self.init(name, fields: content())
    }

    /**
    Workaround for function builders not accepting one element yet due to it still being a prototype.
     TODO - Remove when functionBuilders are fully implemented.

     This initializer accepts a coding key which will be used as the name.

    - parameter key: The coding key to be used.
    - parameter content: The closure returning a `CustomStringConvertible`.
    */
    init(_ key: CodingKey, _ content: () -> CustomStringConvertible) {
        let name = key.stringValue
        var stringRepresentation: String = ""

        if let value = content() as? CodingKey {
            stringRepresentation = value.stringValue
        } else if let value = content() as? Object {
            stringRepresentation = value.fields
        }

        self.init(name, fields: stringRepresentation)
    }
}
