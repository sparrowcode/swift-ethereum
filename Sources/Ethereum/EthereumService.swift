import Foundation
import BigInt

public enum EthereumService {
    
    public static var provider = Provider(node: .mainnet)

    // MARK: - Original Methods
    /**
     Ethereum: Returns the current price per gas in wei.
     */
    public static func gasPrice(completion: @escaping (Int?, JSONRPCError?) -> Void) {
        
        // TODO: - Create a .none for params field
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .gasPrice, params: Optional<String>.none, id: 1)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                completion(nil, .ethereumError(ethereumError.error))
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            let hexGasPrice = jsonRPCResponse.result.removeHexPrefix()
            
            guard let gasPrice = Int(hexGasPrice, radix: 16) else { completion(nil, .errorConvertingFromHex)
                return
            }
            
            completion(gasPrice, nil)
        }
    }
    
    /**
     Ethereum: Returns the number of most recent block.
     */
    public static func blockNumber(completion: @escaping (Int?, JSONRPCError?) -> Void) {
        
        // TODO: - Create a .none for params field
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .blockNumber, params: Optional<String>.none, id: 2)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                completion(nil, .ethereumError(ethereumError.error))
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            let hexBlockNumber = jsonRPCResponse.result.removeHexPrefix()
            
            guard let blockNumber = Int(hexBlockNumber, radix: 16) else { completion(nil, .errorConvertingFromHex)
                return
            }
            
            completion(blockNumber, nil)
        }
    }
    
    /**
     Ethereum: Returns the balance of the account of given address.
     */
    public static func getBalance(for address: String, completion: @escaping (String?, JSONRPCError?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .getBalance, params: [address, "latest"], id: 3)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                completion(nil, .ethereumError(ethereumError.error))
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            let hexBalance = jsonRPCResponse.result.removeHexPrefix()
            
            guard let balance = BigInt(hexBalance, radix: 16) else { completion(nil, .errorConvertingFromHex)
                return
            }
            
            let stringBalance = String(balance)
            
            completion(stringBalance, nil)
        }
    }
    
    /**
     Ethereum: retrieves raw state storage for a smart contract;
     */
    public static func getStorageAt(address: String, storageSlot: Int, block: String = "latest", completion: @escaping (String?, JSONRPCError?) -> Void) {
        
        let hexStorageSlot = String(storageSlot, radix: 16).addHexPrefix()
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .getStorageAt, params: [address, hexStorageSlot, block], id: 4)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                completion(nil, .ethereumError(ethereumError.error))
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            let hexValue = jsonRPCResponse.result.removeHexPrefix()
            
            guard let value = BigInt(hexValue, radix: 16) else { completion(nil, .errorConvertingFromHex)
                return
            }
            
            completion(value.description, nil)
        }
    }
    
    /**
     Ethereum: Returns the number of transactions sent from an address.
     */
    public static func getTransactionCount(for address: String, completion: @escaping (Int?, JSONRPCError?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .getTransactionCount, params: [address, "latest"], id: 5)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                completion(nil, .ethereumError(ethereumError.error))
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            let hexNonce = jsonRPCResponse.result.removeHexPrefix()
            
            guard let nonce = Int(hexNonce, radix: 16) else { completion(nil, .errorConvertingFromHex)
                return
            }
            
            completion(nonce, nil)
        }
    }
    
    /**
     Ethereum: Returns the number of transactions in a block from a block matching the given block hash.
     */
    public static func getBlockTransactionCountByHash(blockHash: String, completion: @escaping (Int?, JSONRPCError?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .getBlockTransactionCountByHash, params: [blockHash], id: 6)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                completion(nil, .ethereumError(ethereumError.error))
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String?>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            guard let hexTransactionCount = jsonRPCResponse.result?.removeHexPrefix() else {
                completion(nil, .nilResponse)
                return
            }
            
            guard let transactionCount = Int(hexTransactionCount, radix: 16) else { completion(nil, .errorConvertingFromHex)
                return
            }
            
            completion(transactionCount, nil)
        }
    }
    
    /**
     Ethereum: Returns the number of transactions in a block matching the given block number.
     */
    public static func getBlockTransactionCountByNumber(blockNumber: Int, completion: @escaping (Int?, JSONRPCError?) -> Void) {
        
        let hexBlockNumber = String(blockNumber, radix: 16).addHexPrefix()
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .getBlockTransactionCountByNumber, params: [hexBlockNumber], id: 7)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                completion(nil, .ethereumError(ethereumError.error))
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            let hexTransactionCount = jsonRPCResponse.result.removeHexPrefix()
            
            guard let transactionCount = Int(hexTransactionCount, radix: 16) else { completion(nil, .errorConvertingFromHex)
                return
            }
            
            completion(transactionCount, nil)
        }
    }
    
    /**
     Ethereum: Returns the compiled solidity code
     */
    public static func getCode(address: String, block: String = "latest", completion: @escaping (String?, JSONRPCError?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .getCode, params: [address, block], id: 8)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                completion(nil, .ethereumError(ethereumError.error))
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            let byteCode = jsonRPCResponse.result
            
            completion(byteCode, nil)
        }
    }
    
    /**
     Ethereum: Creates new message call transaction or a contract creation for signed transactions.
     sendRawTransaction() requires that the transaction be already signed and serialized. So it requires extra serialization steps to use, but enables you to broadcast transactions on hosted nodes. There are other reasons that you might want to use a local key, of course. All of them would require using sendRawTransaction().
     */
    public static func sendRawTransaction(account: Account, transaction: Transaction, completion: @escaping (String?, JSONRPCError?) -> Void) {
        
        self.getTransactionCount(for: account.address) { nonce, error in
            
            guard error == nil, let nonce = nonce else {
                completion(nil, error)
                return
            }
            
            var unsignedTransaction = transaction
            
            unsignedTransaction.chainID = provider.node.network.chainID

            unsignedTransaction.nonce = nonce
            
            guard let signedTransaction = try? account.sign(transaction: unsignedTransaction) else {
                completion(nil, .errorSigningTransaction)
                return
            }
            
            guard let bytes = signedTransaction.rawData else {
                completion(nil, .errorSigningTransaction)
                return
            }
            
            let signedTransactionHash = String(bytes: bytes).addHexPrefix()
            
            let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .sendRawTransaction, params: [signedTransactionHash], id: 8)
            
            guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
                completion(nil, .errorEncodingJSONRPC)
                return
            }
            
            provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
                
                guard let data = data, error == nil else {
                    completion(nil, .nilResponse)
                    return
                }
                
                if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                    completion(nil, .ethereumError(ethereumError.error))
                    return
                }
                
                guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                    completion(nil, .errorDecodingJSONRPC)
                    return
                }
                
                let transactionHash = jsonRPCResponse.result
                
                completion(transactionHash, nil)
            }
        }
    }
    
    /**
     Ethereum: Executes a new message call immediately without creating a transaction on the block chain. Primarily is used on smart contracts
     */
    public static func call(transaction: Transaction, block: String = "latest", completion: @escaping (String?, JSONRPCError?) -> Void) {
        
        
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
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .call, params: params, id: 10)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
//        print(try? JSONSerialization.jsonObject(with: jsonRPCData, options: []))
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                completion(nil, .ethereumError(ethereumError.error))
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            let responseData = jsonRPCResponse.result
            
            completion(responseData, nil)
        }
    }
    
    /**
     Ethereum: Generates and returns an estimate of how much gas is necessary to allow the transaction to complete. The transaction will not be added to the blockchain. Note that the estimate may be significantly more than the amount of gas actually used by the transaction, for a variety of reasons including EVM mechanics and node performance.
     */
    public static func estimateGas(for transaction: Transaction, block: String = "latest", completion: @escaping (String?, JSONRPCError?) -> Void) {
        
        
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
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .estimateGas, params: params, id: 10)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                completion(nil, .ethereumError(ethereumError.error))
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            let hexValue = jsonRPCResponse.result.removeHexPrefix()
            
            guard let value = BigInt(hexValue, radix: 16) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            completion(value.description, nil)
        }
    }
    
    /**
     Ethereum: Returns information about a block by hash.
     */
    public static func getBlockByHash(hash: String, completion: @escaping (Block?, JSONRPCError?) -> Void) {
        
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
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .getBlockByHash, params: params, id: 10)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                completion(nil, .ethereumError(ethereumError.error))
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<Block>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            let block = jsonRPCResponse.result
            
            completion(block, nil)
        }
    }
    
    /**
     Ethereum: Returns information about a block by block number.
     */
    public static func getBlockByNumber(blockNumber: Int, completion: @escaping (Block?, JSONRPCError?) -> Void) {
        
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
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .getBlockByNumber, params: params, id: 10)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                completion(nil, .ethereumError(ethereumError.error))
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<Block>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            let block = jsonRPCResponse.result
            
            completion(block, nil)
        }
    }
    
    /**
     Ethereum: Returns the information about a transaction requested by transaction hash.
     */
    public static func getTransactionByHash(transactionHash: String, completion: @escaping (Transaction?, JSONRPCError?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .getTransactionByHash, params: [transactionHash], id: 10)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                completion(nil, .ethereumError(ethereumError.error))
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<Transaction>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            let transaction = jsonRPCResponse.result
            
            completion(transaction, nil)
        }
    }
    
    /**
     Ethereum: Returns information about a transaction by block hash and transaction index position.
     */
    public static func getTransactionByBlockHashAndIndex(blockHash: String, index: Int, completion: @escaping (Transaction?, JSONRPCError?) -> Void) {
        
        let hexIndex = String(index, radix: 16).addHexPrefix()
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .getTransactionByBlockHashAndIndex, params: [blockHash, hexIndex], id: 10)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                completion(nil, .ethereumError(ethereumError.error))
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<Transaction?>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            if let transaction = jsonRPCResponse.result {
                completion(transaction, nil)
            } else {
                completion(nil, .noResult)
            }
        }
    }
    
    /**
     Ethereum: Returns information about a transaction by block number and transaction index position.
     */
    public static func getTransactionByBlockNumberAndIndex(blockNumber: Int, index: Int, completion: @escaping (Transaction?, JSONRPCError?) -> Void) {
        
        let hexBlockNumber = String(blockNumber, radix: 16).addHexPrefix()
        
        let hexIndex = String(index, radix: 16).addHexPrefix()
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .getTransactionByBlockNumberAndIndex, params: [hexBlockNumber, hexIndex], id: 10)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                completion(nil, .ethereumError(ethereumError.error))
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<Transaction?>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            if let transaction = jsonRPCResponse.result {
                completion(transaction, nil)
            } else {
                completion(nil, .noResult)
            }
        }
    }
    
    /**
     Ethereum: Returns the receipt of a transaction by transaction hash.
     */
    public static func getTransactionReceipt(transactionHash: String, completion: @escaping (Receipt?, JSONRPCError?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .getTransactionReceipt, params: [transactionHash], id: 10)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                completion(nil, .ethereumError(ethereumError.error))
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<Receipt>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            let receipt = jsonRPCResponse.result
            
            completion(receipt, nil)
        }
    }
    
    /**
     Ethereum: Returns information about a uncle of a block by hash and uncle index position.
     */
    public static func getUncleByBlockHashAndIndex(blockHash: String, index: Int, completion: @escaping (Block?, JSONRPCError?) -> Void) {
        
        let hexIndex = String(index, radix: 16).addHexPrefix()
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .getUncleByBlockHashAndIndex, params: [blockHash, hexIndex], id: 10)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                completion(nil, .ethereumError(ethereumError.error))
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<Block?>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            if let block = jsonRPCResponse.result {
                completion(block, nil)
            } else {
                completion(nil, .noResult)
            }
        }
    }
    
    /**
     Ethereum: Returns information about a uncle of a block by number and uncle index position.
     */
    public static func getUncleByBlockNumberAndIndex(blockNumber: Int, index: Int, completion: @escaping (Block?, JSONRPCError?) -> Void) {
        
        let hexBlockNumber = String(blockNumber, radix: 16).addHexPrefix()
        
        let hexIndex = String(index, radix: 16).addHexPrefix()
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: .getUncleByBlockNumberAndIndex, params: [hexBlockNumber, hexIndex], id: 10)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { data, error in
            
            guard let data = data, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            if let ethereumError = try? JSONDecoder().decode(JSONRPCResponseError<JSONRPCErrorResult>.self, from: data) {
                completion(nil, .ethereumError(ethereumError.error))
                return
            }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<Block?>.self, from: data) else {
                completion(nil, .errorDecodingJSONRPC)
                return
            }
            
            if let block = jsonRPCResponse.result {
                completion(block, nil)
            } else {
                completion(nil, .noResult)
            }
        }
    }
    
    /**
     Ethereum: Returns an array of all logs matching a given filter object.
     */
    public static func getLogs() {
        
    }
    
    // MARK: TO LATER
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
