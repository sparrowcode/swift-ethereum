import XCTest
@testable import Ethereum

class ERC20Tests: XCTestCase {

    func testGetBalance() throws {
        
        let expectation = XCTestExpectation(description: "send raw transaction")
        
        EthereumService.provider = Provider(node: .ropsten)
        
        let storage = UserDefaultsStorage(password: "password")
        
        let accountManager = AccountManager(storage: storage)
        
        let account = try accountManager.importAccount(privateKey: "2404a482a212386ecf1ed054547cf4d28348ddf73d23325a83373f803138f105")
        
        let erc20 = ERC20(address: "0xF65FF945f3a6067D0742fD6890f32A6960dD817d")
        
        
        erc20.getBalance(for: account) { value, error in
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
