import XCTest
@testable import SociableWeaver

final class SociableWeaverTests: XCTestCase {
    func testBasicQuery() {
        let query = Request(.query) {
            Object(Field(Post.self)) {
                Field(Post.CodingKeys.title)
                Field(Post.CodingKeys.content)

                Object(Field(Post.CodingKeys.author)) {
                    Field(Author.CodingKeys.id)
                    Field(Author.CodingKeys.name)
                }

                Object(Field(Post.CodingKeys.comments)) {
                    Field(Comment.CodingKeys.id)
                    Object(Field(Comment.CodingKeys.author)) {
                        Field(Author.CodingKeys.id)
                        Field(Author.CodingKeys.name)
                    }
                    Field(Comment.CodingKeys.content)
                }
            }
        }

        let expected = "query { post { title content author { id name } comments { id author { id name } content } } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    func testQueryWithArguments() {
        let query = Request(.query) {
            Object(Field(Post.self)) {
                Object(Field(Post.CodingKeys.author, alias: "newAuthor", arguments: [Argument(key: "id", value: 1)])) {
                    Field(Author.CodingKeys.id)
                    Field(Author.CodingKeys.name, arguments: [Argument(key: "value", value: "Nick")])
                }

                Object(Field(Post.CodingKeys.comments, alias: "newComments")) {
                    Field(Comment.CodingKeys.id)
                    Field(Comment.CodingKeys.content)
                }
            }
        }

        let expected = "query { post { newAuthor: author(id: 1) { id name(value: \"Nick\") } newComments: comments { id content } } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    static var allTests = [
        ("testBasicQuery", testBasicQuery),
        ("testQueryWithArguments", testQueryWithArguments),
    ]
}
