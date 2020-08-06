/**
GraphQL fields are used to ask for specific fields on objects.

 `Field.name`
 The raw name provided to the field.
*/
public struct Field: Directive {
    private var name: String
    private var nameRepresentable: String
    
    private var alias: String? = nil
    private var arguments: [Argument]? = nil

    var include: Bool = true
    var skip: Bool = false

    public init(_ type: Any.Type) {
        self.name = String(describing: type)
        self.nameRepresentable = String(describing: type).convert(with: .camelCase)
    }

    public init(_ key: CodingKey) {
        self.name = key.stringValue
        self.nameRepresentable = key.stringValue.convert(with: .camelCase)
    }
}

public extension Field {
    /**
    Sets the case style of this field.

     - Parameter caseStyle: The case style to use when constructing this field.
     - Returns: A `Field` with the case style applied to the name.
     */
    func caseStyle(_ caseStyle: CaseStyleOption) -> Field {
        var copy = self
        copy.nameRepresentable = copy.name.convert(with: caseStyle)
        return copy
    }

    /**
    Sets the alias of this field.

     - Parameter alias: The alias to use when constructing this field.
     - Returns: A `Field` with the alias in question.
     */
    func alias(_ alias: String) -> Field {
        var copy = self
        copy.alias = alias
        return copy
    }

    /**
    Sets an argument for this field.

     - Parameter key: The key for the argument.
     - Parameter value: The value for the argument conforming to `ArgumentValueRepresentable`.
     - Returns: A `Field` including the argument passed.
     */
    func argument(key: String, value: ArgumentValueRepresentable?) -> Field {
        var copy = self
        let argument = Argument(key: key, value: value)

        if copy.arguments != nil {
            copy.arguments!.append(argument)
        } else {
            copy.arguments = [argument]
        }

        return copy
    }

    /**
    Only include this field in the operation if the argument is true.

     - Parameter argument: A boolean argument.
     - Returns: A `Field` with its include value set.
     */
    func include(if argument: Bool) -> Field {
        var copy = self
        copy.include = argument
        return copy
    }

    /**
    Skip this field if the argument is true

     - Parameter argument: A boolean argument.
     - Returns: A `Field` with its skip value set.
     */
    func skip(if argument: Bool) -> Field {
        var copy = self
        copy.skip = argument
        return copy
    }
}

/**
`Field` conforms to `ObjectWeavable` in order to provide a description as well as a debug description of the field in question.

 Example `String(describing: field)`: `newPost: post(id: 1)`
 Example `String(reflecting: field)`: `newPost: post(id: 1)`
 */
extension Field: ObjectWeavable {
    public var description: String {
        buildDescription()
    }

    public var debugDescription: String {
        buildDescription()
    }
}

private extension Field {
    /**
    Formats a field with a name and alias.

     Example `newPost: post`
     */
    func formatField(_ name: String, alias: String) -> String {
        "\(alias): \(name)"
    }

    /**
    Formats a field with a name and arguments.

     Example `post(id: 1)`
     */
    func formatField(_ name: String, arguments: [Argument]) -> String {
        "\(name)(\(arguments.graphQLRepresentable))"
    }

    /**
    Formats a field with a name, alias, and arguments.

     Example `newPost: post(id: 1)`
     */
    func formatField(_ name: String, alias: String, arguments: [Argument]) -> String {
        "\(alias): \(name)(\(arguments.graphQLRepresentable))"
    }

    /// Determines which format is needed based on the parameters provided on initialization.
    func buildDescription() -> String {
        switch(alias, arguments) {
        case let(.some(alias), .some(arguments)):
            return FieldFormatter.formatField(nameRepresentable, alias: alias, arguments: arguments)
        case let(.some(alias), nil):
            return FieldFormatter.formatField(nameRepresentable, alias: alias)
        case let(nil, .some(arguments)):
            return FieldFormatter.formatField(nameRepresentable, arguments: arguments)
        default:
            return nameRepresentable
        }
    }
}
