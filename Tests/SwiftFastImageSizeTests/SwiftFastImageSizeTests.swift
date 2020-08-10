import XCTest
@testable import SwiftFastImageSize

final class SwiftFastImageSizeTests: XCTestCase {
    func testExample(path: String, type: SwiftFastImageSize.ImageType, size: CGSize) {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let sizer = SwiftFastImageSize(path)
        do {
            try sizer.parse()
            XCTAssertEqual(sizer.imageType, type)
            XCTAssertEqual(sizer.imageSize, size)
        } catch let error {
            print("error", error)
        }
        
    }
    
    func testExample1() {
        testExample(path: "/Users/xxtstudio/Downloads/TB1v4a9c5DsXe8jSZR0XXXK6FXa-520-280.png_q90_.webp", type: SwiftFastImageSize.ImageType.webp, size: CGSize(width: 500, height: 665))
    }

    static var allTests = [
        ("testExample1", testExample1),
    ]
}
