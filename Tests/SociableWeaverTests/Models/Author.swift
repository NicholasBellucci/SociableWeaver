public struct Author: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id, name, birthplace
    }

    public let id: String
    public let name: String
    public let birthplace: [String: String]

    public init(id: String, name: String, birthplace: [String: String]) {
        self.id = id
        self.name = name
        self.birthplace = birthplace
    }
}
