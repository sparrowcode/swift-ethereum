import XCTest
@testable import Ethereum

class NodeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitialiseCustomNode() throws {
        
        let url = "https://mainnet.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee"
        
        let node = try Node(url: url)
        
        let network = node.network
        
        XCTAssertEqual(network, Network.mainnet)
    }

    func testVersion() throws {
        
        let expectation = XCTestExpectation(description: "version")
        
        Node.mainnet.version { version, error in
            XCTAssertNil(error)
            XCTAssertNotNil(version)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testListening() throws {
        
        let expectation = XCTestExpectation(description: "listening")
        
        Node.mainnet.listening { isListening, error in
            XCTAssertNil(error)
            XCTAssertNotNil(isListening)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testPeerCount() throws {
        
        let expectation = XCTestExpectation(description: "peer count")
        
        Node.mainnet.peerCount { peerCount, error in
            XCTAssertNil(error)
            XCTAssertNotNil(peerCount)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testClientVersion() throws {
        
        let expectation = XCTestExpectation(description: "client version")
        
        Node.mainnet.clientVersion { clientVersion, error in
            XCTAssertNil(error)
            XCTAssertNotNil(clientVersion)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testSha3() throws {
        
        let expectation = XCTestExpectation(description: "sha3")
        let value = "0x68656c6c6f20776f726c64"
        
        Node.mainnet.sha3(value: value) { sha3, error in
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
