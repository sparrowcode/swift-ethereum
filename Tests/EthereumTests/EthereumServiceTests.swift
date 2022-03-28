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
        
        let expectation = XCTestExpectation(description: "get block transaction count by hash")
        let blockHash = "0xcd6112f8e97b646a5c25e75e62a509337c77ff9e879b261d5d2d958f13a8a403"
        
        EthereumService.getBlockTransactionCountByHash(blockHash: blockHash) { error, transactionCount in
            XCTAssertNil(error)
            XCTAssertNotNil(transactionCount)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }

    func testGetBlockTransactionCountByNumber() throws {
        
        let expectation = XCTestExpectation(description: "get block transaction count by number")
        let blockNumber = 2
        
        EthereumService.getBlockTransactionCountByNumber(blockNumber: blockNumber) { error, transactionCount in
            XCTAssertNil(error)
            XCTAssertNotNil(transactionCount)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testGetStorageAt() throws {
        
        let expectation = XCTestExpectation(description: "get storage at")
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
    
    func testGetBlockByHash() throws {
        
        let expectation = XCTestExpectation(description: "get block by hash")
        let hash = "0xad1328d13f833b8af722117afdc406a762033321df8e48c00cd372d462f48169"
        
        EthereumService.getBlockByHash(hash: hash) { error, block in
            XCTAssertNil(error)
            XCTAssertNotNil(block)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testGetBlockByNumber() throws {
        
        let expectation = XCTestExpectation(description: "get block by number")
        let blockNumber = 12312
        
        EthereumService.getBlockByNumber(blockNumber: blockNumber) { error, block in
            XCTAssertNil(error)
            XCTAssertNotNil(block)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testGetTransactionByHash() throws {
        
        let expectation = XCTestExpectation(description: "get transaction by hash")
        let transactionHash = "0xb2fea9c4b24775af6990237aa90228e5e092c56bdaee74496992a53c208da1ee"
        
        EthereumService.getTransactionByHash(transactionHash: transactionHash) { error, transaction in
            XCTAssertNil(error)
            XCTAssertNotNil(transaction)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testGetUncleByBlockNumberAndIndexNullResponse() throws {
        
        let expectation = XCTestExpectation(description: "get uncle block by number and index null response")
        let blockNumber = 12312
        let index = 0
        
        EthereumService.getUncleByBlockNumberAndIndex(blockNumber: blockNumber, index: index) { error, block in
            XCTAssertNotNil(error)
            XCTAssertNil(block)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testGetUncleByBlockNumberAndIndex() throws {
        
        let expectation = XCTestExpectation(description: "get uncle block by number and index")
        let blockNumber = 668
        let index = 0
        
        EthereumService.getUncleByBlockNumberAndIndex(blockNumber: blockNumber, index: index) { error, block in
            XCTAssertNil(error)
            XCTAssertNotNil(block)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testGetUncleByBlockHashAndIndex() throws {
        
        let expectation = XCTestExpectation(description: "get uncle block by hash and index")
        let blockHash = "0x84e538e6da2340e3d4d90535f334c22974fecd037798d1cf8965c02e8ab3394b"
        let index = 0
        
        EthereumService.getUncleByBlockHashAndIndex(blockHash: blockHash, index: index) { error, block in
            XCTAssertNil(error)
            XCTAssertNotNil(block)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testGetUncleByBlockHashAndIndexNullResponse() throws {
        
        let expectation = XCTestExpectation(description: "get uncle block by hash and index null response")
        let blockHash = "0x7cea0c9ae53df7073fcd4e7b19fc3f1905a2540bbdbd9a10796c9296f5af55dc"
        let index = 0
        
        EthereumService.getUncleByBlockHashAndIndex(blockHash: blockHash, index: index) { error, block in
            XCTAssertNotNil(error)
            XCTAssertNil(block)
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
