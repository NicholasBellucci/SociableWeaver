import XCTest
@testable import SociableWeaver

final class SociableWeaverTests: XCTestCase {
    func testBasicQuery() {
        let query = Weave(.query) {
            QueryBuilder.buildBlock(
                Object(Post.self) {
                    Keys(Post.CodingKeys.allCases) {
                        Object(from: Post.CodingKeys.author) {
                            FieldsBuilder.buildBlock(Keys(Author.CodingKeys.allCases))
                        }
                        
                        Object(from: Post.CodingKeys.comments) {
                            Keys(Comment.CodingKeys.allCases) {
                                KeysBuilder.buildBlock(
                                    Object(from: Comment.CodingKeys.author) {
                                        Keys(Author.CodingKeys.allCases)
                                        Exclude(Author.CodingKeys.id)
                                    }
                                )
                            }

                            Exclude(Comment.CodingKeys.id)
                        }
                    }

                    Exclude(Post.CodingKeys.id, Post.CodingKeys.description)
                }
            )
        }

        XCTAssertEqual(query.result, "query { post { title author { id name } comments { author { name } content } } }")
    }

    static var allTests = [
        ("testBasicQuery", testBasicQuery),
    ]
}
