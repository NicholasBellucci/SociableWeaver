//
//  Removable.swift
//  
//
//  Created by Nicholas Bellucci on 12/11/19.
//

/// Defines models that can be removed from an operation when empty.
protocol Removable {
    var remove: Bool { get set }
    func shouldRemove(content: () -> CustomStringConvertible) -> Bool
}
