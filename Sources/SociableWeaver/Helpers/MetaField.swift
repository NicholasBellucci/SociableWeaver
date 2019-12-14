/// Includes the GraphQL meta field typename as well as any custom meta field.
public enum MetaFieldType {
    case typename
    case custom(String)
}

/// GraphQL allows meta fields as part of a request.
public struct MetaField: Directive {
    private var type: MetaFieldType

    var include: Bool = true
    var skip: Bool = false

    public init(_ type: MetaFieldType) {
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
        var copy = self
        copy.include = argument
        return copy
    }

    /**
    Skip typename if the argument is true

     - Parameter argument: A boolean argument.
     - Returns: A `Typename` with its skip value set.
     */
    func skip(if argument: Bool) -> MetaField {
        var copy = self
        copy.skip = argument
        return copy
    }
}

/// `MetaField` conforms to `ObjectWeavable` in order to provide a description as well as a debug description.
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
