/// Defines models that can be removed from an operation when empty.
protocol Removable {
    var remove: Bool { get set }
    func shouldRemove(content: () -> CustomStringConvertible) -> Bool
}
