import XCTest
@testable import SociableWeaver

final class SociableWeaverGeneralTests: XCTestCase {
    func testOperationWithArguments() {
        let query = Weave(.query) {
            Object(Post.self) {
                Object(Post.CodingKeys.author) {
                    Field(Author.CodingKeys.id)
                    Field(Author.CodingKeys.name)
                        .argument(key: "value", value: "AuthorName")
                    Field(Author.CodingKeys.birthplace)
                        .argument(key: "value", value: [
                            "city": "New York",
                            "state": "New York",
                            "postalCode": "10001",
                            "neighborhood": "Chelsea"
                        ])
                }
                .alias("newAuthor")
                .argument(key: "id", value: 1)

                Object(Post.CodingKeys.comments) {
                    Field(Comment.CodingKeys.id)
                    Field(Comment.CodingKeys.content)
                    Field(Comment.CodingKeys.createdAt)
                }
                .alias("newComments")
            }
        }

        let expected = "query { post { newAuthor: author(id: 1) { id name(value: \"AuthorName\") birthplace(value: {city: \"New York\", neighborhood: \"Chelsea\", postalCode: \"10001\", state: \"New York\"}) } newComments: comments { id content createdAt } } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    func testOperationWithFragment() {
        let authorFragment = FragmentBuilder(name: "authorFields", type: Author.self)
        let query = Weave(.query) {
            Object(Post.self) {
                Field(Post.CodingKeys.title)
                Field(Post.CodingKeys.content)

                Object(Post.CodingKeys.author, .individual) {
                    FragmentReference(for: authorFragment)
                }

                Object(Post.CodingKeys.comments) {
                    Field(Comment.CodingKeys.id)
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

        let expected = "query { post { title content author { ...authorFields } comments { id author { ...authorFields } content } } } fragment authorFields on Author { id name }"
        XCTAssertEqual(String(describing: query), expected)
    }

    func testOperationWithInlineFragment() {
        let query = Weave(.query) {
            Object(Post.self) {
                Field(Post.CodingKeys.title)
                Field(Post.CodingKeys.content)

                Object(Post.CodingKeys.author) {
                    Field(Author.CodingKeys.id)
                    Field(Author.CodingKeys.name)
                }

                Object(Post.CodingKeys.comments) {
                    Field(Comment.CodingKeys.id)
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

        let expected = "query { post { title content author { id name } comments { id author { ... on AnonymousUser { id } ... on RegisteredUser { id name } } content } } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    func testOperationWithDirectives() {
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

        let expected = "query { post { title content } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    func testOperationWithMetaField() {
        let query = Weave(.query) {
            Object(Post.self) {
                Field(Post.CodingKeys.title)
                Field(Post.CodingKeys.content)

                Object(Post.CodingKeys.author) {
                    MetaField(.typename)
                    Field(Author.CodingKeys.name)
                }
            }
        }

        let expected = "query { post { title content author { __typename name } } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    func testOperationWithSchemaName() {
        let query = Weave(.query) {
            Object(Post.self) {
                Field(Post.CodingKeys.title)
                Field(Post.CodingKeys.content)

                Object(Post.CodingKeys.author) {
                    Field(Author.CodingKeys.id)
                    Field(Author.CodingKeys.name)
                }
            }
            .schemaName("getFirstPost")
        }

        let expected = "query { getFirstPost { title content author { id name } } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    func testOperationWithCustomEnum() {
        enum PostCategories: EnumValueRepresentable {
            case art
            case music
            case technology
        }

        let query = Weave(.query) {
            Object(Post.self) {
                Field(Post.CodingKeys.title)
                Field(Post.CodingKeys.content)

                Object(Post.CodingKeys.author) {
                    Field(Author.CodingKeys.id)
                    Field(Author.CodingKeys.name)
                }
            }
            .argument(key: "category", value: PostCategories.technology)
        }

        let expected = "query { post(category: TECHNOLOGY) { title content author { id name } } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    func testOperationWithCustomEnumArray() {
        enum PostCategories: EnumValueRepresentable {
            case art
            case music
            case technology
        }

        let query = Weave(.query) {
            Object(Post.self) {
                Field(Post.CodingKeys.title)
                Field(Post.CodingKeys.content)

                Object(Post.CodingKeys.author) {
                    Field(Author.CodingKeys.id)
                    Field(Author.CodingKeys.name)
                }
            }
            .argument(key: "category", value: [PostCategories.art, PostCategories.music, PostCategories.technology])
        }

        let expected = "query { post(category: [ART, MUSIC, TECHNOLOGY]) { title content author { id name } } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    static var allTests = [
        ("testOperationWithArguments", testOperationWithArguments),
        ("testOperationWithFragment", testOperationWithFragment),
        ("testOperationWithInlineFragment", testOperationWithInlineFragment),
        ("testOperationWithDirectives", testOperationWithDirectives),
        ("testOperationWithMetaField", testOperationWithMetaField),
        ("testOperationWithSchemaName", testOperationWithSchemaName),
        ("testOperationWithCustomEnum", testOperationWithCustomEnum)
    ]
}
