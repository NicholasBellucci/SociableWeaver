//
//  FragmentReference.swift
//  
//
//  Created by Nicholas Bellucci on 12/7/19.
//

public struct FragmentReference {
    public let builder: FragmentBuilder
}

extension FragmentReference: Weavable {
    public var description: String {
        "...\(builder.name)"
    }

    public var debugDescription: String {
        "...\(builder.name)"
    }
}
