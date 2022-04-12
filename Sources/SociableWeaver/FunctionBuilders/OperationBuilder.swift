@resultBuilder
public struct OperationBuilder {
    public static func buildBlock(_ children: Weavable...) -> String {
        var weavables: [Weavable] = []
        var fragments: [Fragment] = []

        children.forEach {
            if let object = $0 as? Object {
                if object.remove { return }
                if object.skip || !object.include { return }
                
                weavables.append(object)
            } else if let field = $0 as? Field {
                if field.skip || !field.include { return }

                weavables.append(field)
            } else if let fragment = $0 as? Fragment {
                fragments.append(fragment)
            } else if let forEach = $0 as? ForEachWeavable {
                if forEach.skip || !forEach.include { return }

                weavables.append(forEach)
            }
        }

        let weavablesRepresentation = weavables.map { String(describing: $0) }.joined(separator: " ")
        let fragmentsRepresentation = fragments.map { String(describing: $0) }.joined(separator: " ")

        return "{ \(weavablesRepresentation) } \(fragmentsRepresentation)".trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public static func buildBlock(_ component: Object) -> String {
        "{ \(String(describing: component)) }"
    }
}
