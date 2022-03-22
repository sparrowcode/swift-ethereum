import Foundation

public enum EthereumService {
    
    enum EthereumMethods: String {
        case getBalance = "eth_getBalance"
    }
    
    public enum EthereumServiceError: Error {
        case errorEncodingJSONRPC
        case errorDecodingJSONRPC
        case errorConvertingFromHex
    }
    
    public static var provider = Provider(node: DefaultNodes.mainnet)

    // MARK: - Original Methods
    /**
     Ethereum: Returns the current ethereum protocol version
     */
    public static func protocolVersion() {
        
    }
    
    /**
     Ethereum: Returns the current price per gas in wei.
     */
    public static func gasPrice() {
        
    }
    
    /**
     Ethereum: Returns the number of most recent block.
     */
    public static func blockNumber() {
        
    }
    
    /**
     Ethereum: Returns the balance of the account of given address.
     */
    public static func getBalance(for address: String, completion: @escaping (EthereumServiceError?, Int?) -> Void) {
        
        let jsonRPC = JSONRPCRequest(jsonrpc: "2.0", method: EthereumMethods.getBalance, params: [address, "latest"], id: 1)
        
        guard let jsonRPCData = try? JSONEncoder().encode(jsonRPC) else {
            completion(EthereumServiceError.errorEncodingJSONRPC, nil)
            return
        }
        
        provider.sendRequest(jsonRPCData: jsonRPCData) { error, data in
            
            guard let data = data else { return }
            
            guard let jsonRPCResponse = try? JSONDecoder().decode(JSONRPCResponse<String>.self, from: data) else {
                completion(EthereumServiceError.errorDecodingJSONRPC, nil)
                return
            }
            
            let hexidecimal = jsonRPCResponse.result.replacingOccurrences(of: "0x", with: "")
            
            guard let balance = Int(hexidecimal, radix: 16) else { completion(EthereumServiceError.errorConvertingFromHex, nil)
                return
            }
            
            completion(nil, balance)
        }
    }
    
    /**
     Ethereum: retrieves raw state storage for a smart contract;
     */
    public static func getStorageAt() {
        
    }
    
    /**
     Ethereum: Returns the number of transactions sent from an address.
     */
    public static func getTransactionCount() {
        
    }
    
    /**
     Ethereum: Returns the number of transactions in a block from a block matching the given block hash.
     */
    public static func getBlockTransactionCountByHash() {
        
    }
    
    /**
     Ethereum: Returns the number of transactions in a block matching the given block number.
     */
    public static func getBlockTransactionCountByNumber() {
        
    }
    
    /**
     Ethereum: Returns the compiled solidity code
     */
    public static func getCode() {
        
    }
    
    /**
     Ethereum: Creates new message call transaction or a contract creation for signed transactions.
     sendRawTransaction() requires that the transaction be already signed and serialized. So it requires extra serialization steps to use, but enables you to broadcast transactions on hosted nodes. There are other reasons that you might want to use a local key, of course. All of them would require using sendRawTransaction().
     */
    public static func sendRawTransaction() {
        
    }
    
    /**
     Ethereum: Executes a new message call immediately without creating a transaction on the block chain. Primarly is used on smart contracts
     */
    public static func call() {
        
    }
    
    /**
     Ethereum: Generates and returns an estimate of how much gas is necessary to allow the transaction to complete. The transaction will not be added to the blockchain. Note that the estimate may be significantly more than the amount of gas actually used by the transaction, for a variety of reasons including EVM mechanics and node performance.
     */
    public static func estimateGas() {
        
    }
    
    /**
     Ethereum: Returns information about a block by hash.
     */
    public static func getBlockByHash() {
        
    }
    
    /**
     Ethereum: Returns information about a block by block number.
     */
    public static func getBlockByNumber() {
        
    }
    
    /**
     Ethereum: Returns the information about a transaction requested by transaction hash.
     */
    public static func getTransactionByHash() {
        
    }
    
    /**
     Ethereum: Returns information about a transaction by block hash and transaction index position.
     */
    public static func getTransactionByBlockHashAndIndex() {
        
    }
    
    /**
     Ethereum: Returns information about a transaction by block number and transaction index position.
     */
    public static func getTransactionByBlockNumberAndIndex() {
        
    }
    
    /**
     Ethereum: Returns the receipt of a transaction by transaction hash.
     */
    public static func getTransactionReceipt() {
        
    }
    
    /**
     Ethereum: Returns information about a uncle of a block by hash and uncle index position.
     */
    public static func getUncleByBlockHashAndIndex() {
        
    }
    
    /**
     Ethereum: Returns information about a uncle of a block by number and uncle index position.
     */
    public static func getUncleByBlockNumberAndIndex() {
        
    }
    
    /**
     Ethereum: Returns compiled LLL code.
     */
    public static func compileLLL() {
        
    }
    
    /**
     Ethereum: Returns compiled solidity code.
     */
    public static func compileSolidity() {
        
    }
    
    /**
     Ethereum: Returns compiled serpent code.
     */
    public static func compileSerpent() {
        
    }
    
    /**
     Ethereum: Returns an array of all logs matching a given filter object.
     */
    public static func getLogs() {
        
    }
    
    // TO LATER
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
