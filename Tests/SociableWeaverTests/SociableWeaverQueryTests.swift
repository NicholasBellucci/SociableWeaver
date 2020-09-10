import XCTest
@testable import SociableWeaver

final class SociableWeaverQueryTests: XCTestCase {
    func testBasicQueryOperation() {
        let query = Weave(.query) {
            Object(Post.self) {
                Field(Post.CodingKeys.title)
                Field(Post.CodingKeys.content)

                Object(Post.CodingKeys.author) {
                    Field(Author.CodingKeys.name)
                }

                Object(Post.CodingKeys.comments) {
                    Field(Comment.CodingKeys.content)

                    Object(Comment.CodingKeys.author) {
                        Field(Author.CodingKeys.name)
                    }
                }
            }
        }

        let expected = "query { post { title content author { name } comments { content author { name } } } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    func testQueryOperationWithName() {
        let query = Weave(.query) {
            Object(Post.self) {
                Field(Post.CodingKeys.title)
                Field(Post.CodingKeys.content)

                Object(Post.CodingKeys.author) {
                    Field(Author.CodingKeys.name)
                }

                Object(Post.CodingKeys.comments) {
                    Field(Comment.CodingKeys.content)

                    Object(Comment.CodingKeys.author) {
                        Field(Author.CodingKeys.name)
                    }
                }
            }
        }
        .name("GetPost")

        let expected = "query GetPost { post { title content author { name } comments { content author { name } } } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    static var allTests = [
        ("testBasicQueryOperation", testBasicQueryOperation),
        ("testQueryOperationWithName", testQueryOperationWithName),
    ]
}
