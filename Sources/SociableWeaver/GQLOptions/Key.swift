//
//  Key.swift
//  
//
//  Created by Nicholas Bellucci on 12/4/19.
//

public struct Key<T: CodingKey> {
    let value: T

    init(_ value: T) {
        self.value = value
    }
}
