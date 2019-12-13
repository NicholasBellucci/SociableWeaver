//
//  FieldFormatter.swift
//  
//
//  Created by Nicholas Bellucci on 12/7/19.
//

public class FieldFormatter {
    /**
    Formats a field with a name and alias.

     Example `newPost: post`
     */
    static func formatField(_ name: String, alias: String) -> String {
        "\(alias): \(name)"
    }

    /**
    Formats a field with a name and arguments.

     Example `post(id: 1)`
     */
    static func formatField(_ name: String, arguments: [Argument]) -> String {
        "\(name)(\(arguments.graphQLRepresentable))"
    }

    /**
    Formats a field with a name, alias, and arguments.

     Example `newPost: post(id: 1)`
     */
    static func formatField(_ name: String, alias: String, arguments: [Argument]) -> String {
        "\(alias): \(name)(\(arguments.graphQLRepresentable))"
    }
}
