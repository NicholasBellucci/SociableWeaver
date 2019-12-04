//
//  File.swift
//  
//
//  Created by Nicholas Bellucci on 11/30/19.
//

internal extension String {
    func withSubfields(_ fields: String) -> String {
        "\(self) { \(fields) }"
    }

    /// Case styles for an String
    func camelCased() -> String {
        guard var words = self.capitalizedWords else { return "" }
        words[0] = words[0].lowercased()
        return words.joined(separator: "")
    }

    func pascalCased() -> String {
        guard let words = self.capitalizedWords else { return "" }
        return words.map { $0.capitalized }.joined(separator: "")
    }

    func snakeCased() -> String {
        guard let words = self.capitalizedWords else { return "" }
        return words.map { $0.lowercased() }.joined(separator: "_")
    }

    func kebabCased() -> String {
        guard let words = self.capitalizedWords else { return "" }
        return words.map { $0.lowercased() }.joined(separator: "-")
    }
}

fileprivate extension String {
    var isUppercase: Bool { return String(self).uppercased() == String(self) }

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
}
