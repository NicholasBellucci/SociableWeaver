//
//  Typename.swift
//  
//
//  Created by Nicholas Bellucci on 12/11/19.
//

/// GraphQL allows you to request `__typename`, a meta field, at any point in a query to get the name of the object type at that point.
public class Typename: Directive {
    var include: Bool = true
    var skip: Bool = false
}

public extension Typename {
    /**
    Only include typename if the argument is true.

     - Parameter argument: A boolean argument.
     - Returns: A `Typename` with its include value set.
     */
    func include(if argument: Bool) -> Typename {
        self.include = argument
        return self
    }

    /**
    Skip typename if the argument is true

     - Parameter argument: A boolean argument.
     - Returns: A `Typename` with its skip value set.
     */
    func skip(if argument: Bool) -> Typename {
        self.skip = argument
        return self
    }
}

/// `Typename` conforms to `ObjectWeavable` in order to provide a description as well as a debug description.
extension Typename: ObjectWeavable {
    public var description: String {
        "__typename"
    }

    public var debugDescription: String {
        "__typename"
    }
}
