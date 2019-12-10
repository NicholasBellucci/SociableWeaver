//
//  File.swift
//  
//
//  Created by Nicholas Bellucci on 12/10/19.
//

internal protocol Directive {
    var include: Bool { get set }
    var skip: Bool { get set }
}
