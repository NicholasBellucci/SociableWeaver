/**
 A type that conforms to both `CustomStringConvertible` and `CustomDebugStringConvertible`.

 Weavable is inherited by models that are used to construct a GraphQL query/mutation.
 */
public protocol Weavable: CustomStringConvertible, CustomDebugStringConvertible { }

public protocol ObjectWeavable: Weavable { }
