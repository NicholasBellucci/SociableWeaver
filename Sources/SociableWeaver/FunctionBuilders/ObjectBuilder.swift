@_functionBuilder
public struct ObjectBuilder {
    public static func buildBlock(_ children: ObjectWeavable...) -> String {
        var descriptions: [String] = []

        children.forEach {
            guard let directive = $0 as? Directive else { return }
            if directive.skip || !directive.include { return }
            if let removable = directive as? Removable, removable.remove { return }
            
            descriptions.append(String(describing: $0))
        }

        return descriptions.joined(separator: " ")
    }

    public static func buildBlock(_ component: ObjectWeavable) -> String {
        String(describing: component)
    }
}
