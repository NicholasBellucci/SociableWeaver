/// The possible operation types that can be made.
public enum OperationType {
    case query
    case mutation
    case subscription
}

/// Used when a function builder only has one type.
/// This will be removed when function builders are a full swift feature.
public enum BuilderType {
    case individual
}
