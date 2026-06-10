import XCTest
@testable import PersistentUuidPlugin

class PersistentUuidTests: XCTestCase {
    func testGetPluginVersion() {
        let implementation = PersistentUuid()
        let result = implementation.getPluginVersion()

        XCTAssertEqual("8.0.0", result)
    }

    func testResetIdCreatesUuid() throws {
        let implementation = PersistentUuid()
        let result = try implementation.resetId("test")

        XCTAssertNotNil(result["id"] as? String)
        XCTAssertEqual("test", result["scope"] as? String)
        XCTAssertEqual(true, result["created"] as? Bool)
    }
}
