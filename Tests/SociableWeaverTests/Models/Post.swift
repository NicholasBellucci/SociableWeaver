public struct Post: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id, title, content, author, comments
    }

    public let id: String
    public let title: String
    public let content: String
    public let author: Author
    public let comments: [Comment]

    public init(id: String, title: String, content: String, author: Author, comments: [Comment]) {
        self.id = id
        self.title = title
        self.content = content
        self.author = author
        self.comments = comments
    }
}
