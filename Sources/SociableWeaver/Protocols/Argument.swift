//
//  File.swift
//  
//
//  Created by Nicholas Bellucci on 12/6/19.
//

public protocol ArgumentValueRepresentable {
    var argumentValue: String { get }
}

public typealias Argument = (key: String, value: ArgumentValueRepresentable)

extension Bool: ArgumentValueRepresentable {
    public var argumentValue: String {
        return "\(self)"
    }
}

extension String: ArgumentValueRepresentable {
    public var argumentValue: String {
        return "\"\(self)\""
    }
}

extension Int: ArgumentValueRepresentable {
    public var argumentValue: String {
        return "\(self)"
    }
}

extension Double: ArgumentValueRepresentable {
    public var argumentValue: String {
        return "\(self)"
    }
}

extension Float: ArgumentValueRepresentable {
    public var argumentValue: String {
        return "\(self)"
    }
}

extension Array: ArgumentValueRepresentable {
    public var argumentValue: String  {
        let params = map { value -> String in
            if let value = value as? String {
                return value.argumentValue
            } else if let value = value as? Int {
                return value.argumentValue
            } else if let value = value as? Float {
                return value.argumentValue
            } else if let value = value as? Double {
                return value.argumentValue
            } else if let value = value as? Bool {
                return value.argumentValue
            } else if let value = value as? Array<Any> {
                return value.argumentValue
            } else if let value = value as? Dictionary<String, Any> {
                return value.argumentValue
            }

            return ""
        }

        return "[\(params.joined(separator: ", "))]"
    }
}

extension Dictionary: ArgumentValueRepresentable {
    public var argumentValue: String  {
        let params = map { (arg) -> String in
            let (key, value) = arg

            var argumentValue: String {
                if let value = value as? String {
                    return value.argumentValue
                } else if let value = value as? Int {
                    return value.argumentValue
                } else if let value = value as? Float {
                    return value.argumentValue
                } else if let value = value as? Double {
                    return value.argumentValue
                } else if let value = value as? Bool {
                    return value.argumentValue
                } else if let value = value as? Array<Any> {
                    return value.argumentValue
                } else if let value = value as? Dictionary<String, Any> {
                    return value.argumentValue
                }

                return ""
            }

            return "\(key): \(argumentValue)"
        }

        return "{\(params.joined(separator: ", "))}"
    }
}
