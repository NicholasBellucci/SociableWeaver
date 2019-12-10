//
//  Object.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

/**
`Object` is a model consisting of a name and description.

 `Object.field`
 The parent field of the object.

 `Object.fieldAggregates`
 The aggregated fields that make up the object.
*/
public struct Object {
    public let field: Field
    public let fieldAggregates: String

    private init(_ field: Field, fieldAggregates: String) {
        self.field = field
        self.fieldAggregates = fieldAggregates
    }
}

/**
Object conforms to Weavable in order to provide a description as well as a debugDescription of the object model in question.

 Example `String(describing: object)`: `post { id title content }`
 Example `String(reflecting: object)`: `post { id title content }`
 */
extension Object: Weavable {
    public var description: String {
        String(describing: field).withSubfields(fieldAggregates)
    }

    public var debugDescription: String {
        String(describing: field).withSubfields(fieldAggregates)
    }
}

public extension Object {
    /**
    Object initializer using the object function builder.
     This initializer accepts a coding key which will be used as the name.

    - parameter key: The coding key to be used.
    - parameter content: The object builder accepts structs/classes conforming to `Weavable`.
    */
    init(_ field: Field, @ObjectBuilder _ content: () -> String) {
        self.init(field, fieldAggregates: content())
    }
}
