# SociableWeaver

Swift meets GraphQL in this lightweight, easy to use framework. SociableWeaver uses a declarative style of programming and makes GraphQL queries look natural in Swift code. Through the use of Swift 5.1 function builders and `CodingKeys`, SociableWeaver removes all of the need for unsafe strings and Dictionaries when creating objects and fields.

## Requirements
Xcode 11.x or a Swift 5.1x toolchain with Swift Package Manager.

## Installation

### Swift Package Manager
For projects using a `.xcodeproj` the best method is to navigate to `File > Swift Packages > Add Package Dependency...`. From there just simply enter `https://github.com/NicholasBellucci/SociableWeaver` as the package repository url and use the master branch or the most recent version. Master will always be inline with the newest release. The other method is to simply add `.package(url: "https://github.com/NicholasBellucci/SociableWeaver.git", from: "0.1.0")` to your `Package.swift` file's `dependencies`.

### Carthage

Add the following entry to your `Cartfile` and run `$ carthage update SociableWeaver`

```
github "NicholasBellucci/SociableWeaver"
```

## Table of Contents
   * [Objects and Fields](#objects-and-fields)
   * [Arguments](#arguments)
        * [Optionals](#optionals)
   * [Alias](#alias)
   * [Fragments](#fragments)
   * [Operation Name](#operation-name)
   * [Variables](#variables)
   * [Directives](#directives)
   * [Mutations](#mutations)
   * [Inline Fragments](#inline-fragments)
   * [Meta Fields](#meta-fields)
   * [Pagination](#pagination)
   * [Custom Types](#custom-types)
        * [CaseStyleOption](#casestyleoption)
        * [EnumValueRepresentable](#enumvaluerepresentable)

## Usage

SociableWeaver supports all that GraphQL has to offer. In order to get everything out of this framework, just make sure that any `Codable` models used contain `CodingKeys`. For example: 

```swift
public struct Post: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id, title, content
    }

    public let id: String
    public let title: String
    public let content: String

    public init(id: String, title: String, content: String) {
        self.id = id
        self.title = title
        self.content = content
    }
}
```

If `CodingKeys` aren't possible, SociableWeaver does support strings. It is highly recommended this be used as a last resort as it will make queries more difficult to manage.

### Objects and Fields
[GraphQL Fields](https://graphql.org/learn/queries/#fields)

GraphQL is all about querying specific fields on objects and returning only what is needed. With SociableWeaver constructing objects with fields is a breeze.

##### Swift
```swift
Weave(.query) {
    Object(Post.self) {
        Field(Post.CodingKeys.id)
        Field(Post.CodingKeys.title)
        Field(Post.CodingKeys.content)
    }
}
```

##### GraphQL Query
```graphql
query {
    post {
        id
        title
        content
    }
}
```

### Arguments

[GraphQL Arguments](https://graphql.org/learn/queries/#arguments)

Arguments are a key part of GraphQL and allow for much more refined queries. SociableWeaver supports arguments on both objects and fields.

The only requirement is that the value for the argument conforms to `ArgumentValueRepresentable`. Core types such as `String`, `Int`, `Bool` etc. will already conform. Enumerations will need to conform to the [EnumValueRepresentable](https://github.com/NicholasBellucci/SociableWeaver#enumvaluerepresentable) protocol.

##### Swift
```swift
Weave(.query) {
    Object(Post.self) {
        Field(Post.CodingKeys.title)

        Object(Post.CodingKeys.author) {
            Field(Author.CodingKeys.id)
            Field(Author.CodingKeys.name)
                .argument(key: "lastName", value: "Doe")
        }

        Object(Post.CodingKeys.comments) {
            Field(Comment.CodingKeys.id)
            Field(Comment.CodingKeys.content)
        }
        .argument(key: "filter", value: CommentFilter.recent)
    }
}
```

##### GraphQL Query
```graphql
query {
    post {
        title
        author {
            id
            name(lastName: "Doe")
        }
        comments(filter: RECENT) {
            id
            content
        }
    }
}
```

#### Optionals

Optionals are supported and can be included in the query. In the instance where an optional should be included and the value is nil, the resulting GraphQL value will be `null`.

In order to include an optional make sure to get the argument value of the property without including a `?`. This will result in a query param of `age: null`.
```swift
public struct Author: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id, name, age, birthplace
    }

    ...
    public let age: Int?
    ...
}

extension Author: ArgumentValueRepresentable {
    public var argumentValue: String {
        var params: [String: String?] = [:]

        ...
        params["age"] = age.argumentValue
        ...

        let paramStrings: [String] = params.compactMap { argument in
            guard let value = argument.value else {
                return nil
            }

            return "\(argument.key): \(value)"
        }

        return "{ \(paramStrings.joined(separator: ",")) }"
    }
}'
```

### Alias

[GraphQL Alias](https://graphql.org/learn/queries/#aliases)

Aliases are key when querying a single object multiple times in the same request.

##### Swift
```swift
Weave(.query) {
    Object(Post.self) {
        Object(Post.CodingKeys.comments) {
            Field(Comment.CodingKeys.id)
            Field(Comment.CodingKeys.content)
        }
        .argument(key: "filter", value: CommentFilter.recent)
        .alias("newComments")
        
        Object(Post.CodingKeys.comments) {
            Field(Comment.CodingKeys.id)
            Field(Comment.CodingKeys.content)
        }
        .argument(key: "filter", value: CommentFilter.old)
        .alias("oldComments")
    }
}
```

##### GraphQL Query

```graphql
query {
    post {
        newComments: comments(filter: RECENT) {
            id
            content
        }
        oldComments: comments(filter: OLD) {
            id
            content
        }
    }
}
```

### Fragments

[GraphQL Fragments](https://graphql.org/learn/queries/#fragments)

GraphQL fragments can help when building complicated queries. SociableWeaver makes them extremely simple and allows the proper references to be placed exactly where they would be in the query. With the help of a `FragmentBuilder` the `FragmentReference` can be added to the objects that require the fields and the `Fragment` can be added to the operation itself.

##### Swift
```swift
let authorFragment = FragmentBuilder(name: "authorFields", type: Author.self)
let query = Weave(.query) {
    Object(Post.self) {
        Object(Post.CodingKeys.author) {
            FragmentReference(for: authorFragment)
        }

        Object(Post.CodingKeys.comments) {
            Field(Comment.CodingKeys.content)
            
            Object(Comment.CodingKeys.author) {
                FragmentReference(for: authorFragment)
            }
        }
    }

    Fragment(authorFragment) {
        Field(Author.CodingKeys.id)
        Field(Author.CodingKeys.name)
    }
}
```

##### GraphQL Query
```graphql
query {
  post {
    author {
      ...authorFields
    }
    comments {
      content
      author {
        ...authorFields
      }
    }
  }
}

fragment authorFields on Author {
  id
  name
}
```

### Operation Name

[GraphQL Operation Name](https://graphql.org/learn/queries/#operation-name)

Operation names aren't required but can make the queries more unique.

```swift
Weave(.query) {
    Object(Post.self) {
        Field(Post.CodingKeys.id)
        Field(Post.CodingKeys.title)
        Field(Post.CodingKeys.content)
    }
}
.name("GetPostAndContent")
```

##### GraphQL Query
```graphql
query GetPost {
  post {
    id
    title
    content
  }
}
```

### Variables

[GraphQL Variables](https://graphql.org/learn/queries/#variables)

Since direct JSON is not needed when making queries in SociableWeaver, variables can and should be define in a method and passed into the query as arguments.

##### Swift
```swift
queryPost(id: 1)

func queryPost(id: Int) {
    Weave(.query) {
        Object(Post.self) {
            Field(Post.CodingKeys.title)
            Field(Post.CodingKeys.content)
            
            Object(Post.CodingKeys.author) {
                Field(Author.CodingKeys.id)
                Field(Author.CodingKeys.name)
            }
        }
        .argument(key: "id", value: id)
    }
}
```

##### GraphQL Query
```graphql
query {
  post(id: 1) {
    title
    content
    author {
      id
      name
    }
  }
}
```

### Directives

[GraphQL Directives](https://graphql.org/learn/queries/#directives)

Directives in GraphQL allows the server to affect execution of the query. The two directives are `@include` and `@skip` both of which can be added to fields or included fragments. The example defines true or false but in an actual query these values would be boolean variables.

Just to note, Skip will always take precedent over include. Also any objects/fragments that end up not having fields will be removed from the query.

```swift
let query = Weave(.query) {
    Object(Post.self) {
        Field(Post.CodingKeys.title)
        Field(Post.CodingKeys.content)
            .include(if: true)

        Object(Post.CodingKeys.author) {
            Field(Author.CodingKeys.name)
        }
        .include(if: false)

        Object(Post.CodingKeys.comments) {
            Field(Comment.CodingKeys.content)
                .include(if: true)
                .skip(if: true)
                
            Object(Comment.CodingKeys.author) {
                Field(Author.CodingKeys.name)
                    .skip(if: true)
            }
        }
    }
}
```

##### GraphQL Queries
```graphql
query { 
    post { 
        title 
        content 
    } 
}
```

### Mutations

[GraphQL Mutations](https://graphql.org/learn/queries/#mutations)

Mutations work the same as simple queries and should be used when data is supposed to be written. An `Object.schemaName` will replace the name of the Object or Key included in the initializer.

##### Swift
```swift
Weave(.mutation) {
    Object(Post.self) {
        Field(Post.CodingKeys.id)
        Field(Post.CodingKeys.title)
        Field(Post.CodingKeys.content)
    }
    .schemaName("createPost")
    .argument(key: "title", value: "TestPost")
    .argument(key: "content", value: "This is a test post.")
    .argument(key: "author", value: "John Doe")
}
```

##### GraphQL Mutation
```graphql
mutation {
  createPost(title: "TestPost", content: "This is a test post.", author: "John Doe") {
    id
    title
    content
  }
}
```

### Inline Fragments

[GraphQL Inline Fragments](https://graphql.org/learn/queries/#inline-fragments)

Inline fragments are useful when querying on an interface or union type as they allow the return of underlying types.

##### Swift
```swift
Weave(.query) {
    Object(Post.self) {
        Field(Post.CodingKeys.title)
        Field(Post.CodingKeys.content)

        Object(Post.CodingKeys.comments) {
            Field(Comment.CodingKeys.content)
        
            Object(Comment.CodingKeys.author) {
                InlineFragment("AnonymousUser") {
                    Field(Author.CodingKeys.id)
                }

                InlineFragment("RegisteredUser") {
                    Field(Author.CodingKeys.id)
                    Field(Author.CodingKeys.name)
                }
            }
        }
    }
}
```

##### GraphQL Query
```graphql
query {
  post {
    title
    content
    comments {
      content
      author {
        ... on AnonymousUser {
          id
        }
        ... on RegisteredUser {
          id
          name
        }
      }
    }
  }
}
```

### Meta Fields

[GraphQL Meta Fields](https://graphql.org/learn/queries/#meta-fields)

GraphQL meta fields can be customized and are recognized to have two proceeding underscores. The `__typename` meta field is a GraphQL default and can be used to return the object type in the results of a query.

Custom meta fields can be defined by using `MetaFieldType.custom`. This enum takes an associated String which does not need to include the double underscores before the name. For example: `.custom("schema")` results in `__schema`.

##### Swift
```swift
Weave(.query) {
    Object(Post.self){
        Field(Post.CodingKeys.title)
        Field(Post.CodingKeys.content)

        Object(Post.CodingKeys.author) {
            MetaField(.typename)
            Field(Author.CodingKeys.name)
        }
    }
}
```

##### GraphQL Query
```graphql
query {
  post {
    title
    content
    author {
      __typename
      name
    }
  }
}
```

### Pagination

[GraphQL Pagination](https://graphql.org/learn/pagination/)

SociableWeaver support pagination out of the box and can be easily customized. Features supported include slicing, edges, and page info inclusion.

#### Slicing

Slicing in GraphQL is great for fetching a specified amount of objects in a response. With SociableWeaver this can be specified with the `Object.slice` method.

##### Swift
```swift
Weave(.query) {
    Object(Post.CodingKeys.comments) {
        Field(Comment.CodingKeys.id)
        Field(Comment.CodingKeys.author)
        Field(Comment.CodingKeys.content)
    }
    .slice(amount: 2)
}
```

##### GraphQL Query
```graphql
{
  comments(first: 2) {
    id
    author
    content
  }
}
```

#### Cursor-Based Pagination

Cursor-based pagination is described as being the most powerful pagination type GraphQL provides. Setup this pagination by declaring the pagination type for an object.

##### Swift
```swift
Weave(.query) {
    Object(Post.CodingKeys.comments) {
        Field(Comment.CodingKeys.id)
        Field(Comment.CodingKeys.author)
        Field(Comment.CodingKeys.content)
    }
    .slice(amount: 2)
    .paginationType(.cursor)
}
```

##### GraphQL Query
```graphql
{
  comments(first: 2) {
    edges {
      cursor
      node {
        id
        author
        content
      }
    }
  }
}
```

#### Pagination Page Info

Including page info such as whether or not there is a next page or the end cursor is very flexible and supports a custom model.

##### Swift
```swift
Weave(.query) {
    Object(Post.CodingKeys.comments) {
        Field(Comment.CodingKeys.id)
        Field(Comment.CodingKeys.author)
        Field(Comment.CodingKeys.content)
    }
    .slice(amount: 2)
    .paginationType(.cursor)
    .pageInfo(type: PageInfo.self,
              keys: PageInfo.CodingKeys.startCursor,
                    PageInfo.CodingKeys.endCursor,
                    PageInfo.CodingKeys.hasNextPage)
}
```

##### GraphQL Query
```graphql
{
  comments(first: 2) {
    edges {
      cursor
      node {
        id
        author
        content
      }
    }
    pageInfo {
      startCursor
      endCursor
      hasNextPage
    }
  }
}
```

### Custom Types

SociableWeaver provides a couple of custom types that help to build more natural looking queries. These types may or may not have been included in examples but will also be defined in this section to provide more clarity.

#### CaseStyleOption

This enumeration has been provided to allow for customization when it comes to object and fields that are initialized with a model or coding key. Defaulted to camel case.

```swift
Field(Comment.CodingKeys.createdAt)
    .caseStyle(.lowercase)

public enum CaseStyleOption {
    case lowercase
    case uppercase
    case capitalized
    case camelCase
    case pascalCase
    case snakeCase
    case kebabCase
}
```

#### EnumValueRepresentable

GraphQL enumeration values are represented as uppercase representations of the case names. For this reason, custom enumerations in swift that should be passed as argument values can conform to `EnumValueRepresentable`. This protocol conforms to `ArgumentValueRepresentable` and is extended to provide the `argumentValue` as an uppercase version of the case value.

```swift
enum PostCategories: EnumValueRepresentable {
    case art
    case music
    case technology
}


Object(Post.self) {
    ...
}
.argument(key: "category", value: PostCategories.technology)

/// Result: post(category: TECHNOLOGY) { ... }
```

## License

SociableWeaver is, and always will be, MIT licensed. See [LICENSE](LICENSE) for details.
