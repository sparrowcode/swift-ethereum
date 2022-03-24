import XCTest
@testable import Ethereum

class EthereumServiceTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetBalance() throws {
        
        let address = "0xb5bfc95C7345c8B20e5290D21f88a602580a08AB"
        let expectation = XCTestExpectation(description: "get balance")
        
        EthereumService.getBalance(for: address) { error, balance in
            XCTAssertNil(error)
            XCTAssertNotNil(balance)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testGetTransactionCount() throws {
        
        let address = "0xb5bfc95C7345c8B20e5290D21f88a602580a08AB"
        let expectation = XCTestExpectation(description: "get transaction count")
        
        EthereumService.getTransactionCount(for: address) { error, nonce in
            XCTAssertNil(error)
            XCTAssertNotNil(nonce)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testBlockNumber() throws {
        
        let expectation = XCTestExpectation(description: "block number")
        
        EthereumService.blockNumber { error, blockNumber in
            XCTAssertNil(error)
            XCTAssertNotNil(blockNumber)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testGasPrice() throws {
        let expectation = XCTestExpectation(description: "gas price")
        
        EthereumService.gasPrice { error, gasPrice in
            XCTAssertNil(error)
            XCTAssertNotNil(gasPrice)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testGetBlockTransactionCountByHash() throws {
        
        let expectation = XCTestExpectation(description: "transaction count for block by hash")
        let blockHash = "0xcd6112f8e97b646a5c25e75e62a509337c77ff9e879b261d5d2d958f13a8a403"
        
        EthereumService.getBlockTransactionCountByHash(blockHash: blockHash) { error, transactionCount in
            XCTAssertNil(error)
            XCTAssertNotNil(transactionCount)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }

    func testGetBlockTransactionCountByNumber() throws {
        
        let expectation = XCTestExpectation(description: "transaction count for block by number")
        let blockNumber = 2
        
        EthereumService.getBlockTransactionCountByNumber(blockNumber: blockNumber) { error, transactionCount in
            XCTAssertNil(error)
            XCTAssertNotNil(transactionCount)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testGetStorageAt() throws {
        
        let expectation = XCTestExpectation(description: "storage at")
        let address = "0x295a70b2de5e3953354a6a8344e616ed314d7251"
        let storageSlot = 3
        let block = "latest"
        
        EthereumService.getStorageAt(address: address, storageSlot: storageSlot, block: block) { error, value in
            XCTAssertNil(error)
            XCTAssertNotNil(value)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testGetCode() throws {
        
        let expectation = XCTestExpectation(description: "get code")
        let address = "0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39"
        let block = "latest"
        
        EthereumService.getCode(address: address, block: block) { error, byteCode in
            XCTAssertNil(error)
            XCTAssertNotNil(byteCode)
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
