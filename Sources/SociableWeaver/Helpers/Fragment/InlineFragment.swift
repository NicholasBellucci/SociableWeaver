/**
 GraphQL `Inline Fragments` are used when querying a field that returns an interface or a union type.

 `Fragment.type`
 The object model that will be queried on.

 `Fragment.fieldAggregates`
 The aggregated fields that make up the fragment.
*/
public class InlineFragment: Directive {
    var type: String
    let fieldAggregates: String

    var include: Bool = true
    var skip: Bool = false
    var remove: Bool = false

    private init(_ type: String, fieldAggregates: String) {
        self.type = type
        self.fieldAggregates = fieldAggregates
    }
}

public extension InlineFragment {
    /**
    Only include this inline fragment in the operation if the argument is true.

     - Parameter argument: A boolean argument.
     - Returns: An `Object` with its include value set.
     */
    func include(if argument: Bool) -> InlineFragment {
        self.include = argument
        return self
    }

    /**
    Skip this inline fragment if the argument is true

     - Parameter argument: A boolean argument.
     - Returns: An `Object` with its skip value set.
     */
    func skip(if argument: Bool) -> InlineFragment {
        self.skip = argument
        return self
    }
}

public extension InlineFragment {
    /**
    Inline fragment initializer using a class type as the object type.

    - parameter type: The class type.
    - parameter content: The object builder accepts structs/classes conforming to `ObjectWeavable`.
    */
    convenience init(_ type: Any.Type, @ObjectBuilder _ content: () -> String) {
        let type = String(describing: type)
        self.init(type, fieldAggregates: content())
        self.remove = shouldRemove(content: content)
    }

    /**
    Workaround for function builders not accepting one element yet due to it still being a prototype.
     TODO - Remove when functionBuilders are fully implemented.

    Inline fragment initializer using a class type as the object type.

    - parameter type: The class type.
    - parameter content: The individual object conforming to `ObjectWeavable`.
    */
    convenience init(_ type: Any.Type, _ individual: BuilderType, _ content: () -> ObjectWeavable) {
        let type = String(describing: type)
        self.init(type, fieldAggregates: String(describing: content()))
        self.remove = shouldRemove(content: content)
    }

    /**
    Inline fragment initializer using a string as the object type.

    - parameter type: The string representation of type.
    - parameter content: The object builder accepts structs/classes conforming to `ObjectWeavable`.
    */
    convenience init(_ type: String, @ObjectBuilder _ content: () -> String) {
        self.init(type, fieldAggregates: content())
        self.remove = shouldRemove(content: content)
    }

    /**
    Workaround for function builders not accepting one element yet due to it still being a prototype.
     TODO - Remove when functionBuilders are fully implemented.

    Inline fragment initializer using a string as the object type.

    - parameter type: The string representation of type.
    - parameter content: The individual object conforming to `ObjectWeavable`.
    */
    convenience init(_ type: String, _ individual: BuilderType, _ content: () -> ObjectWeavable) {
        self.init(type, fieldAggregates: String(describing: content()))
        self.remove = shouldRemove(content: content)
    }
}

/**
`InlineFragment` conforms to `ObjectWeavable` in order to provide a description as well as a debug description of the inline fragment in question.

 Example `String(describing: field)`: `... on AnonymousUser { id }`
 Example `String(reflecting: field)`: `... on AnonymousUser { id }`
 */
extension InlineFragment: ObjectWeavable {
    public var description: String {
        "... on \(type)".withSubfields(fieldAggregates)
    }

    public var debugDescription: String {
        "... on \(type)".withSubfields(fieldAggregates)
    }
}

extension InlineFragment: Removable {
    /// Objects containing no fields are removed.
    func shouldRemove(content: () -> CustomStringConvertible) -> Bool {
        if let value = content() as? Directive {
            if value.skip || !value.include {
                return true
            }
        }

        if let value = content() as? String {
            if value == "" {
                return true
            }
        }

        return false
    }
}
