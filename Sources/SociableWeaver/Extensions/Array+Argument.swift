extension Array where Element == Argument {
    /// The GraphQL representation of an arguments array.
    var graphQLRepresentable: String {
        var components: [String] = []

        forEach {
            if let key = $0.key {
                components.append("\(key): \($0.value.argumentValue)")
            } else {
                components.append("\($0.value.argumentValue)")
            }
        }

        return components.joined(separator: ", ")
    }
}
