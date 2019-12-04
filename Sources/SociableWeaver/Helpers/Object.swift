//
//  Object.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

public struct Object {
    let name: String
    let result: String

    private init(_ name: String, result: String) {
        self.name = name
        self.result = result
    }
}

extension Object {
    init(_ name: String, @FieldsBuilder _ content: () -> String) {
        self.init(name, result: content())
    }

    init(_ type: Any.Type, caseStyleOption: CaseStyleOption = .lowercase, @FieldsBuilder _ content: () -> String) {
        self.init(String(describing: type.self).lowercased(), result: content())
    }
}

private extension Object {
    func convertType(_ type: Any.Type, with option: CaseStyleOption) {
        var string = String(describing: type.self)

        switch option {
        case .lowercase:
            string = string.lowercased()
        case .uppercase:
            string = string.uppercased()
        case .camelCase:
            string = string.camelCased()
        case .pascalCase:
            string = string.pascalCased()
        case .snakeCase:
            string = string.snakeCased()
        case .kebabCase:
            string = string.kebabCased()
        }
    }
}
