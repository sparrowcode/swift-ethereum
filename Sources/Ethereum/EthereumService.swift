import Foundation
import BigInt

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum EthereumService {
    
    private static var provider: Provider!
    
    public static func configureProvider(with node: Node) {
        self.provider = Provider(node: node)
    }

    // MARK: - Original Methods
    /**
     Ethereum: Returns the current price per gas in wei.
     */
    public static func gasPrice(completion: @escaping (Result<BigUInt, Error>) -> ()) {
        
        let params = [String]()
        
        provider.sendRequest(method: .gasPrice, params: params, decodeTo: String.self) { result in
            
            switch result {
            case .success(let hexGasPrice):
                if let gasPrice = BigUInt(hexGasPrice.removeHexPrefix(), radix: 16) {
                    completion(.success(gasPrice))
                } else {
                    completion(.failure(ConvertingError.errorConvertingFromHex))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     Ethereum: Returns the number of most recent block.
     */
    public static func blockNumber(completion: @escaping (Result<Int, Error>) -> ()) {
        
        let params = [String]()
        
        provider.sendRequest(method: .blockNumber, params: params, decodeTo: String.self) { result in
            
            switch result {
            case .success(let hexBlockNumber):
                if let blockNumber = Int(hexBlockNumber.removeHexPrefix(), radix: 16) {
                    completion(.success(blockNumber))
                } else {
                    completion(.failure(ConvertingError.errorConvertingFromHex))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     Ethereum: Returns the balance of the account of given address.
     */
    public static func getBalance(for address: String, block: String = "latest", completion: @escaping (Result<BigUInt, Error>) -> ()) {
        
        let params = [address, block]
        
        provider.sendRequest(method: .getBalance, params: params, decodeTo: String.self) { result in
            
            switch result {
            case .success(let hexBalance):
                if let balance = BigUInt(hexBalance.removeHexPrefix(), radix: 16) {
                    completion(.success(balance))
                } else {
                    completion(.failure(ConvertingError.errorConvertingFromHex))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     Ethereum: retrieves raw state storage for a smart contract;
     */
    public static func getStorageAt(address: String, storageSlot: Int, block: String = "latest", completion: @escaping (Result<BigUInt, Error>) -> ()) {
        
        let hexStorageSlot = String(storageSlot, radix: 16).addHexPrefix()
        
        let params = [address, hexStorageSlot, block]
        
        provider.sendRequest(method: .getStorageAt, params: params, decodeTo: String.self) { result in
            
            switch result {
            case .success(let hexValue):
                if let value = BigUInt(hexValue.removeHexPrefix(), radix: 16) {
                    completion(.success(value))
                } else {
                    completion(.failure(ConvertingError.errorConvertingFromHex))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     Ethereum: Returns the number of transactions sent from an address.
     */
    public static func getTransactionCount(for address: String, block: String = "latest", completion: @escaping (Result<Int, Error>) -> ()) {
        
        let params = [address, block]
        
        provider.sendRequest(method: .getTransactionCount, params: params, decodeTo: String.self) { result in
            
            switch result {
            case .success(let hexNonce):
                if let nonce = Int(hexNonce.removeHexPrefix(), radix: 16) {
                    completion(.success(nonce))
                } else {
                    completion(.failure(ConvertingError.errorConvertingFromHex))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     Ethereum: Returns the number of transactions in a block from a block matching the given block hash.
     */
    public static func getBlockTransactionCountByHash(blockHash: String, completion: @escaping (Result<Int, Error>) -> ()) {
        
        let params = [blockHash]
        
        provider.sendRequest(method: .getBlockTransactionCountByHash, params: params, decodeTo: String?.self) { result in
            
            switch result {
            case .success(let hexTransactionCount):
                guard let hexTransactionCount = hexTransactionCount else {
                    completion(.failure(ResponseError.nilResponse))
                    return
                }
                if let transactionCount = Int(hexTransactionCount.removeHexPrefix(), radix: 16) {
                    completion(.success(transactionCount))
                } else {
                    completion(.failure(ConvertingError.errorConvertingFromHex))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     Ethereum: Returns the number of transactions in a block matching the given block number.
     */
    public static func getBlockTransactionCountByNumber(blockNumber: Int, completion: @escaping (Result<Int, Error>) -> ()) {
        
        let hexBlockNumber = String(blockNumber, radix: 16).addHexPrefix()
        
        let params = [hexBlockNumber]
        
        provider.sendRequest(method: .getBlockTransactionCountByNumber, params: params, decodeTo: String?.self) { result in
            
            switch result {
            case .success(let hexTransactionCount):
                guard let hexTransactionCount = hexTransactionCount else {
                    completion(.failure(ResponseError.nilResponse))
                    return
                }
                if let transactionCount = Int(hexTransactionCount.removeHexPrefix(), radix: 16) {
                    completion(.success(transactionCount))
                } else {
                    completion(.failure(ConvertingError.errorConvertingFromHex))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     Ethereum: Returns the compiled solidity code
     */
    public static func getCode(address: String, block: String = "latest", completion: @escaping (Result<String, Error>) -> ()) {
        
        let params = [address, block]
        
        provider.sendRequest(method: .getCode, params: params, decodeTo: String.self) { result in
            
            completion(result)
        }
    }
    
    /**
     Ethereum: Creates new message call transaction or a contract creation for signed transactions.
     sendRawTransaction() requires that the transaction be already signed and serialized. So it requires extra serialization steps to use, but enables you to broadcast transactions on hosted nodes. There are other reasons that you might want to use a local key, of course. All of them would require using sendRawTransaction().
     */
    public static func sendRawTransaction(account: Account, transaction: Transaction, completion: @escaping (Result<String, Error>) -> ()) {
        
        self.getTransactionCount(for: account.address) { result in
            
            var nonce: Int
            
            switch result {
            case .success(let nonceValue):
                nonce = nonceValue
            case .failure(let error):
                completion(.failure(error))
                return
            }
            
            var unsignedTransaction = transaction
            
            unsignedTransaction.chainID = provider.node.network.chainID

            unsignedTransaction.nonce = nonce
            
            var rlpBytes = Data()
            
            do {
                let signedTransaction = try account.sign(transaction: unsignedTransaction)
                rlpBytes = try signedTransaction.encodeRLP()
            } catch {
                completion(.failure(error))
                return
            }
            
            
            let signedTransactionHash = String(bytes: rlpBytes).addHexPrefix()
            
            let params = [signedTransactionHash]
            
            provider.sendRequest(method: .sendRawTransaction, params: params, decodeTo: String.self) { result in
                
                completion(result)
            }
        }
    }
    
    /**
     Ethereum: Executes a new message call immediately without creating a transaction on the block chain. Primarily is used on smart contracts
     */
    public static func call(transaction: Transaction, block: String = "latest", completion: @escaping (Result<String, Error>) -> ()) {
        
        
        struct Params: Codable {
            let transaction: Transaction
            let block: String
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.unkeyedContainer()
                try container.encode(transaction)
                try container.encode(block)
            }
        }
        
        let params = Params(transaction: transaction, block: block)
        
        provider.sendRequest(method: .call, params: params, decodeTo: String.self) { result in
            
            completion(result)
        }
    }
    
    /**
     Ethereum: Generates and returns an estimate of how much gas is necessary to allow the transaction to complete. The transaction will not be added to the blockchain. Note that the estimate may be significantly more than the amount of gas actually used by the transaction, for a variety of reasons including EVM mechanics and node performance.
     */
    public static func estimateGas(for transaction: Transaction, block: String = "latest", completion: @escaping (Result<BigUInt, Error>) -> ()) {
        
        struct Params: Codable {
            let transaction: Transaction
            let block: String
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.unkeyedContainer()
                try container.encode(transaction)
                try container.encode(block)
            }
        }
        
        let params = Params(transaction: transaction, block: block)
        
        provider.sendRequest(method: .estimateGas, params: params, decodeTo: String.self) { result in
            
            switch result {
            case .success(let hexValue):
                if let value = BigUInt(hexValue.removeHexPrefix(), radix: 16) {
                    completion(.success(value))
                } else {
                    completion(.failure(ConvertingError.errorConvertingFromHex))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     Ethereum: Returns information about a block by hash.
     */
    public static func getBlockByHash(hash: String, completion: @escaping (Result<Block, Error>) -> ()) {
        
        struct Params: Codable {
            let hash: String
            let isHydratedTransaction: Bool
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.unkeyedContainer()
                try container.encode(hash)
                try container.encode(isHydratedTransaction)
            }
        }
        
        let params = Params(hash: hash, isHydratedTransaction: false)
        
        provider.sendRequest(method: .getBlockByHash, params: params, decodeTo: Block.self) { result in
            
            completion(result)
        }
    }
    
    /**
     Ethereum: Returns information about a block by block number.
     */
    public static func getBlockByNumber(blockNumber: Int, completion: @escaping (Result<Block, Error>) -> ()) {
        
        let hexBlockNumber = String(blockNumber, radix: 16).addHexPrefix()
        
        struct Params: Codable {
            let hexBlockNumber: String
            let isHydratedTransaction: Bool
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.unkeyedContainer()
                try container.encode(hexBlockNumber)
                try container.encode(isHydratedTransaction)
            }
        }
        
        let params = Params(hexBlockNumber: hexBlockNumber, isHydratedTransaction: false)
        
        provider.sendRequest(method: .getBlockByNumber, params: params, decodeTo: Block.self) { result in
            
            completion(result)
        }
    }
    
    /**
     Ethereum: Returns the information about a transaction requested by transaction hash.
     */
    public static func getTransactionByHash(transactionHash: String, completion: @escaping (Result<Transaction, Error>) -> ()) {
        
        let params = [transactionHash]
        
        provider.sendRequest(method: .getTransactionByHash, params: params, decodeTo: Transaction.self) { result in
            
            completion(result)
        }
    }
    
    /**
     Ethereum: Returns information about a transaction by block hash and transaction index position.
     */
    public static func getTransactionByBlockHashAndIndex(blockHash: String, index: Int, completion: @escaping (Result<Transaction, Error>) -> ()) {
        
        let hexIndex = String(index, radix: 16).addHexPrefix()
        
        let params = [blockHash, hexIndex]
        
        provider.sendRequest(method: .getTransactionByBlockHashAndIndex, params: params, decodeTo: Transaction?.self) { result in
            
            switch result {
            case .success(let optionalTransaction):
                guard let transaction = optionalTransaction else {
                    completion(.failure(ResponseError.noResult))
                    return
                }
                completion(.success(transaction))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     Ethereum: Returns information about a transaction by block number and transaction index position.
     */
    public static func getTransactionByBlockNumberAndIndex(blockNumber: Int, index: Int, completion: @escaping (Result<Transaction, Error>) -> ()) {
        
        let hexBlockNumber = String(blockNumber, radix: 16).addHexPrefix()
        
        let hexIndex = String(index, radix: 16).addHexPrefix()
        
        let params = [hexBlockNumber, hexIndex]
        
        provider.sendRequest(method: .getTransactionByBlockNumberAndIndex, params: params, decodeTo: Transaction?.self) { result in
            
            switch result {
            case .success(let optionalTransaction):
                guard let transaction = optionalTransaction else {
                    completion(.failure(ResponseError.noResult))
                    return
                }
                completion(.success(transaction))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    /**
     Ethereum: Returns the receipt of a transaction by transaction hash.
     */
    public static func getTransactionReceipt(transactionHash: String, completion: @escaping (Result<Receipt, Error>) -> ()) {
        
        let params = [transactionHash]
        
        provider.sendRequest(method: .getTransactionReceipt, params: params, decodeTo: Receipt.self) { result in
            
            completion(result)
        }
    }
    
    /**
     Ethereum: Returns information about a uncle of a block by hash and uncle index position.
     */
    public static func getUncleByBlockHashAndIndex(blockHash: String, index: Int, completion: @escaping (Result<Block, Error>) -> ()) {
        
        let hexIndex = String(index, radix: 16).addHexPrefix()
        
        let params = [blockHash, hexIndex]
        
        provider.sendRequest(method: .getUncleByBlockHashAndIndex, params: params, decodeTo: Block?.self) { result in
            
            switch result {
            case .success(let optionalBlock):
                guard let block = optionalBlock else {
                    completion(.failure(ResponseError.noResult))
                    return
                }
                completion(.success(block))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     Ethereum: Returns information about a uncle of a block by number and uncle index position.
     */
    public static func getUncleByBlockNumberAndIndex(blockNumber: Int, index: Int, completion: @escaping (Result<Block, Error>) -> ()) {
        
        let hexBlockNumber = String(blockNumber, radix: 16).addHexPrefix()
        
        let hexIndex = String(index, radix: 16).addHexPrefix()
        
        let params = [hexBlockNumber, hexIndex]
        
        provider.sendRequest(method: .getUncleByBlockNumberAndIndex, params: params, decodeTo: Block?.self) { result in
            
            switch result {
            case .success(let optionalBlock):
                guard let block = optionalBlock else {
                    completion(.failure(ResponseError.noResult))
                    return
                }
                completion(.success(block))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: TO LATER
    /**
     Ethereum: Returns an array of all logs matching a given filter object.
     */
//    public static func getLogs() {
//
//    }
    /*
    /**
     Ethereum: Creates a filter object, based on filter options, to notify when the state changes (logs). To check if the state has changed, call eth_getFilterChanges.
     */
    public static func newFilter() {
        
    }
    
    /**
     Ethereum: Creates a filter in the node, to notify when a new block arrives. To check if the state has changed, call eth_getFilterChanges.
     */
    public static func newBlockFilter() {
        
    }
    
    /**
     Ethereum: Creates a filter in the node, to notify when new pending transactions arrive. To check if the state has changed, call eth_getFilterChanges.
     */
    public static func newPendingTransactionFilter() {
        
    }
    
    /**
     Ethereum: Uninstalls a filter with given id. Should always be called when watch is no longer needed. Additonally Filters timeout when they aren't requested with eth_getFilterChanges for a period of time.
     */
    public static func uninstallFilter() {
        
    }
    
    /**
     Ethereum: Polling method for a filter, which returns an array of logs which occurred since last poll.
     */
    public static func getFilterChanges() {
        
    }*/
}

extension EthereumService {
    
    public static func gasPrice() async throws -> BigUInt {
        return try await withCheckedThrowingContinuation { continuation in
            gasPrice() { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public static func blockNumber() async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            blockNumber() { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public static func getBalance(for address: String, block: String = "latest") async throws -> BigUInt {
        return try await withCheckedThrowingContinuation { continuation in
            getBalance(for: address, block: block) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public static func getStorageAt(address: String, storageSlot: Int, block: String = "latest") async throws -> BigUInt {
        return try await withCheckedThrowingContinuation { continuation in
            getStorageAt(address: address, storageSlot: storageSlot) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public static func getTransactionCount(for address: String, block: String = "latest") async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            getTransactionCount(for: address, block: block) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public static func getBlockTransactionCountByHash(blockHash: String) async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            getBlockTransactionCountByHash(blockHash: blockHash) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public static func getBlockTransactionCountByNumber(blockNumber: Int) async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            getBlockTransactionCountByNumber(blockNumber: blockNumber) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public static func getCode(address: String, block: String = "latest") async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            getCode(address: address, block: block) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public static func sendRawTransaction(account: Account, transaction: Transaction) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            sendRawTransaction(account: account, transaction: transaction) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public static func call(transaction: Transaction, block: String = "latest") async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            call(transaction: transaction, block: block) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public static func estimateGas(for transaction: Transaction, block: String = "latest") async throws -> BigUInt {
        return try await withCheckedThrowingContinuation { continuation in
            estimateGas(for: transaction, block: block) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public static func getBlockByHash(hash: String) async throws -> Block {
        return try await withCheckedThrowingContinuation { continuation in
            getBlockByHash(hash: hash) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public static func getBlockByNumber(blockNumber: Int) async throws -> Block {
        return try await withCheckedThrowingContinuation { continuation in
            getBlockByNumber(blockNumber: blockNumber) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public static func getTransactionByHash(transactionHash: String) async throws -> Transaction {
        return try await withCheckedThrowingContinuation { continuation in
            getTransactionByHash(transactionHash: transactionHash) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public static func getTransactionByBlockHashAndIndex(blockHash: String, index: Int) async throws -> Transaction {
        return try await withCheckedThrowingContinuation { continuation in
            getTransactionByBlockHashAndIndex(blockHash: blockHash, index: index) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    
    public static func getTransactionByBlockNumberAndIndex(blockNumber: Int, index: Int) async throws -> Transaction {
        return try await withCheckedThrowingContinuation { continuation in
            getTransactionByBlockNumberAndIndex(blockNumber: blockNumber, index: index) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public static func getTransactionReceipt(transactionHash: String) async throws -> Receipt {
        return try await withCheckedThrowingContinuation { continuation in
            getTransactionReceipt(transactionHash: transactionHash) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public static func getUncleByBlockHashAndIndex(blockHash: String, index: Int) async throws -> Block {
        return try await withCheckedThrowingContinuation { continuation in
            getUncleByBlockHashAndIndex(blockHash: blockHash, index: index) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public static func getUncleByBlockNumberAndIndex(blockNumber: Int, index: Int) async throws -> Block {
        return try await withCheckedThrowingContinuation { continuation in
            getUncleByBlockNumberAndIndex(blockNumber: blockNumber, index: index) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
