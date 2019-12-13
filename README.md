# SociableWeaver

Swift meets GraphQL in this lightweight, declarative, easy to use framework. SociableWeaver uses a SwiftUI style of programming and makes GraphQL queries look natural in Swift code. Through the use of Swift 5.1 function builders and `CodingKeys`, SociableWeaver removes all of the need for unsafe strings and Dictionaries when creating objects and fields.

## Requirements
Xcode 11.x or a Swift 5.1x toolchain with Swift Package Manager.

## Installation
SociableWeaver is a Swift Package and can be installed using a couple different methods. For projects using a `.xcodeproj` the best method is to navigate to `File > Swift Packages > Add Package Dependency...`. From there just simply enter `https://github.com/NicholasBellucci/SociableWeaver` as the package repository url and use the master branch or the most recent version. Master will always be inline with the newest release. The other method is to simply add `.package(url: "https://github.com/NicholasBellucci/SociableWeaver.git", from: "1.0.0")` to your `Package.swift` file's `dependencies`.

## Usage

SocialbleWeaver supports all that GraphQL has to offer. In order to get everything out of this framework, just make sure that any `Codable` models used contain `CodingKeys`. For example: 

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

If `CodingKeys` aren't possible, SocialbleWeaver does support strings but recommendeds this be used as a last resort as it will make queries more difficult to manage.

### Objects and Fields
[GraphQL Fields](https://graphql.org/learn/queries/#fields)

GraphQL is all about querying specific fields on objects and returning only what is needed. With SocialbleWeaver constructing objects with fields is a breeze.

#### Swift
```swift
Weave(.query) {
    Object(Post.self){
        Field(Post.CodingKeys.id)
        Field(Post.CodingKeys.title)
        Field(Post.CodingKeys.content)
    }
}
```

#### GraphQL Query
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

Arguments are a key part of GraphQL and allow for much more refined queries. SocialbleWeaver supports arguments on both objects and fields.

The only requirement is that the value for the argument conforms to `ArgumentValueRepresentable`. Core types such as `String`, `Int`, `Bool` etc. will already conform.

#### Swift
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

#### GraphQL Query
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

### Alias

[GraphQL Alias](https://graphql.org/learn/queries/#aliases)

Aliases are key when querying a single object multiple times in the same request.

#### Swift
```swift
Weave(.query) {
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

#### GraphQL Query
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

