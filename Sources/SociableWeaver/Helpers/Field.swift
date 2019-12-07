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
public struct Field {
    public let name: String
    public var alias: String? = nil
    public var arguments: [Argument]? = nil

    public init(_ type: Any.Type, caseStyleOption: CaseStyleOption = .lowercase, alias: String? = nil, arguments: [Argument]? = nil) {
        self.name = String(describing: type).convert(with: caseStyleOption)
        self.alias = alias
        self.arguments = arguments
    }

    public init(_ key: CodingKey, alias: String? = nil, arguments: [Argument]? = nil) {
        self.name = key.stringValue
        self.alias = alias
        self.arguments = arguments
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
            return formatField(name, alias: alias, arguments: arguments)
        case let(.some(alias), nil):
            return formatField(name, alias: alias)
        case let(nil, .some(arguments)):
            return formatField(name, arguments: arguments)
        default:
            return name
        }
    }
}
