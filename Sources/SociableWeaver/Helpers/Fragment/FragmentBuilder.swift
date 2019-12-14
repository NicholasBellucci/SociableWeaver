//
//  FragmentBuilder.swift
//  
//
//  Created by Nicholas Bellucci on 12/7/19.
//

/**
 A `FragmentBuilder` is used by fragments and fragment references to help construct the needed field.

 `FragmentBuilder.name`
 The name given to a `Fragment`.

 `FragmentBuilder.type`
 The desired object type of the `Fragment`.
*/
public struct FragmentBuilder {
    let name: String
    let type: String

    public init(name: String, type: Any.Type) {
        self.name = name
        self.type = String(describing: type)
    }

    public init(name: String, type: String) {
        self.name = name
        self.type = type
    }
}

/**
`FragmentBuilder` conforms to `ObjectWeavable` in order to provide a description as well as a debug description of the builder in question.

 Example `String(describing: field)`: `fragment authorFields on Author`
 Example `String(reflecting: field)`: `fragment authorFields on Author`
 */
extension FragmentBuilder: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        "fragment \(name) on \(type)"
    }

    public var debugDescription: String {
        "fragment \(name) on \(type)"
    }
}
