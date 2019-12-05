//
//  String+Utils.swift
//  
//
//  Created by Nicholas Bellucci on 11/30/19.
//

internal extension String {
    /**
    Wraps fields in curly braces to create a key object pair in a string

    - parameter fields: The fields to be wrapped.
    */
    func withSubfields(_ fields: String) -> String {
        "\(self) { \(fields) }"
    }

    /**
    Converts any String, or in this intented case, an Object Type string to a specific case style.
     This methods splits a string into a string array based on capital letters.

    - parameter option: The preferred case style.
    */
    func convert(with option: CaseStyleOption) -> String {
        switch option {
        case .lowercase:
            return self.lowercased()
        case .uppercase:
            return self.uppercased()
        case .camelCase:
            return self.camelCased()
        case .pascalCase:
            return self.pascalCased()
        case .snakeCase:
            return self.snakeCased()
        case .kebabCase:
            return self.kebabCased()
        }
    }
}

fileprivate extension String {
    /// Determines if a character is uppercase.
    var isUppercase: Bool { return String(self).uppercased() == String(self) }

    /// A string array of words that were capitalized in a string
    var capitalizedWords: [String]? {
        guard !self.isEmpty else { return nil }

        let indexes = Set(self
            .enumerated()
            .filter { $0.element.isUppercase }
            .map { $0.offset })

        let words = self
            .map { String($0) }
            .enumerated()
            .reduce([String]()) { words, next -> [String] in
                guard !words.isEmpty else { return [next.element] }
                guard !indexes.contains(next.offset) else { return words + [String(next.element)] }

                var words = words
                words[words.count-1] += String(next.element)
                return words
            }

        return words
    }

    /**
    Camel case string style.
     Ex. camelCase
    */
    func camelCased() -> String {
        guard var words = self.capitalizedWords else { return "" }
        words[0] = words[0].lowercased()
        return words.joined(separator: "")
    }

    /**
    Pascal case string style.
     Ex. PascalCase
    */
    func pascalCased() -> String {
        guard let words = self.capitalizedWords else { return "" }
        return words.map { $0.capitalized }.joined(separator: "")
    }

    /**
    Snake case string style.
     Ex. snake_case
    */
    func snakeCased() -> String {
        guard let words = self.capitalizedWords else { return "" }
        return words.map { $0.lowercased() }.joined(separator: "_")
    }

    /**
    Kebab case string style.
     Ex. kebab-case
    */
    func kebabCased() -> String {
        guard let words = self.capitalizedWords else { return "" }
        return words.map { $0.lowercased() }.joined(separator: "-")
    }
}
