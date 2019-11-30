//
//  Author.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

public struct Author: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id, name
    }

    public let id: String
    public let name: String

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
