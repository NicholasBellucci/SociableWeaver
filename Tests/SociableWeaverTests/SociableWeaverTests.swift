import XCTest
@testable import SociableWeaver

final class SociableWeaverTests: XCTestCase {
    func testBasicQuery() {
        let query = Request(.query) {
            Object(Post.self){
                Field(Post.CodingKeys.title)
                Field(Post.CodingKeys.content)

                Object(Post.CodingKeys.author, .individual) {
                    Field(Author.CodingKeys.name)
                }

                Object(Post.CodingKeys.comments) {
                    Object(Comment.CodingKeys.author, .individual) {
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
            Object(Post.self) {
                Object(Post.CodingKeys.author) {
                    Field(Author.CodingKeys.id)
                    Field(Author.CodingKeys.name)
                        .argument(key: "value", value: "Nick")
                }.alias("newAuthor").argument(key: "id", value: 1)

                Object(Post.CodingKeys.comments) {
                    Field(Comment.CodingKeys.id)
                    Field(Comment.CodingKeys.content)
                }.alias("newComments")
            }
        }

        let expected = "query { post { newAuthor: author(id: 1) { id name(value: \"Nick\") } newComments: comments { id content } } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    func testQueryWithFragment() {
        let authorFragment = FragmentBuilder(name: "authorFields", type: Author.self)
        let query = Request(.query) {
            Object(Post.self) {
                Field(Post.CodingKeys.title)
                Field(Post.CodingKeys.content)

                Object(Post.CodingKeys.author, .individual) {
                    FragmentReference(builder: authorFragment)
                }

                Object(Post.CodingKeys.comments) {
                    Field(Comment.CodingKeys.id)
                    Object(Comment.CodingKeys.author, .individual) {
                        FragmentReference(builder: authorFragment)
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
