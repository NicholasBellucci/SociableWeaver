//
//  Field.swift
//  
//
//  Created by Nicholas Bellucci on 12/6/19.
//

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

extension Field: Weavable {
    public var description: String {
        buildDescription()
    }

    public var debugDescription: String {
        buildDescription()
    }
}

private extension Field {
    func formatField(_ name: String, alias: String) -> String {
        return "\(alias): \(name)"
    }

    func formatField(_ name: String, arguments: [Argument]) -> String {
        return "\(name)(\(arguments.graphQLRepresentable))"
    }

    func formatField(_ name: String, alias: String, arguments: [Argument]) -> String {
        return "\(alias): \(name)(\(arguments.graphQLRepresentable))"
    }

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
