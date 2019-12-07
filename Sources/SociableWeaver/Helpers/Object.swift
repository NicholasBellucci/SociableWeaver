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
    public var field: Field
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
     This initializer accepts a `Field` object which will be used as to determine the name.

    - parameter field: The objects parent field.
    - parameter content: The object builder accepts structs/classes conforming to `Weavable`.
    */
    init(_ field: Field, @ObjectBuilder _ content: () -> String) {
        self.init(field, fieldAggregates: content())
    }

    /**
    Workaround for function builders not accepting one element yet due to it still being a prototype.
     TODO - Remove when functionBuilders are fully implemented.

     Object initializer using the object function builder.
      This initializer accepts a `Field` object which will be used as to determine the name.

     - parameter field: The objects parent field.
     - parameter content: The individual object conforming to `Weavable`.
    */
    init(_ field: Field, individual: Bool, _ content: () -> Weavable) {
        self.init(field, fieldAggregates: String(describing: content()))
    }
}
