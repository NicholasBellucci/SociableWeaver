//
//  GQLFieldFormatter.swift
//  
//
//  Created by Nicholas Bellucci on 12/7/19.
//

public class GQLFieldFormatter {
    /**
    Formats a field with a name and alias.

     Example `newPost: post`
     */
    static func formatField(_ name: String, alias: String) -> String {
        return "\(alias): \(name)"
    }

    /**
    Formats a field with a name and arguments.

     Example `post(id: 1)`
     */
    static func formatField(_ name: String, arguments: [Argument]) -> String {
        return "\(name)(\(arguments.graphQLRepresentable))"
    }

    /**
    Formats a field with a name, alias, and arguments.

     Example `newPost: post(id: 1)`
     */
    static func formatField(_ name: String, alias: String, arguments: [Argument]) -> String {
        return "\(alias): \(name)(\(arguments.graphQLRepresentable))"
    }
}
