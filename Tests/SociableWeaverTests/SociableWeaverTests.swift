import XCTest
@testable import SociableWeaver

final class SociableWeaverTests: XCTestCase {
    func testBasicQuery() {
        let query = Weave(.query) {
            QueryBuilder.buildBlock(
                Object("post") {
                    Keys(Post.CodingKeys.allCases)
                    Exclude(Post.CodingKeys.id, Post.CodingKeys.description)

                    Merge(Post.CodingKeys.author) {
                        FieldsBuilder.buildBlock(Keys(Author.CodingKeys.allCases))
                    }

                    Merge(Post.CodingKeys.comments) {
                        Keys(Comment.CodingKeys.allCases)

                        Merge(Comment.CodingKeys.author) {
                            Keys(Author.CodingKeys.allCases)
                            Exclude(Author.CodingKeys.id)
                        }
                    }
                }
            )
        }

        XCTAssertEqual(query.result, "query { post { title author { id name } comments { id author { name } content } } }")
    }

    static var allTests = [
        ("testBasicQuery", testBasicQuery),
    ]
}
