import XCTest
@testable import SociableWeaver

final class SociableWeaverTests: XCTestCase {
    func testBasicQuery() {
        let query = Weave(.query) {
            return QueryBuilder.buildBlock(
                Object("post") {
                    Keys(Post.CodingKeys.allCases)
                    Exclude(Post.CodingKeys.id)

                    Merge(Post.CodingKeys.author) {
                        FieldsBuilder.buildBlock(Keys(Author.CodingKeys.allCases))
                    }

                    Merge(Post.CodingKeys.comments) {
                        Keys(Comment.CodingKeys.allCases)

                        Merge(Comment.CodingKeys.author) {
                            FieldsBuilder.buildBlock(Keys(Author.CodingKeys.allCases))
                        }
                    }
                }
            )
        }

        XCTAssertEqual(query.result, "query { post { title description author { id name } comments { id author { id name } content } } }")
    }

    static var allTests = [
        ("testBasicQuery", testBasicQuery),
    ]
}
