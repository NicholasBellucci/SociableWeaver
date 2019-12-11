//
//  Fragment.swift
//  
//
//  Created by Nicholas Bellucci on 12/7/19.
//

public struct Fragment {
    let builder: FragmentBuilder
    let fieldAggregates: String

    private init(_ builder: FragmentBuilder, fieldAggregates: String) {
        self.builder = builder
        self.fieldAggregates = fieldAggregates
    }
}

extension Fragment: Weavable {
    public var description: String {
        String(describing: builder).withSubfields(fieldAggregates)
    }

    public var debugDescription: String {
        String(describing: builder).withSubfields(fieldAggregates)
    }
}

public extension Fragment {
    /**
    Fragment initializer using the object function builder.
     This initializer accepts a `FragmentBuilder` object which will be used as to determine the name.

    - parameter builder: The objects fragment builder.
    - parameter content: The object builder accepts structs/classes conforming to `Weavable`.
    */
    init(_ builder: FragmentBuilder, @ObjectBuilder _ content: () -> String) {
        self.init(builder, fieldAggregates: content())
    }
}
