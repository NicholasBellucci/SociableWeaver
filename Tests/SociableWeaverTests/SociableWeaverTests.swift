import XCTest
@testable import SociableWeaver

final class SociableWeaverTests: XCTestCase {
    func testBasicQuery() {
        let query = Request(.query) {
            Object(Post.self) {
                Post.CodingKeys.title
                Post.CodingKeys.content
                Object(Post.CodingKeys.author) {
                    Author.CodingKeys.id
                    Author.CodingKeys.name
                }
                Object(Post.CodingKeys.comments) {
                    Comment.CodingKeys.id
                    Object(Comment.CodingKeys.author) {
                        Author.CodingKeys.name
                    }
                    Comment.CodingKeys.content
                }
            }
        }

        XCTAssertEqual(String(describing: query), "query { post { title content author { id name } comments { id author { name } content } } }")
    }

    static var allTests = [
        ("testBasicQuery", testBasicQuery),
    ]
}
