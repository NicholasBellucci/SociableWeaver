//
//  RequestType.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

/// The possible request types that can be made.
public enum RequestType: String, RawRepresentable {
    case query
    case mutation
}
