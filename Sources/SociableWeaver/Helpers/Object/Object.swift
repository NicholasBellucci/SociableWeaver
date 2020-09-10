/**
 GraphQL objects are made up of one or more fields.

 `Object.name`
 The raw name provided to the object.

 `Object.fieldAggregates`
 The aggregated fields that make up the object.
*/

public struct Object: Directive {
    private var name: String
    private var nameRepresentable: String
    private let fieldAggregates: String
    
    private var alias: String? = nil
    private var arguments: [Argument]? = nil
    private var slice: Slice? = nil
    private var paginationType: PaginationType? = nil
    private var pageInfo: PageInfoModel? = nil

    var include: Bool = true
    var skip: Bool = false
    var remove: Bool = false

    private init(_ type: Any.Type, fieldAggregates: String) {
        self.name = String(describing: type)
        self.nameRepresentable = String(describing: type).convert(with: .camelCase)
        self.fieldAggregates = fieldAggregates
    }
    
    private init(_ key: String, fieldAggregates: String) {
        self.name = key
        self.nameRepresentable = key.convert(with: .camelCase)
        self.fieldAggregates = fieldAggregates
    }

    private init(_ key: CodingKey, fieldAggregates: String) {
        self.name = key.stringValue
        self.nameRepresentable = key.stringValue.convert(with: .camelCase)
        self.fieldAggregates = fieldAggregates
    }
    
    private init(fieldAggregates: String) {
        self.name = ""
        self.nameRepresentable = ""
        self.fieldAggregates = fieldAggregates
    }
}

public extension Object {
    /**
    Sets the alias of this object.

     - Parameter alias: The alias to use when constructing this object.
     - Returns: An `Object` with the alias in question.
     */
    func alias(_ alias: String) -> Object {
        var copy = self
        copy.alias = alias
        return copy
    }
    
    /**
    Sets an argument for this object.

     - Parameter key: The key for the argument.
     - Parameter value: The value for the argument conforming to `ArgumentValueRepresentable`.
     - Returns: An `Object` including the argument passed.
     */
    func argument(key: CodingKey, value: ArgumentValueRepresentable) -> Object {
        var copy = self
        let argument = Argument(key: key.stringValue, value: value)

        if copy.arguments != nil {
            copy.arguments!.append(argument)
        } else {
            copy.arguments = [argument]
        }

        return copy
    }

    /**
    Sets an argument for this object.

     - Parameter key: The key for the argument.
     - Parameter value: The value for the argument conforming to `ArgumentValueRepresentable`.
     - Parameter includeIfNil: Boolean to determine if argument should be included when value is nil. Defaults to false.
     - Returns: An `Object` including the argument passed.
     */
    func argument(key: String, value: ArgumentValueRepresentable, includeIfNil: Bool = false) -> Object {
        if value.argumentValue == "null", includeIfNil == false {
            return self
        }
        
        var copy = self
        let argument = Argument(key: key, value: value)

        if copy.arguments != nil {
            copy.arguments!.append(argument)
        } else {
            copy.arguments = [argument]
        }

        return copy
    }

    /**
    Sets the case style of this object.

     - Parameter caseStyle: The case style to use when constructing this object.
     - Returns: An `Object` with the case style applied to the name.
     */
    func caseStyle(_ caseStyle: CaseStyleOption) -> Object {
        var copy = self
        copy.nameRepresentable = copy.name.convert(with: caseStyle)
        return copy
    }
    
    /**
    Only include this object in the operation if the argument is true.

     - Parameter argument: A boolean argument.
     - Returns: An `Object` with its include value set.
     */
    func include(if argument: Bool) -> Object {
        var copy = self
        copy.include = argument
        return copy
    }
    
    /**
    The pagination type for the request. Mainly implemented to handle cursor-based pagination.

     - Parameter type: The pagination type.
     - Returns: An `Object` with its pagination type set.
     */
    func paginationType(_ type: PaginationType) -> Object {
        var copy = self
        copy.paginationType = type
        return copy
    }
    
    /**
    The model and keys for a page info object that might be used with cursor-based pagination.

     - Parameter type: The model type.
     - Parameter caseStyle: The case style for the model type name.
     - Parameter keys: The keys for the model.
     - Returns: An `Object` with its page info model set.
     */
    func pageInfo(type: Any.Type, caseStyle: CaseStyleOption = .camelCase, keys: CodingKey...) -> Object {
        var copy = self
        copy.pageInfo = PageInfoModel(type: String(describing: type).convert(with: caseStyle), keys: keys.map { $0.stringValue })
        return copy
    }
    
    /**
    The model and keys for a page info object that might be used with cursor-based pagination.

     - Parameter name: The name of the page info model.
     - Parameter keys: The keys for the model.
     - Returns: An `Object` with its page info model set.
     */
    func pageInfo(name: String, keys: String...) -> Object {
        var copy = self
        copy.pageInfo = PageInfoModel(type: name, keys: keys)
        return copy
    }
    
    /**
    Sets the field name to the name of the query schema name.

     - Parameter name: The queries schema name for the request.
     - Returns: An `Object` named after the schema.
     */
    func schemaName(_ name: String) -> Object {
        var copy = self
        copy.name = name
        copy.nameRepresentable = name
        return copy
    }

    /**
    Skip this object if the argument is true

     - Parameter argument: A boolean argument.
     - Returns: An `Object` with its skip value set.
     */
    func skip(if argument: Bool) -> Object {
        var copy = self
        copy.skip = argument
        return copy
    }
    
    /**
    Adds a slice to fetch a specified amount.

     - Parameter amount: Number of desired results
     - Returns: An `Object` with its slice value set.
     */
    func slice(amount: Int) -> Object {
        var copy = self
        copy.slice = Slice(first: amount)
        return copy
    }
    
    /**
    Adds a slice to fetch a specified amount of results at a provided offset.

     - Parameter amount: Number of desired results
     - Parameter offset: Desired offset for results lookup
     - Returns: An `Object` with its slice value set.
     */
    func slice(amount: Int, offset: Int) -> Object {
        var copy = self
        copy.slice = Slice(first: amount, offset: offset)
        return copy
    }
    
    /**
    Adds a slice to fetch a specified amount of results at a provided offset.

     - Parameter amount: Number of desired results
     - Parameter key: Key to determine which variable to check when determining offset
     - Returns: An `Object` with its slice value set.
     */
    func slice(amount: Int, after key: ArgumentValueRepresentable) -> Object {
        var copy = self
        copy.slice = Slice(first: amount, after: key)
        return copy
    }
}

public extension Object {
    /**
    Object initializer using the object function builder.
     This initializer accepts `Any.Type` which will be used as to determine the name.

    - parameter type: The type of `Any`.
    - parameter content: The object builder accepts structs/classes conforming to `ObjectWeavable`.
    */
    init(_ type: Any.Type, @ObjectBuilder _ content: () -> String) {
        self.init(type, fieldAggregates: content())
        self.remove = shouldRemove(content: content)
    }

    /**
    Workaround for function builders not accepting one element yet due to it still being a prototype.
     TODO - Remove when functionBuilders are fully implemented.

     Object initializer using the object function builder.
      This initializer accepts `Any.Type` which will be used as to determine the name.

     - parameter type: The type of `Any` used for the name.
     - parameter content: The individual object conforming to `ObjectWeavable`.
    */
    init(_ type: Any.Type, _ builderType: BuilderType = .individual, _ content: () -> ObjectWeavable) {
        self.init(type, fieldAggregates: String(describing: content()))
        self.skip = shouldRemove(content: content)
    }

    /**
    Object initializer using the object function builder.
     This initializer accepts a `CodingKey` which will be used as to determine the name.

    - parameter key: The coding key used for the name.
    - parameter content: The object builder accepts structs/classes conforming to `ObjectWeavable`.
    */
    init(_ key: CodingKey, @ObjectBuilder _ content: () -> String) {
        self.init(key, fieldAggregates: content())
        self.remove = shouldRemove(content: content)
    }

    /**
    Workaround for function builders not accepting one element yet due to it still being a prototype.
     TODO - Remove when functionBuilders are fully implemented.

     Object initializer using the object function builder.
      This initializer accepts a `CodingKey` which will be used as to determine the name.

     - parameter key: The coding key used for the name.
     - parameter content: The individual object conforming to `ObjectWeavable`.
    */
    init(_ key: CodingKey, _ builderType: BuilderType = .individual, _ content: () -> ObjectWeavable) {
        self.init(key, fieldAggregates: String(describing: content()))
        self.remove = shouldRemove(content: content)
    }
    
    /**
    Object initializer using the object function builder.
     This initializer accepts a `String` which will be used as to determine the name.

    - parameter key: The coding key used for the name.
    - parameter content: The object builder accepts structs/classes conforming to `ObjectWeavable`.
    */
    init(_ key: String, @ObjectBuilder _ content: () -> String) {
        self.init(key, fieldAggregates: content())
        self.remove = shouldRemove(content: content)
    }

    /**
    Workaround for function builders not accepting one element yet due to it still being a prototype.
     TODO - Remove when functionBuilders are fully implemented.

     Object initializer using the object function builder.
      This initializer accepts a `String` which will be used as to determine the name.

     - parameter key: The coding key used for the name.
     - parameter content: The individual object conforming to `ObjectWeavable`.
    */
    init(_ key: String, _ builderType: BuilderType = .individual, _ content: () -> ObjectWeavable) {
        self.init(key, fieldAggregates: String(describing: content()))
        self.remove = shouldRemove(content: content)
    }
    
    /**
    Object initializer using the object function builder.
     This initializer is for objects without a name.

    - parameter content: The object builder accepts structs/classes conforming to `ObjectWeavable`.
    */
    init(@ObjectBuilder _ content: () -> String) {
        self.init(fieldAggregates: content())
        self.remove = shouldRemove(content: content)
    }

    /**
    Workaround for function builders not accepting one element yet due to it still being a prototype.
     TODO - Remove when functionBuilders are fully implemented.

     Object initializer using the object function builder.
      This initializer is for objects without a name.

     - parameter content: The individual object conforming to `ObjectWeavable`.
    */
    init(_ builderType: BuilderType = .individual, _ content: () -> ObjectWeavable) {
        self.init(fieldAggregates: String(describing: content()))
        self.remove = shouldRemove(content: content)
    }
}

/**
`Object` conforms to `ObjectWeavable` in order to provide a description as well as a debug description of the object model in question.

 Example `String(describing: object)`: `post { id title content }`
 Example `String(reflecting: object)`: `post { id title content }`
 */
extension Object: ObjectWeavable {
    public var description: String {
        if slice != nil {
            return buildDescription().withSubfields(fieldAggregates, paginationType: paginationType, pageInfo: pageInfo)
        } else {
            return buildDescription().withSubfields(fieldAggregates)
        }
    }

    public var debugDescription: String {
        if slice != nil {
            return buildDescription().withSubfields(fieldAggregates, paginationType: paginationType, pageInfo: pageInfo)
        } else {
            return buildDescription().withSubfields(fieldAggregates)
        }
    }
}

extension Object: Removable {
    /// Objects containing no fields are removed.
    func shouldRemove(content: () -> CustomStringConvertible) -> Bool {
        if let value = content() as? Directive {
            if value.skip || !value.include {
                return true
            }
        }

        if let value = content() as? String {
            if value == "" {
                return true
            }
        }

        return false
    }
}

private extension Object {
    /// Determines which format is needed based on the parameters provided on initialization.
    func buildDescription() -> String {
        switch(alias, arguments) {
        case let(.some(alias), .some(arguments)):
            return FieldFormatter.formatField(nameRepresentable, alias: alias, arguments: arguments, slice: slice)
        case let(.some(alias), nil):
            return FieldFormatter.formatField(nameRepresentable, alias: alias, slice: slice)
        case let(nil, .some(arguments)):
            return FieldFormatter.formatField(nameRepresentable, arguments: arguments, slice: slice)
        default:
            return FieldFormatter.formatField(nameRepresentable, slice: slice)
        }
    }
}
