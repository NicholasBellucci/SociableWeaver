//
//  OperationBuilder.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

@_functionBuilder
internal struct OperationBuilder {
    static func buildBlock(_ children: Weavable...) -> String {
        var objects: [Object] = []
        var fragments: [Fragment] = []

        children.forEach {
            if let object = $0 as? Object {
                objects.append(object)
            } else if let fragment = $0 as? Fragment {
                fragments.append(fragment)
            }
        }

        let objectsRepresentation = objects.map { String(describing: $0) }.joined(separator: " ")
        let fragmentsRepresentation = fragments.map { String(describing: $0) }.joined(separator: " ")

        return "{ \(objectsRepresentation) } \(fragmentsRepresentation)"
    }

    static func buildBlock(_ component: Object) -> String {
        String(describing: component)
    }
}
