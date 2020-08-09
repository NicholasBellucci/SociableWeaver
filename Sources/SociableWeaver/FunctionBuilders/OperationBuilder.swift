@_functionBuilder
public struct OperationBuilder {
    public static func buildBlock(_ children: Weavable...) -> String {
        var objects: [Object] = []
        var fragments: [Fragment] = []

        children.forEach {
            if let object = $0 as? Object {
                if object.remove { return }
                if object.skip || !object.include { return }
                
                objects.append(object)
            } else if let fragment = $0 as? Fragment {
                fragments.append(fragment)
            }
        }

        let objectsRepresentation = objects.map { String(describing: $0) }.joined(separator: " ")
        let fragmentsRepresentation = fragments.map { String(describing: $0) }.joined(separator: " ")

        return "{ \(objectsRepresentation) } \(fragmentsRepresentation)".trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public static func buildBlock(_ component: Object) -> String {
        String(describing: component)
    }
}
