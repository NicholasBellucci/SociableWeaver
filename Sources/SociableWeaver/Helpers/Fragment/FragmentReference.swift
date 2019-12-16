/**
 A `FragmentReference` is a reference  by name to a fragment in the operation.

 `Fragment.builder`
 The `FragmentBuilder` which will be used to construct the fragment reference's field.
*/
public struct FragmentReference: Directive {
    let builder: FragmentBuilder

    var include: Bool = true
    var skip: Bool = false

    public init(for builder: FragmentBuilder) {
        self.builder = builder
    }
}

public extension FragmentReference {
    /**
    Only include this fragment reference in the operation if the argument is true.

     - Parameter argument: A boolean argument.
     - Returns: A `FragmentReference` with its include value set.
     */
    func include(if argument: Bool) -> FragmentReference {
        var copy = self
        copy.include = argument
        return copy
    }

    /**
    Skip this fragment reference if the argument is true

     - Parameter argument: A boolean argument.
     - Returns: A `FragmentReference` with its skip value set.
     */
    func skip(if argument: Bool) -> FragmentReference {
        var copy = self
        copy.skip = argument
        return copy
    }
}

/**
`FragmentReference` conforms to `ObjectWeavable` in order to provide a description as well as a debug description of the reference in question.

 Example `String(describing: field)`: `...authorFields`
 Example `String(reflecting: field)`: `...authorFields`
 */
extension FragmentReference: ObjectWeavable {
    public var description: String {
        "...\(builder.name)"
    }

    public var debugDescription: String {
        "...\(builder.name)"
    }
}
