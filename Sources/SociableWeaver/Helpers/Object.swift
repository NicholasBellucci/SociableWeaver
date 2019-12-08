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
public class Object {
    private var name: String
    private var nameRepresentable: String
    private let fieldAggregates: String
    
    private var alias: String? = nil
    private var arguments: [Argument]? = nil

    private init(_ type: Any.Type, fieldAggregates: String) {
        self.name = String(describing: type)
        self.nameRepresentable = String(describing: type).convert(with: .lowercase)
        self.fieldAggregates = fieldAggregates
    }

    private init(_ key: CodingKey, fieldAggregates: String) {
        self.name = key.stringValue
        self.nameRepresentable = key.stringValue.convert(with: .lowercase)
        self.fieldAggregates = fieldAggregates
    }
}

public extension Object {
    /**
    Sets the alias of this field.

     - Parameter alias: The alias to use when constructing this field.
     - Returns: A `Field` with the alias in question.
     */
    func caseStyle(_ caseStyle: CaseStyleOption) -> Object {
        self.nameRepresentable = name.convert(with: caseStyle)
        return self
    }

    /**
    Sets the alias of this field.

     - Parameter alias: The alias to use when constructing this field.
     - Returns: A `Field` with the alias in question.
     */
    func alias(_ alias: String) -> Object {
        self.alias = alias
        return self
    }

    /**
    Sets the alias of this field.

     - Parameter alias: The alias to use when constructing this field.
     - Returns: A `Field` with the alias in question.
     */
    func argument(key: String, value: ArgumentValueRepresentable) -> Object {
        let argument = Argument(key: key, value: value)

        if arguments != nil {
            arguments!.append(argument)
        } else {
            arguments = [argument]
        }

        return self
    }
}

/**
Object conforms to Weavable in order to provide a description as well as a debugDescription of the object model in question.

 Example `String(describing: object)`: `post { id title content }`
 Example `String(reflecting: object)`: `post { id title content }`
 */
extension Object: Weavable {
    public var description: String {
        buildDescription().withSubfields(fieldAggregates)
    }

    public var debugDescription: String {
        buildDescription().withSubfields(fieldAggregates)
    }
}

public extension Object {
    /**
    Object initializer using the object function builder.
     This initializer accepts `Any.Type` which will be used as to determine the name.

    - parameter type: The type of `Any`.
    - parameter content: The object builder accepts structs/classes conforming to `Weavable`.
    */
    convenience init(_ type: Any.Type, @ObjectBuilder _ content: () -> String) {
        self.init(type, fieldAggregates: content())
    }

    /**
    Workaround for function builders not accepting one element yet due to it still being a prototype.
     TODO - Remove when functionBuilders are fully implemented.

     Object initializer using the object function builder.
      This initializer accepts `Any.Type` which will be used as to determine the name.

     - parameter type: The type of `Any` used for the name.
     - parameter content: The individual object conforming to `Weavable`.
    */
    convenience init(_ type: Any.Type, _ individual: BuilderType, _ content: () -> Weavable) {
        self.init(type, fieldAggregates: String(describing: content()))
    }

    /**
    Object initializer using the object function builder.
     This initializer accepts a `CodingKey` which will be used as to determine the name.

    - parameter key: The coding key used for the name.
    - parameter content: The object builder accepts structs/classes conforming to `Weavable`.
    */
    convenience init(_ key: CodingKey, @ObjectBuilder _ content: () -> String) {
        self.init(key, fieldAggregates: content())
    }

    /**
    Workaround for function builders not accepting one element yet due to it still being a prototype.
     TODO - Remove when functionBuilders are fully implemented.

     Object initializer using the object function builder.
      This initializer accepts a `CodingKey` which will be used as to determine the name.

     - parameter key: The coding key used for the name.
     - parameter content: The individual object conforming to `Weavable`.
    */
    convenience init(_ key: CodingKey, _ individual: BuilderType, _ content: () -> Weavable) {
        self.init(key, fieldAggregates: String(describing: content()))
    }
}

private extension Object {
    /// Determines which format is needed based on the parameters provided on initialization.
    func buildDescription() -> String {
        switch(alias, arguments) {
        case let(.some(alias), .some(arguments)):
            return GQLFieldFormatter.formatField(nameRepresentable, alias: alias, arguments: arguments)
        case let(.some(alias), nil):
            return GQLFieldFormatter.formatField(nameRepresentable, alias: alias)
        case let(nil, .some(arguments)):
            return GQLFieldFormatter.formatField(nameRepresentable, arguments: arguments)
        default:
            return nameRepresentable
        }
    }
}
