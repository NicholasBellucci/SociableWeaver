//
//  Field.swift
//  
//
//  Created by Nicholas Bellucci on 12/6/19.
//

/**
`Field` is a model consisting of a name, possible alias, and possible arguments

 `Field.name`
 The name of the object that will be returned.

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
    Sets the alias of this field.

     - Parameter alias: The alias to use when constructing this field.
     - Returns: A `Field` with the alias in question.
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
    Sets the alias of this field.

     - Parameter alias: The alias to use when constructing this field.
     - Returns: A `Field` with the alias in question.
     */
    func arguments(_ arguments: Argument...) -> Field {
        self.arguments = arguments
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
        return "\(alias): \(name)"
    }

    /**
    Formats a field with a name and arguments.

     Example `post(id: 1)`
     */
    func formatField(_ name: String, arguments: [Argument]) -> String {
        return "\(name)(\(arguments.graphQLRepresentable))"
    }

    /**
    Formats a field with a name, alias, and arguments.

     Example `newPost: post(id: 1)`
     */
    func formatField(_ name: String, alias: String, arguments: [Argument]) -> String {
        return "\(alias): \(name)(\(arguments.graphQLRepresentable))"
    }

    /// Determines which format is needed based on the parameters provided on initialization.
    func buildDescription() -> String {
        switch(alias, arguments) {
        case let(.some(alias), .some(arguments)):
            return formatField(nameRepresentable, alias: alias, arguments: arguments)
        case let(.some(alias), nil):
            return formatField(nameRepresentable, alias: alias)
        case let(nil, .some(arguments)):
            return formatField(nameRepresentable, arguments: arguments)
        default:
            return nameRepresentable
        }
    }
}
