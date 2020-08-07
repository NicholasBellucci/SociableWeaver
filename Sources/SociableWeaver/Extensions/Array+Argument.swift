extension Array where Element == Argument {
    /// The GraphQL representation of an arguments array.
    var graphQLRepresentable: String {
        var components: [String] = []

        forEach {
            components.append("\($0.key): \($0.value.argumentValue)")
        }

        return components.joined(separator: ", ")
    }
}
