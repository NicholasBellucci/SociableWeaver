import XCTest
@testable import SociableWeaver

final class SociableWeaverTests: XCTestCase {
    func testBasicQuery() {
        let query = Weave(.query) {
            QueryBuilder.buildBlock(
                Object(Post.self) {
                    Post.CodingKeys.title
                    Post.CodingKeys.description
                    Object(Post.CodingKeys.author) {
                        Author.CodingKeys.id
                        Author.CodingKeys.name
                    }
                    Object(Post.CodingKeys.comments) {
                        Comment.CodingKeys.id
                        Object(Comment.CodingKeys.author) {
                            ObjectBuilder.buildBlock(Author.CodingKeys.name)
                        }
                        Comment.CodingKeys.content
                    }
                }
            )
        }

        XCTAssertEqual(query.result, "query { post { title description author { id name } comments { id author { name } content } } }")
    }

    static var allTests = [
        ("testBasicQuery", testBasicQuery),
    ]
}
