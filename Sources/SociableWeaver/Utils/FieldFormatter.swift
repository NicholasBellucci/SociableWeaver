public class FieldFormatter {
    /**
    Formats a field with a name

     Example `post`
     */
    static func formatField(_ name: String, slice: Slice? = nil) -> String {
        if let slice = slice {
            return "\(name)\(slice.description)"
        } else {
            return "\(name)"
        }
    }
    
    /**
    Formats a field with a name and alias.

     Example `newPost: post`
     */
    static func formatField(_ name: String, alias: String, slice: Slice? = nil) -> String {
        if let slice = slice {
            return "\(alias): \(name)\(slice.description)"
        } else {
            return "\(alias): \(name)"
        }
    }

    /**
    Formats a field with a name and arguments.

     Example `post(id: 1)`
     */
    static func formatField(_ name: String, arguments: [Argument], slice: Slice? = nil) -> String {
        if let slice = slice {
            return "\(name)\(slice.description)"
        } else {
            return "\(name)(\(arguments.graphQLRepresentable))"
        }
    }

    /**
    Formats a field with a name, alias, and arguments.

     Example `newPost: post(id: 1)`
     */
    static func formatField(_ name: String, alias: String, arguments: [Argument], slice: Slice? = nil) -> String {
        if let slice = slice {
            return "\(alias): \(name)\(slice.description)"
        } else {
            return "\(alias): \(name)(\(arguments.graphQLRepresentable))"
        }
    }
}
