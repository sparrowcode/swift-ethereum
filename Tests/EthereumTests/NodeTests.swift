//
//  NodeTests.swift
//  
//
//  Created by Ertem Biyik on 23.03.2022.
//

import XCTest
import Ethereum

class NodeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testVersion() throws {
        
        let expectation = XCTestExpectation(description: "net version")
        
        DefaultNodes.mainnet.version { error, version in
            XCTAssertNil(error)
            XCTAssertNotNil(version)
            print(version)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
