/**
 GraphQL `Fragments` let you construct sets of fields, and then include them in queries where you need to.

 `Fragment.builder`
 The `FragmentBuilder` which will be used to construct the fragment's field.

 `Fragment.fieldAggregates`
 The aggregated fields that make up the fragment.
*/
public struct Fragment {
    var builder: FragmentBuilder
    let fieldAggregates: String

    private init(_ builder: FragmentBuilder, fieldAggregates: String) {
        self.builder = builder
        self.fieldAggregates = fieldAggregates
    }
}

public extension Fragment {
    /**
    Fragment initializer using the object function builder.
     This initializer accepts a `FragmentBuilder` object which will be used as to determine the name.

    - parameter builder: The objects fragment builder.
    - parameter content: The object builder accepts structs/classes conforming to `ObjectWeavable`.
    */
    init(_ builder: FragmentBuilder, @ObjectBuilder _ content: () -> String) {
        self.init(builder, fieldAggregates: content())
    }

    /**
    Workaround for function builders not accepting one element yet due to it still being a prototype.
     TODO - Remove when functionBuilders are fully implemented.

    Fragment initializer using the object function builder.
     This initializer accepts a `FragmentBuilder` object which will be used as to determine the name.

    - parameter builder: The objects fragment builder.
    - parameter content: The individual object conforming to `ObjectWeavable`
    */
    init(_ builder: FragmentBuilder, _ individual: BuilderType, _ content: () -> ObjectWeavable) {
        self.init(builder, fieldAggregates: String(describing: content()))
    }
}

/**
`Fragment` conforms to `ObjectWeavable` in order to provide a description as well as a debug description of the fragment in question.

 Example `String(describing: field)`: `fragment authorFields on Author { id name }`
 Example `String(reflecting: field)`: `fragment authorFields on Author { id name }`
 */
extension Fragment: Weavable {
    public var description: String {
        String(describing: builder).withSubfields(fieldAggregates)
    }

    public var debugDescription: String {
        String(describing: builder).withSubfields(fieldAggregates)
    }
}
