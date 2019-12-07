//
//  Weavable.swift
//  
//
//  Created by Nicholas Bellucci on 12/6/19.
//

/**
 A type that conforms to both `CustomStringConvertible` and `CustomDebugStringConvertible`.

 Weavable is inherited by models that are used to construct a GraphQL query/mutation.
 */
public protocol Weavable: CustomStringConvertible, CustomDebugStringConvertible { }
