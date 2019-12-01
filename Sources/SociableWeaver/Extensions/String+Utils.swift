//
//  File.swift
//  
//
//  Created by Nicholas Bellucci on 11/30/19.
//

extension String {
    func withSubfields(_ fields: String) -> String {
        "\(self) { \(fields) }"
    }
}
