//
//  Post.swift
//  
//
//  Created by Nicholas Bellucci on 11/29/19.
//

public struct Post: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id, title, description, author, comments
    }

    public let id: String
    public let title: String
    public let description: String
    public let author: Author
    public let comments: [Comment]

    public init(id: String, title: String, description: String, author: Author, comments: [Comment]) {
        self.id = id
        self.title = title
        self.description = description
        self.author = author
        self.comments = comments
    }
}
