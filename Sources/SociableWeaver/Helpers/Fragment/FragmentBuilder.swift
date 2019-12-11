//
//  FragmentBuilder.swift
//  
//
//  Created by Nicholas Bellucci on 12/7/19.
//

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

extension FragmentBuilder: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        "fragment \(name) on \(type)"
    }

    public var debugDescription: String {
        "fragment \(name) on \(type)"
    }
}
