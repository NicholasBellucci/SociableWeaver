/// The possible operation types that can be made.
public enum OperationType {
    case query
    case mutation
    case subscription
}

/// Used when a function builder only has one type.
/// This will be removed when function builders fully implemented in Swift.
public enum BuilderType {
    case individual
}
