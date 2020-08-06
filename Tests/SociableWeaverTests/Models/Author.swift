import SociableWeaver

public struct Author: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id, name, age, birthplace
    }

    public let id: String
    public let name: String
    public let age: Int?
    public let birthplace: [String: String]

    public init(id: String, name: String, age: Int?, birthplace: [String: String]) {
        self.id = id
        self.name = name
        self.age = age
        self.birthplace = birthplace
    }
}

extension Author: ArgumentValueRepresentable {
    public var argumentValue: String {
        var params: [String: String?] = [:]

        params["id"] = id.argumentValue
        params["name"] = name.argumentValue
        params["age"] = age?.argumentValue
        params["birthplace"] = birthplace.argumentValue

        let paramStrings: [String] = params.compactMap { argument in
            guard let value = argument.value else {
                return nil
            }

            return "\(argument.key): \(value)"
        }

        return "{ \(paramStrings.joined(separator: ",")) }"
    }
}
