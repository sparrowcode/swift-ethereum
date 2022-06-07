import XCTest
import BigInt
import Ethereum

class EthereumServiceTests: XCTestCase {
    
    var ropstenNode: Node!
    var maiinetNode: Node!
    
    override func setUpWithError() throws {
        maiinetNode = try Node(url: "https://mainnet.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")
        ropstenNode = try Node(url: "https://ropsten.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")
        EthereumService.configureProvider(with: maiinetNode)
    }
    
    func testGetBalance() async throws {
        
        let address = "0xE92A146f86fEda6D14Ee1dc1BfB620D3F3d1b873"
        
        EthereumService.configureProvider(with: ropstenNode)
        
        let _ = try await EthereumService.getBalance(for: address)
    }
    
    func testGetTransactionCount() async throws {
        
        let address = "0xb5bfc95C7345c8B20e5290D21f88a602580a08AB"
        
        let _ = try await EthereumService.getTransactionCount(for: address)
    }
    
    func testBlockNumber() async throws {
        
        let _ = try await EthereumService.blockNumber()
    }
    
    func testGasPrice() async throws {
        
        let _ = try await EthereumService.gasPrice()
    }
    
    func testGetBlockTransactionCountByHash() async throws {
        
        let blockHash = "0xcd6112f8e97b646a5c25e75e62a509337c77ff9e879b261d5d2d958f13a8a403"
        
        let _ = try await EthereumService.getBlockTransactionCountByHash(blockHash: blockHash)
    }
    
    func testGetBlockTransactionCountByNumber() async throws {
        
        let blockNumber = 2
        
        let _ = try await EthereumService.getBlockTransactionCountByNumber(blockNumber: blockNumber)
    }
    
    func testGetStorageAt() async throws {
        
        let address = "0x295a70b2de5e3953354a6a8344e616ed314d7251"
        let storageSlot = 3
        let block = "latest"
        
        let _ = try await EthereumService.getStorageAt(address: address, storageSlot: storageSlot, block: block)
    }
    
    func testGetCode() async throws {
        
        let address = "0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39"
        let block = "latest"
        
        let _ = try await EthereumService.getCode(address: address, block: block)
    }
    
    func testGetBlockByHash() async throws {
        
        let hash = "0xad1328d13f833b8af722117afdc406a762033321df8e48c00cd372d462f48169"
        
        let _ = try await EthereumService.getBlockByHash(hash: hash)
    }
    
    func testGetBlockByNumber() async throws {
        
        let blockNumber = 12312
        
        let _ = try await EthereumService.getBlockByNumber(blockNumber: blockNumber)
    }
    
    func testGetTransactionByHash() async throws {
        
        let transactionHash = "0xb2fea9c4b24775af6990237aa90228e5e092c56bdaee74496992a53c208da1ee"
        
        let _ = try await EthereumService.getTransactionByHash(transactionHash: transactionHash)
    }
    
    func testGetUncleByBlockNumberAndIndexNullResponse() async throws {
        
        let blockNumber = 12312
        let index = 0
        
        do {
            let _ = try await EthereumService.getUncleByBlockNumberAndIndex(blockNumber: blockNumber, index: index)
        } catch {
//            XCTAssertEqual(error, ResponseError.nilResponse)
            XCTAssertNotNil(error)
        }
    }
    
    func testGetUncleByBlockNumberAndIndex() async throws {
        
        let blockNumber = 668
        let index = 0
        
        let _ = try await EthereumService.getUncleByBlockNumberAndIndex(blockNumber: blockNumber, index: index)
    }
    
    func testGetUncleByBlockHashAndIndex() async throws {
        
        let blockHash = "0x84e538e6da2340e3d4d90535f334c22974fecd037798d1cf8965c02e8ab3394b"
        let index = 0
        
        let _ = try await EthereumService.getUncleByBlockHashAndIndex(blockHash: blockHash, index: index)
    }
    
    func testGetUncleByBlockHashAndIndexNullResponse() async throws {
        
        let blockHash = "0x7cea0c9ae53df7073fcd4e7b19fc3f1905a2540bbdbd9a10796c9296f5af55dc"
        let index = 0
        
        do {
            let _ = try await EthereumService.getUncleByBlockHashAndIndex(blockHash: blockHash, index: index)
        } catch {
            //            XCTAssertEqual(error, ResponseError.nilResponse)
            XCTAssertNotNil(error)
        }
    }
    
    func testGetTransactionByBlockHashAndIndex() async throws {
        
        let blockHash = "0x3c82bc62179602b67318c013c10f99011037c49cba84e31ffe6e465a21c521a7"
        let index = 0
        
        let _ = try await EthereumService.getTransactionByBlockHashAndIndex(blockHash: blockHash, index: index)
    }
    
    func testGetTransactionByBlockHashAndIndexNullResponse() async throws {
        
        let blockHash = "0x8ed01db361de1e33ad89944aeca1412e536694be671df9c36e76ecc6d6ac44e5"
        let index = 0
        
        do {
            let _ = try await EthereumService.getTransactionByBlockHashAndIndex(blockHash: blockHash, index: index)
        } catch {
            //            XCTAssertEqual(error, ResponseError.nilResponse)
            XCTAssertNotNil(error)
        }
    }
    
    func testGetTransactionByBlockNumberAndIndex() async throws {
        
        let blockNumber = 5417326
        let index = 0
        
        let _ = try await EthereumService.getTransactionByBlockNumberAndIndex(blockNumber: blockNumber, index: index)
    }
    
    func testGetTransactionByBlockNumberAndIndexNullResponse() async throws {
        
        let blockNumber = 541
        let index = 0
        
        do {
            let _ = try await EthereumService.getTransactionByBlockNumberAndIndex(blockNumber: blockNumber, index: index)
        } catch {
            //            XCTAssertEqual(error, ResponseError.nilResponse)
            XCTAssertNotNil(error)
        }
    }
    
    func testGetTransactionReceipt() async throws {
        
        let transactionHash = "0xa3ece39ae137617669c6933b7578b94e705e765683f260fcfe30eaa41932610f"
        
        let _ = try await EthereumService.getTransactionReceipt(transactionHash: transactionHash)
    }
    
    func testSendRawTransaction() async throws {
        
        // MARK: - For sending transactions use test network
        EthereumService.configureProvider(with: ropstenNode)
        
        let storage = UserDefaultsStorage(password: "password")
        
        let accountManager = AccountManager(storage: storage)
        
        let account = try accountManager.importAccount(privateKey: "2404a482a212386ecf1ed054547cf4d28348ddf73d23325a83373f803138f105")
        
        // random value
        let value = "0000000".map({ _ in String(UInt32.random(in: 0...9)) }).reduce("", +)
        
        let transaction = try Transaction(from: "0xE92A146f86fEda6D14Ee1dc1BfB620D3F3d1b873",
                                          gasLimit: "210000",
                                          gasPrice: "250000000000",
                                          to: "0xc8DE4C1B4f6F6659944160DaC46B29a330C432B2",
                                          value: BigUInt(value))
        
        let _ = try await EthereumService.sendRawTransaction(account: account, transaction: transaction)
    }
    
    func testEstimateGas() async throws {
        
        EthereumService.configureProvider(with: ropstenNode)
        
        let transaction = try Transaction(from: "0xE92A146f86fEda6D14Ee1dc1BfB620D3F3d1b873",
                                          to: "0xc8DE4C1B4f6F6659944160DaC46B29a330C432B2",
                                          value: "1000000")
        
        let _ = try await EthereumService.estimateGas(for: transaction)
    }
}
