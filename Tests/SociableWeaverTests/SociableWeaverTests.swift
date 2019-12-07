import XCTest
@testable import SociableWeaver

final class SociableWeaverTests: XCTestCase {
    func testBasicQuery() {
        let query = Request(.query) {
            Object(Field(Post.self)) {
                Field(Post.CodingKeys.title)
                Field(Post.CodingKeys.content)

                Object(Field(Post.CodingKeys.author), .individual) {
                    Field(Author.CodingKeys.name)
                }

                Object(Field(Post.CodingKeys.comments)) {
                    Object(Field(Comment.CodingKeys.author), .individual) {
                        Field(Author.CodingKeys.name)
                    }
                    Field(Comment.CodingKeys.content)
                }
            }
        }

        let expected = "query { post { title content author { name } comments { author { name } content } } }"
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

    func testQueryWithFragment() {
        let authorFragment = FragmentBuilder(name: "authorFields", type: Author.self)
        let query = Request(.query) {
            Object(Field(Post.self)) {
                Field(Post.CodingKeys.title)
                Field(Post.CodingKeys.content)

                Object(Field(Post.CodingKeys.author)) {
                    FragmentReference(builder: authorFragment).description
                }

                Object(Field(Post.CodingKeys.comments)) {
                    Field(Comment.CodingKeys.id)
                    Object(Field(Comment.CodingKeys.author)) {
                        FragmentReference(builder: authorFragment).description
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

    static var allTests = [
        ("testBasicQuery", testBasicQuery),
        ("testQueryWithArguments", testQueryWithArguments),
        ("testQueryWithFragment", testQueryWithFragment),
    ]
}
