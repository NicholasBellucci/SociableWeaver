//
//  MetaField.swift
//  
//
//  Created by Nicholas Bellucci on 12/11/19.
//

public enum MetaFieldType {
    case typename
    case custom(String)
}

/// GraphQL allows you to request `__typename`, a meta field, at any point in a query to get the name of the object type at that point.
public class MetaField: Directive {
    private var type: MetaFieldType

    var include: Bool = true
    var skip: Bool = false

    public init(type: MetaFieldType) {
        self.type = type
    }
}

public extension MetaField {
    /**
    Only include typename if the argument is true.

     - Parameter argument: A boolean argument.
     - Returns: A `Typename` with its include value set.
     */
    func include(if argument: Bool) -> MetaField {
        self.include = argument
        return self
    }

    /**
    Skip typename if the argument is true

     - Parameter argument: A boolean argument.
     - Returns: A `Typename` with its skip value set.
     */
    func skip(if argument: Bool) -> MetaField {
        self.skip = argument
        return self
    }
}

/// `Typename` conforms to `ObjectWeavable` in order to provide a description as well as a debug description.
extension MetaField: ObjectWeavable {
    public var description: String {
        buildDescription()
    }

    public var debugDescription: String {
        buildDescription()
    }
}

private extension MetaField {
    /// Determines which format is needed based on the parameters provided on initialization.
    func buildDescription() -> String {
        switch type {
        case .typename:
            return "__typename"
        case .custom(let field):
            return "__\(field)"
        }
    }
}
