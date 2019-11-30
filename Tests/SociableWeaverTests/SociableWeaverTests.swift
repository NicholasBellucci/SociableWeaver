import XCTest
@testable import SociableWeaver

final class SociableWeaverTests: XCTestCase {
    func testBasicQuery() {
        let weave = Weave(.query) {
            Fields("post") {
                Keys(Post.CodingKeys.allCases)
                Exclude(Post.CodingKeys.id)

                Merge(Post.CodingKeys.author) {
                    return MergeBuilder.buildBlock(
                        Keys(Author.CodingKeys.allCases)
                    )
                }

                Merge(Post.CodingKeys.comments) {
                    Keys(Comment.CodingKeys.allCases)

                    Merge(Comment.CodingKeys.author) {
                        return MergeBuilder.buildBlock(
                            Keys(Author.CodingKeys.allCases)
                        )
                    }
                }
            }.result
        }

        print(weave.result)

        XCTAssertEqual(weave.result, "{ post { title description author { id name } comments { id author content } } }")
    }

    static var allTests = [
        ("testBasicQuery", testBasicQuery),
    ]
}

//Merge(Post.CodingKeys.comments) {
//    Keys(Comment.CodingKeys.allCases)
//
//    Merge(Comment.CodingKeys.author) {
//        Keys(Author.CodingKeys.allCases)
//    }
//}
