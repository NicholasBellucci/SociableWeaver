import XCTest
@testable import SociableWeaver

final class SociableWeaverQueryTests: XCTestCase {
    func testBasicQueryOperation() {
        let query = Weave(.query) {
            Object(Post.self) {
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

    func testQueryOperationWithName() {
        let query = Weave(.query) {
            Object(Post.self) {
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
        .name("GetPost")

        let expected = "query GetPost { post { title content author { name } comments { author { name } content } } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    static var allTests = [
        ("testBasicQueryOperation", testBasicQueryOperation),
        ("testQueryOperationWithName", testQueryOperationWithName),
    ]
}
