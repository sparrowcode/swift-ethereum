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
        
        let expectation = XCTestExpectation(description: "version")
        
        DefaultNodes.mainnet.version { error, version in
            XCTAssertNil(error)
            XCTAssertNotNil(version)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testListening() throws {
        
        let expectation = XCTestExpectation(description: "listening")
        
        DefaultNodes.mainnet.listening { error, isListening in
            XCTAssertNil(error)
            XCTAssertNotNil(isListening)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testPeerCount() throws {
        
        let expectation = XCTestExpectation(description: "peer count")
        
        DefaultNodes.mainnet.peerCount { error, peerCount in
            XCTAssertNil(error)
            XCTAssertNotNil(peerCount)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testClientVersion() throws {
        
        let expectation = XCTestExpectation(description: "client version")
        
        DefaultNodes.mainnet.clientVersion { error, clientVersion in
            XCTAssertNil(error)
            XCTAssertNotNil(clientVersion)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testSha3() throws {
        
        let expectation = XCTestExpectation(description: "sha3")
        let value = "0x68656c6c6f20776f726c64"
        
        DefaultNodes.mainnet.sha3(value: value) { error, sha3 in
            XCTAssertNil(error)
            XCTAssertNotNil(sha3)
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
