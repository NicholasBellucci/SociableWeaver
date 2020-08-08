//
//  Slice.swift
//  SociableWeaver
//
//  Created by Nicholas Bellucci on 8/8/20.
//

import Foundation

struct Slice {
    var first: Int
    var offset: Int?
    var after: CodingKey?
}

/**
`Slice` conforms to `ObjectWeavable` in order to provide a description as well as a debug description of the object model in question.

 Example `String(describing: slice)`: `(first: 1, offset 2)`
 Example `String(reflecting: slice)`: `(first: 1, offset 2)`
 */
extension Slice: ObjectWeavable {
    public var description: String {
        buildDescription()
    }

    public var debugDescription: String {
        buildDescription()
    }
}

private extension Slice {
    /// Determines which format is needed based on the parameters provided on initialization.
    func buildDescription() -> String {
        switch(offset, after) {
        case let(.some(offset), nil):
            return "(first: \(first), offset: \(offset))"
        case let(nil, .some(after)):
            return "(first: \(first), after: \(after))"
        default:
            return "(first: \(first))"
        }
    }
}
