public struct PageInfo: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case startCursor, endCursor, hasNextPage
    }

    public let startCursor: String
    public let endCursor: String
    public let hasNextPage: Bool

    public init(startCursor: String, endCursor: String, hasNextPage: Bool) {
        self.startCursor = startCursor
        self.endCursor = endCursor
        self.hasNextPage = hasNextPage
    }
}
