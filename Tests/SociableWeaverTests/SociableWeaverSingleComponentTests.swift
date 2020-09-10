import XCTest
@testable import SociableWeaver

final class SociableWeaverSingleComponentTests: XCTestCase {
    func testWeaveSingleComponent() {
        let query = Weave(.query) {
            Object(Post.self) {
                Field(Post.CodingKeys.id)
                Field(Post.CodingKeys.content)
            }
        }

        let expected = "query { post { id content } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    func testObjectSingleComponent() {
        let query = Weave(.query) {
            Object(Post.self) {
                Field(Post.CodingKeys.id)
            }
        }

        let expected = "query { post { id } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    func testFragmentSingleComponent() {
        let authorFragment = FragmentBuilder(name: "authorFields", type: Author.self)
        let query = Weave(.query) {
            Object(Post.self) {
                Field(Post.CodingKeys.title)

                Object(Post.CodingKeys.author) {
                    FragmentReference(for: authorFragment)
                }
            }

            Fragment(authorFragment) {
                Field(Author.CodingKeys.id)
            }
        }

        let expected = "query { post { title author { ...authorFields } } } fragment authorFields on Author { id }"
        XCTAssertEqual(String(describing: query), expected)
    }

    func testInlineFragmentSingleComponent() {
        let query = Weave(.query) {
            Object(Post.self) {
                Field(Post.CodingKeys.title)

                Object(Post.CodingKeys.comments) {
                    Field(Comment.CodingKeys.id)
                    Field(Comment.CodingKeys.content)

                    Object(Comment.CodingKeys.author) {
                        InlineFragment("AnonymousUser") {
                            Field(Author.CodingKeys.id)
                        }
                    }
                }
            }
        }

        let expected = "query { post { title comments { id content author { ... on AnonymousUser { id } } } } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    static var allTests = [
        ("testWeaveSingleComponent", testWeaveSingleComponent),
        ("testObjectSingleComponent", testObjectSingleComponent),
        ("testFragmentSingleComponent", testFragmentSingleComponent),
        ("testInlineFragmentSingleComponent", testInlineFragmentSingleComponent),
    ]
}
