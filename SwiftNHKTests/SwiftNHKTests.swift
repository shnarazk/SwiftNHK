//
//  SwiftNHKTests.swift
//  SwiftNHKTests
//
//  Created by 楢崎修二 on 2021/08/03.
//

import XCTest
@testable import SwiftNHK

class SwiftNHKTests: XCTestCase {
    var apiKey: String = ProcessInfo.processInfo.environment["APIKey"] ?? ""
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(load_data(area: "400", service: "g1", apiKey: apiKey) != nil)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
