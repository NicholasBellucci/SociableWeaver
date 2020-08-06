public struct Comment: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id, author, content, createdAt
    }

    public let id: String
    public let author: Author
    public let content: String
    public let createdAt: String

    public init(id: String, author: Author, content: String, createdAt: String) {
        self.id = id
        self.author = author
        self.content = content
        self.createdAt = createdAt
    }
}
