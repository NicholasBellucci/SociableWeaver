import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SociableWeaverGeneralTests.allTests),
        testCase(SociableWeaverQueryTests.allTests),
        testCase(SociableWeaverMutationTests.allTests),
    ]
}
#endif
