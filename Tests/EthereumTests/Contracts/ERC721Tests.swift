import XCTest
import BigInt
import Ethereum

class ERC721Tests: XCTestCase {
    
    let contractAddress = "0xf8aD42AB76862A934AD2e4578C6a108B172Cd287"
    
    override func setUpWithError() throws {
        let node = try Node(url: "https://ropsten.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")
        EthereumService.configureProvider(with: node)
    }
    
    func testBalance() async throws {
        
        let address = "0x495f947276749ce646f68ac8c248420045cb7b5e"
        
        let transaction = try ERC721TransactionFactory.generateBalanceTransaction(address: address, contractAddress: contractAddress)
        
        let _ = try await EthereumService.call(transaction: transaction)
    }
    
    func testOwnerOf() async throws {
        
        let tokenId = BigUInt(708)
        
        let transaction = try ERC721TransactionFactory.generateOwnerOfTransaction(tokenId: tokenId, contractAddress: contractAddress)
        
        let _ = try await EthereumService.call(transaction: transaction)
    }
    
    func testName() async throws {
        
        let transaction = try ERC721TransactionFactory.generateNameTransaction(contractAddress: contractAddress)
        
        let _ = try await EthereumService.call(transaction: transaction)
    }
    
    func testSymbol() async throws {
        
        let transaction = try ERC721TransactionFactory.generateSymbolTransaction(contractAddress: contractAddress)
        
        
        let _ = try await EthereumService.call(transaction: transaction)
    }
    
    func testTokenURI() async throws {
        
        let tokenId = BigUInt(708)
        
        let transaction = try ERC721TransactionFactory.generateTokenURITransaction(tokenId: tokenId, contractAddress: contractAddress)
        
        
        let _ = try await EthereumService.call(transaction: transaction)
    }
    
    func testTotalSupply() async throws {
        
        let transaction = try ERC721TransactionFactory.generateTotalSupplyTransaction(contractAddress: contractAddress)
        
        let _ = try await EthereumService.call(transaction: transaction)
    }
}
