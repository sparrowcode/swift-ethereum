import XCTest
@testable import Ethereum

class ERC20Tests: XCTestCase {

    func testGetBalance() throws {
        
        let expectation = XCTestExpectation(description: "get balance erc20")
        
        EthereumService.provider = Provider(node: .ropsten)
        
        let storage = UserDefaultsStorage(password: "password")
        
        let accountManager = AccountManager(storage: storage)
        
        let account = try accountManager.importAccount(privateKey: "2404a482a212386ecf1ed054547cf4d28348ddf73d23325a83373f803138f105")
        
        let erc20 = ERC20(address: "0xF65FF945f3a6067D0742fD6890f32A6960dD817d")
        
        
        erc20.balance(of: account) { value, error in
            XCTAssertNil(error)
            XCTAssertNotNil(value)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 50)
        
    }
    
    func testTransfer() throws {
        
        let expectation = XCTestExpectation(description: "transfer erc20")
        
        EthereumService.provider = Provider(node: .ropsten)
        
        let storage = UserDefaultsStorage(password: "password")
        
        let accountManager = AccountManager(storage: storage)
        
        let account = try accountManager.importAccount(privateKey: "2404a482a212386ecf1ed054547cf4d28348ddf73d23325a83373f803138f105")
        
        let erc20 = ERC20(address: "0xF65FF945f3a6067D0742fD6890f32A6960dD817d")
        
        erc20.transfer(to: "0xc8DE4C1B4f6F6659944160DaC46B29a330C432B2", amount: "21000000000000000000", with: account) { hash, error in
            XCTAssertNil(error)
            XCTAssertNotNil(hash)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 50)
    }
    
    func testDecimals() throws {
        
        let expectation = XCTestExpectation(description: "decimals erc20")
        
        EthereumService.provider = Provider(node: .ropsten)
        
        let erc20 = ERC20(address: "0xF65FF945f3a6067D0742fD6890f32A6960dD817d")
        
        
        erc20.decimals() { value, error in
            XCTAssertNil(error)
            XCTAssertNotNil(value)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 50)
        
    }
    
    func testSymbol() throws {
        
        let expectation = XCTestExpectation(description: "decimals erc20")
        
        EthereumService.provider = Provider(node: .ropsten)
        
        let erc20 = ERC20(address: "0xF65FF945f3a6067D0742fD6890f32A6960dD817d")
        
        
        erc20.symbol() { value, error in
            XCTAssertNil(error)
            XCTAssertNotNil(value)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 50)
        
    }
    
    func testTotalSupply() throws {
        
        let expectation = XCTestExpectation(description: "decimals erc20")
        
        EthereumService.provider = Provider(node: .ropsten)
        
        let erc20 = ERC20(address: "0xF65FF945f3a6067D0742fD6890f32A6960dD817d")
        
        
        erc20.totalSupply() { value, error in
            XCTAssertNil(error)
            XCTAssertNotNil(value)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 50)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
