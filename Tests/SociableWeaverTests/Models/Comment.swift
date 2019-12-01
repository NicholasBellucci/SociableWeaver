//
//  Comment.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

import Foundation

public struct Comment: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id, author, content
    }

    public let id: String
    public let author: Author
    public let content: String

    public init(id: String, author: Author, content: String) {
        self.id = id
        self.author = author
        self.content = content
    }
}
