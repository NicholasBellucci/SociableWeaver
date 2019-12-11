//
//  Field.swift
//  
//
//  Created by Nicholas Bellucci on 12/6/19.
//

/**
`Field` is a model with a name, possible alias, and possible arguments

 `Field.name`
 The raw name provided to the field.

 `Field.nameRepresentable`
 The name of the field converted to a case style.

 `Field.alias`
 An optional value that defines the alias name of the field.

 `Field.arguments`
 An optional value that consists of all some/all passable arguments for the field.
*/
public class Field {
    private var name: String
    private var nameRepresentable: String
    
    private var alias: String? = nil
    private var arguments: [Argument]? = nil

    public init(_ type: Any.Type) {
        self.name = String(describing: type)
        self.nameRepresentable = String(describing: type).convert(with: .lowercase)
    }

    public init(_ key: CodingKey) {
        self.name = key.stringValue
        self.nameRepresentable = key.stringValue.convert(with: .lowercase)
    }
}

public extension Field {
    /**
    Sets the case style of this field.

     - Parameter caseStyle: The case style to use when constructing this field.
     - Returns: A `Field` with the case style applied to the name.
     */
    func caseStyle(_ caseStyle: CaseStyleOption) -> Field {
        self.nameRepresentable = name.convert(with: caseStyle)
        return self
    }

    /**
    Sets the alias of this field.

     - Parameter alias: The alias to use when constructing this field.
     - Returns: A `Field` with the alias in question.
     */
    func alias(_ alias: String) -> Field {
        self.alias = alias
        return self
    }

    /**
    Sets an argument for this field.

     - Parameter argument: A key value pair to represent and argument name and value.
     - Returns: A `Field` including the argument passed.
     */
    func argument(key: String, value: ArgumentValueRepresentable) -> Field {
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
Field conforms to Weavable in order to provide a description as well as a debugDescription of the object model in question.

 Example `String(describing: field)`: `newPost: post(id: 1)`
 Example `String(reflecting: field)`: `newPost: post(id: 1)`
 */
extension Field: Weavable {
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
