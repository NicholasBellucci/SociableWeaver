import XCTest
@testable import SociableWeaver

final class SociableWeaverMutationTests: XCTestCase {
    func testBasicMutationOperation() {
        let query = Weave(.mutation) {
            Object(Post.self) {
                Field(Post.CodingKeys.title)
                Field(Post.CodingKeys.content)

                Object(Post.CodingKeys.author) {
                    Field(Author.CodingKeys.name)
                }
            }
            .schemaName("updatePost")
            .argument(key: "id", value: 1)
            .argument(key: "title", value: "Updated Title")
        }

        let expected = "mutation { updatePost(id: 1, title: \"Updated Title\") { title content author { name } } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    func testMutationOperationWithName() {
        let query = Weave(.mutation) {
            Object(Post.self) {
                Field(Post.CodingKeys.title)
                Field(Post.CodingKeys.content)

                Object(Post.CodingKeys.author) {
                    Field(Author.CodingKeys.name)
                }
            }
            .schemaName("updatePost")
            .argument(key: "id", value: 1)
            .argument(key: "title", value: "Updated Title")
        }
        .name("UpdatePost")

        let expected = "mutation UpdatePost { updatePost(id: 1, title: \"Updated Title\") { title content author { name } } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    static var allTests = [
        ("testBasicMutationOperation", testBasicMutationOperation),
        ("testMutationOperationWithName", testMutationOperationWithName),
    ]
}

