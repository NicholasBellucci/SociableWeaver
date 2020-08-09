import XCTest
@testable import SociableWeaver

final class SociableWeaverBuilderTests: XCTestCase {
    func testBuildField() {
        let query = Weave(.query) {
            Field(Comment.CodingKeys.id)
        }

        let expected = "query { id }"
        XCTAssertEqual(String(describing: query), expected)
    }
    
    func testBuildObject() {
        let query = Weave(.query) {
            Object(Post.self) {
                Field(Author.CodingKeys.id)
                Field(Author.CodingKeys.name)
            }
        }

        let expected = "query { post { id name } }"
        XCTAssertEqual(String(describing: query), expected)
    }
    
    func testBuildObjectWithAlias() {
        let query = Weave(.query) {
            Object(Post.self) {
                Field(Author.CodingKeys.id)
                Field(Author.CodingKeys.name)
            }
            .alias("testAlias")
        }

        let expected = "query { testAlias: post { id name } }"
        XCTAssertEqual(String(describing: query), expected)
    }
    
    func testBuildObjectWithSchemaName() {
        let query = Weave(.query) {
            Object(Post.self) {
                Field(Author.CodingKeys.id)
                Field(Author.CodingKeys.name)
            }
            .schemaName("testSchema")
        }

        let expected = "query { testSchema { id name } }"
        XCTAssertEqual(String(describing: query), expected)
    }
    
    func testBuildObjectWithArgument() {
        let query = Weave(.query) {
            Object(Post.self) {
                Field(Author.CodingKeys.id)
                Field(Author.CodingKeys.name)
            }
            .argument(key: "testArgument", value: "test")
        }

        let expected = "query { post(testArgument: \"test\") { id name } }"
        XCTAssertEqual(String(describing: query), expected)
    }
    
    func testBuildObjectWithCaseStyle() {
        let query = Weave(.query) {
            Object(Post.self) {
                Field(Author.CodingKeys.id)
                Field(Author.CodingKeys.name)
            }
            .caseStyle(.capitalized)
        }

        let expected = "query { Post { id name } }"
        XCTAssertEqual(String(describing: query), expected)
    }
    
    func testBuildObjectWithFalseInclude() {
        let query = Weave(.query) {
            Object(Post.self) {
                Field(Author.CodingKeys.id)
                Field(Author.CodingKeys.name)
            }
            
            Object(Author.self) {
                Field(Author.CodingKeys.id)
                Field(Author.CodingKeys.name)
            }
            .include(if: false)
        }

        let expected = "query { post { id name } }"
        XCTAssertEqual(String(describing: query), expected)
    }
    
    func testBuildObjectWithTrueSkip() {
        let query = Weave(.query) {
            Object(Post.self) {
                Field(Author.CodingKeys.id)
                Field(Author.CodingKeys.name)
            }
            
            Object(Author.self) {
                Field(Author.CodingKeys.id)
                Field(Author.CodingKeys.name)
            }
            .skip(if: true)
        }

        let expected = "query { post { id name } }"
        XCTAssertEqual(String(describing: query), expected)
    }
    
    func testBuildObjectWithSlice() {
        let query = Weave(.query) {
            Object(Post.CodingKeys.comments) {
                Field(Comment.CodingKeys.id)
                Field(Comment.CodingKeys.author)
                Field(Comment.CodingKeys.content)
            }
            .slice(amount: 2)
        }

        let expected = "query { comments(first: 2) { id author content } }"
        XCTAssertEqual(String(describing: query), expected)
    }
    
    func testBuildObjectWithSliceAndOffset() {
        let query = Weave(.query) {
            Object(Post.CodingKeys.comments) {
                Field(Comment.CodingKeys.id)
                Field(Comment.CodingKeys.author)
                Field(Comment.CodingKeys.content)
            }
            .slice(amount: 2, offset: 2)
        }

        let expected = "query { comments(first: 2, offset: 2) { id author content } }"
        XCTAssertEqual(String(describing: query), expected)
    }
    
    func testBuildObjectWithSliceAfterKey() {
        let query = Weave(.query) {
            Object(Post.CodingKeys.comments) {
                Field(Comment.CodingKeys.id)
                Field(Comment.CodingKeys.author)
                Field(Comment.CodingKeys.content)
            }
            .slice(amount: 2, after: "123")
        }

        let expected = "query { comments(first: 2, after: \"123\") { id author content } }"
        XCTAssertEqual(String(describing: query), expected)
    }
    
    func testBuildObjectWithSliceWithEdges() {
        let query = Weave(.query) {
            Object(Post.CodingKeys.comments) {
                Field(Comment.CodingKeys.id)
                Field(Comment.CodingKeys.author)
                Field(Comment.CodingKeys.content)
            }
            .slice(amount: 2)
            .paginationType(.cursor)
        }

        let expected = "query { comments(first: 2) { cursor edges { node { id author content } } } }"
        XCTAssertEqual(String(describing: query), expected)
    }
    
    func testBuildObjectWithNoSliceAndEdges() {
        let query = Weave(.query) {
            Object(Post.CodingKeys.comments) {
                Field(Comment.CodingKeys.id)
                Field(Comment.CodingKeys.author)
                Field(Comment.CodingKeys.content)
            }
            .paginationType(.cursor)
        }

        let expected = "query { comments { id author content } }"
        XCTAssertEqual(String(describing: query), expected)
    }
    
    func testBuildObjectWithEdgesAndPageInfo() {
        let query = Weave(.query) {
            Object(Post.CodingKeys.comments) {
                Field(Comment.CodingKeys.id)
                Field(Comment.CodingKeys.author)
                Field(Comment.CodingKeys.content)
            }
            .slice(amount: 2)
            .paginationType(.cursor)
            .pageInfo(type: PageInfo.self,
                      keys: PageInfo.CodingKeys.startCursor,
                            PageInfo.CodingKeys.endCursor,
                            PageInfo.CodingKeys.hasNextPage)
        }

        let expected = "query { comments(first: 2) { cursor edges { node { id author content } } pageInfo { startCursor endCursor hasNextPage } } }"
        XCTAssertEqual(String(describing: query), expected)
    }
    
    func testBuildObjectWithEdgesAndPageInfoStrings() {
        let query = Weave(.query) {
            Object(Post.CodingKeys.comments) {
                Field(Comment.CodingKeys.id)
                Field(Comment.CodingKeys.author)
                Field(Comment.CodingKeys.content)
            }
            .slice(amount: 2)
            .paginationType(.cursor)
            .pageInfo(name: "pageInfo",
                      keys: "startCursor",
                            "endCursor",
                            "hasNextPage")
        }

        let expected = "query { comments(first: 2) { cursor edges { node { id author content } } pageInfo { startCursor endCursor hasNextPage } } }"
        XCTAssertEqual(String(describing: query), expected)
    }

    static var allTests = [
        ("testBuildField", testBuildField),
        ("testBuildObject", testBuildObject),
        ("testBuildObjectWithAlias", testBuildObjectWithAlias),
        ("testBuildObjectWithSchemaName", testBuildObjectWithSchemaName),
        ("testBuildObjectWithArgument", testBuildObjectWithArgument),
        ("testBuildObjectWithCaseStyle", testBuildObjectWithCaseStyle),
        ("testBuildObjectWithRemove", testBuildObjectWithFalseInclude),
        ("testBuildObjectWithTrueSkip", testBuildObjectWithTrueSkip),
        ("testBuildObjectWithSlice", testBuildObjectWithSlice),
        ("testBuildObjectWithSliceAndOffset", testBuildObjectWithSliceAndOffset),
        ("testBuildObjectWithNoSliceAndEdges", testBuildObjectWithNoSliceAndEdges),
        ("testBuildObjectWithEdgesAndPageInfo", testBuildObjectWithEdgesAndPageInfo),
        ("testBuildObjectWithEdgesAndPageInfoStrings", testBuildObjectWithEdgesAndPageInfoStrings),
    ]
}

