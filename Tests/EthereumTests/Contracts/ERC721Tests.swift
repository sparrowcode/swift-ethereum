import XCTest
import BigInt
import Ethereum

class ERC721Tests: XCTestCase {
    
    let contractAddress = "0xf8aD42AB76862A934AD2e4578C6a108B172Cd287"
    
    override func setUpWithError() throws {
        let node = try Node(url: "https://ropsten.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")
        EthereumService.configureProvider(with: node)
    }

    func testBalance() throws {
        
        let expectation = XCTestExpectation(description: "get balance erc721")
        
        let address = "0x495f947276749ce646f68ac8c248420045cb7b5e"
        
        let transaction = try ERC721TransactionFactory.generateBalanceTransaction(address: address, contractAddress: contractAddress)
        
        EthereumService.call(transaction: transaction) { response, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 50)
    }

    func testOwnerOf() throws {
        
        let expectation = XCTestExpectation(description: "get owner of erc721")
        
        let tokenId = BigUInt(708)
        
        let transaction = try ERC721TransactionFactory.generateOwnerOfTransaction(tokenId: tokenId, contractAddress: contractAddress)
        
        EthereumService.call(transaction: transaction) { response, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 50)
    }
    
    func testName() throws {
        
        let expectation = XCTestExpectation(description: "get name erc721")
        
        let transaction = try ERC721TransactionFactory.generateNameTransaction(contractAddress: contractAddress)
        
        EthereumService.call(transaction: transaction) { response, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 50)
    }
    
    func testSymbol() throws {
        
        let expectation = XCTestExpectation(description: "get symbol erc721")
        
        let transaction = try ERC721TransactionFactory.generateSymbolTransaction(contractAddress: contractAddress)
        
        EthereumService.call(transaction: transaction) { response, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 50)
        
    }
    
    func testTokenURI() throws {
        
        let expectation = XCTestExpectation(description: "get tokenURI of erc721")
        
        let tokenId = BigUInt(708)
        
        let transaction = try ERC721TransactionFactory.generateTokenURITransaction(tokenId: tokenId, contractAddress: contractAddress)
        
        EthereumService.call(transaction: transaction) { response, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 50)
    }
    
    func testTotalSupply() throws {
        
        let expectation = XCTestExpectation(description: "total supply of erc721")
        
        let transaction = try ERC721TransactionFactory.generateTotalSupplyTransaction(contractAddress: contractAddress)
        
        EthereumService.call(transaction: transaction) { response, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 50)
    }
}
