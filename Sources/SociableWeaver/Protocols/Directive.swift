/**
A directive can be attached to a field or fragment reference.

Directives will not appear in the GraphQL query generated but will be handled properly in swift.
*/
protocol Directive {
    var include: Bool { get set }
    var skip: Bool { get set }
}
