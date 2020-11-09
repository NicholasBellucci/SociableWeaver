public struct ForEachWeavable: Directive {
    private var objects: [ObjectWeavable] = []

    var include: Bool = true
    var skip: Bool = false

    init<T>(_ array: [T], content: @escaping (T) -> ObjectWeavable) {
        array.forEach {
            objects.append(content($0))
        }
    }
}

public extension ForEachWeavable {
    /**
    Only include this object in the operation if the argument is true.

     - Parameter argument: A boolean argument.
     - Returns: An `Object` with its include value set.
     */
    func include(if argument: Bool) -> ForEachWeavable {
        var copy = self
        copy.include = argument
        return copy
    }

    /**
    Skip this object if the argument is true

     - Parameter argument: A boolean argument.
     - Returns: An `Object` with its skip value set.
     */
    func skip(if argument: Bool) -> ForEachWeavable {
        var copy = self
        copy.skip = argument
        return copy
    }
}

extension ForEachWeavable: ObjectWeavable {
    public var description: String {
        objects.map { $0.description }.joined(separator: " ")
    }

    public var debugDescription: String {
        objects.map { $0.debugDescription }.joined(separator: " ")
    }
}
