import XCTest
@testable import Ethereum

class ProviderTests: XCTestCase {
    
    let mainnetNodeURL = URL(string: "https://speedy-nodes-nyc.moralis.io/b383c412901116039315dd16/eth/mainnet")!
    
    let rinkebyNodeURL = URL(string: "https://speedy-nodes-nyc.moralis.io/b383c412901116039315dd16/eth/rinkeby")!
    
    var node: Node?
    var provider: Provider?
    
    override func setUpWithError() throws {
        self.node = Node.mainnet
        self.provider = Provider(node: node!)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSendRequest() throws {
        
        let address = "0xb5bfc95C7345c8B20e5290D21f88a602580a08AB"
        let expectation = XCTestExpectation(description: "send request")
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .getBalance, params: [address, "latest"], id: 1)
        
        let jsonRPCData = try JSONEncoder().encode(jsonRPC)
        
        provider?.sendRequest(jsonRPCData: jsonRPCData) { error, data in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testSendRequest2() throws {
        
        let expectation = XCTestExpectation(description: "send request")
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .version, params: Optional<String>.none, id: 10)
        
        let jsonRPCData = try JSONEncoder().encode(jsonRPC)
                
        provider?.sendRequest(jsonRPCData: jsonRPCData) { error, data in
            
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            expectation.fulfill()
            
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            
        }
    }
    
}
