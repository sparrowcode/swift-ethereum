import XCTest
import BigInt
import Ethereum

class ERC20Tests: XCTestCase {
    
    let contractAddress = "0xF65FF945f3a6067D0742fD6890f32A6960dD817d"
    
    override func setUpWithError() throws {
        let node = try Node(url: "https://ropsten.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")
        EthereumService.configureProvider(with: node)
    }
    
    func testBalance() async throws {
        
        let address = "0xE92A146f86fEda6D14Ee1dc1BfB620D3F3d1b873"
        
        let transaction = try ERC20TransactionFactory.generateBalanceTransaction(address: address, contractAddress: contractAddress)
        
        let _ = try await EthereumService.call(transaction: transaction)
    }
    
    func testTransfer() async throws {
        
        let storage = UserDefaultsStorage(password: "password")
        
        let accountManager = AccountManager(storage: storage)
        
        let account = try accountManager.importAccount(privateKey: "2404a482a212386ecf1ed054547cf4d28348ddf73d23325a83373f803138f105")
        
        let transaction = try ERC20TransactionFactory.generateTransferTransaction(value: BigUInt(210000000),
                                                                                  to: "0xc8DE4C1B4f6F6659944160DaC46B29a330C432B2",
                                                                                  gasLimit: BigUInt(100000),
                                                                                  gasPrice: BigUInt(220000000000),
                                                                                  contractAddress: contractAddress)
        
        let _ = try await EthereumService.sendRawTransaction(account: account, transaction: transaction)
    }
    
    func testDecimals() async throws {
        
        let transaction = try ERC20TransactionFactory.generateDecimalsTransaction(contractAddress: contractAddress)
        
        let _ = try await EthereumService.call(transaction: transaction)
    }
    
    func testSymbol() async throws {
        
        let transaction = try ERC20TransactionFactory.generateSymbolTransaction(contractAddress: contractAddress)
        
        let _ = try await EthereumService.call(transaction: transaction)
    }
    
    func testTotalSupply() async throws {
        
        let transaction = try ERC20TransactionFactory.generateTotalSupplyTransaction(contractAddress: contractAddress)
        
        let _ = try await EthereumService.call(transaction: transaction)
    }
    
    func testName() async throws {
        
        let transaction = try ERC20TransactionFactory.generateNameTransaction(contractAddress: contractAddress)
        
        let _ = try await EthereumService.call(transaction: transaction)
    }
    
    func testApprove() throws {
        
        //        let expectation = XCTestExpectation(description: "approve erc20")
        //
        //        let storage = UserDefaultsStorage(password: "password")
        //
        //        let accountManager = AccountManager(storage: storage)
        //
        //        let account = try accountManager.importAccount(privateKey: "2404a482a212386ecf1ed054547cf4d28348ddf73d23325a83373f803138f105")
        //
        //        let value = BigUInt("152587885986328125000000", radix: 10)!
        
        //        erc20.approve(spender: account, value: value) { remaining, error in
        //            XCTAssertNil failed: "ethereumError(Ethereum.JSONRPCErrorResult(code: 3, message: "execution reverted: ERC20: approve from the zero address"))"
        //
        //            XCTAssertNil(error)
        //            XCTAssertNotNil(remaining)
        //            expectation.fulfill()
        //        }
        
        //wait(for: [expectation], timeout: 50)
    }
    
    func testDeploy() throws {
        
        //        let expectation = XCTestExpectation(description: "approve erc20")
        //
        //        let binary = try  "1234567890".bytes
        //
        //        let binaryData = Data(binary)
        //
        //        let erc20 = SPToken(address: "")
        //
        //        let storage = UserDefaultsStorage(password: "password")
        //
        //        let accountManager = AccountManager(storage: storage)
        //
        //        let account = try accountManager.importAccount(privateKey: "2404a482a212386ecf1ed054547cf4d28348ddf73d23325a83373f803138f105")
        //
        //        erc20.deploy(with: account, binary: binaryData, gasLimit: BigUInt(200000), gasPrice: BigUInt(1000000)) { hash, error in
        //            XCTAssertNil(error)
        //            XCTAssertNotNil(hash)
        //            expectation.fulfill()
        //        }
        //
        //        wait(for: [expectation], timeout: 50)
    }
}

