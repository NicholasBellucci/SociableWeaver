//
//  FragmentReference.swift
//  
//
//  Created by Nicholas Bellucci on 12/7/19.
//

public class FragmentReference: Directive {
    public let builder: FragmentBuilder

    var include: Bool = false
    var skip: Bool = true

    public init(for builder: FragmentBuilder) {
        self.builder = builder
    }
}

public extension FragmentReference {
    /**
    Only include this fragment reference in the operation if the argument is true.

     - Parameter argument: A boolean argument.
     - Returns: A `FragmentReference` with its include value set.
     */
    func include(if argument: Bool) -> FragmentReference {
        self.include = argument
        return self
    }

    /**
    Skip this fragment reference if the argument is true

     - Parameter argument: A boolean argument.
     - Returns: A `FragmentReference` with its skip value set.
     */
    func skip(if argument: Bool) -> FragmentReference {
        self.skip = argument
        return self
    }
}

extension FragmentReference: Weavable {
    public var description: String {
        "...\(builder.name)"
    }

    public var debugDescription: String {
        "...\(builder.name)"
    }
}
