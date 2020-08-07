import Foundation
/**
 `Argument` is a type alias that defines a key value tuple.

 This tuple provides a `String` and an `ArgumentValueRepresentable` which is
 used to construct an argument for a field.
 */
typealias Argument = (key: String, value: ArgumentValueRepresentable)

public protocol EnumValueRepresentable: ArgumentValueRepresentable { }

public extension EnumValueRepresentable {
    var argumentValue: String {
        "\(self)".uppercased()
    }
}

/// A type that can be used as to represent an argument.
public protocol ArgumentValueRepresentable {

    /// The argument representation of a given value.
    var argumentValue: String { get }
}

extension Bool: ArgumentValueRepresentable {
    public var argumentValue: String {
        "\(self)"
    }
}

extension String: ArgumentValueRepresentable {
    public var argumentValue: String {
        "\"\(self)\""
    }
}

extension Int: ArgumentValueRepresentable {
    public var argumentValue: String {
        "\(self)"
    }
}

extension Double: ArgumentValueRepresentable {
    public var argumentValue: String {
        "\(self)"
    }
}

extension Float: ArgumentValueRepresentable {
    public var argumentValue: String {
        "\(self)"
    }
}

extension Optional: ArgumentValueRepresentable {
    public var argumentValue: String {
        switch self {
        case .some(let wrapped):
            if let wrapped = wrapped as? ArgumentValueRepresentable {
                return wrapped.argumentValue
            } else {
                return "null"
            }
        default:
            return "null"
        }
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
                } else if let _ = value as? NSNull {
                    return "null"
                }

                return ""
            }

            return "\(key): \(argumentValue)"
        }

        return "{\(params.sorted().joined(separator: ", "))}"
    }
}
