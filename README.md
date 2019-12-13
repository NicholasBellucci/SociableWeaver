# SociableWeaver

Swift meets GraphQL in this lightweight, declarative, easy to use framework. SociableWeaver uses a SwiftUI style of programming and makes GraphQL queries look natural in Swift code. Through the use of Swift 5.1 function builders and `CodingKeys`, SociableWeaver removes all of the need for unsafe strings and Dictionaries when creating objects and fields.

## Requirements
Xcode 11.x or a Swift 5.1x toolchain with Swift Package Manager.

## Installation
SociableWeaver is a Swift Package and can be installed using a couple different methods. For projects using a `.xcodeproj` the best method is to navigate to `File > Swift Packages > Add Package Dependency...`. From there just simply enter `https://github.com/NicholasBellucci/SociableWeaver` as the package repository url and use the master branch or the most recent version. Master will always be inline with the newest release. The other method is to simply add `.package(url: "https://github.com/NicholasBellucci/SociableWeaver.git", from: "1.0.0")` to your `Package.swift` file's `dependencies`.

## Table of Contents
   * [Objects and Fields](#objects-and-fields)
   * [Arguments](#arguments)
   * [Alias](#alias)
   * [Fragments](#fragments)
   * [Operation Name](#operation-name)
   * [Variables](#variables)
   * [Directives](#directives)
   * [Mutations](#mutations)
   * [Inline Fragments](#inline-fragments)
   * [Meta Fields](#meta-fields)

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

Arguments are a key part of GraphQL and allow for much more refined queries. SocialbleWeaver supports arguments on both objects and fields.

The only requirement is that the value for the argument conforms to `ArgumentValueRepresentable`. Core types such as `String`, `Int`, `Bool` etc. will already conform.

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
        Object(Post.CodingKeys.author, .individual) {
            FragmentReference(for: authorFragment)
        }

        Object(Post.CodingKeys.comments) {
            Object(Comment.CodingKeys.author, .individual) {
                FragmentReference(for: authorFragment)
            }
            Field(Comment.CodingKeys.content)
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
      author {
        ...authorFields
      }
      content
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
guery {
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

        Object(Post.CodingKeys.author, .individual) {
            Field(Author.CodingKeys.name)
        }
        .include(if: false)

        Object(Post.CodingKeys.comments) {
            Object(Comment.CodingKeys.author, .individual) {
                Field(Author.CodingKeys.name)
                    .skip(if: true)
            }
            Field(Comment.CodingKeys.content)
                .include(if: true)
                .skip(if: true)
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
            Object(Comment.CodingKeys.author) {
                InlineFragment("AnonymousUser", .individual) {
                    Field(Author.CodingKeys.id)
                }

                InlineFragment("RegisteredUser") {
                    Field(Author.CodingKeys.id)
                    Field(Author.CodingKeys.name)
                }
            }
            Field(Comment.CodingKeys.content)
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
      author {
        ... on AnonymousUser {
          id
        }
        ... on RegisteredUser {
          id
          name
        }
      }
      content
    }
  }
}
```

### Meta Fields

[GraphQL Meta Fields](https://graphql.org/learn/queries/#meta-fields)

The `__typename` metafield can be used to return the object type in the results of a query.

##### Swift
```swift
Weave(.query) {
    Object(Post.self){
        Field(Post.CodingKeys.title)
        Field(Post.CodingKeys.content)

        Object(Post.CodingKeys.author) {
            Typename()
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