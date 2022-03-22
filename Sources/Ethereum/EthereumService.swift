import Foundation

public final class EthereumService {
    
    public static var provider = Provider(node: Node(url: URL(string: "")!))

    // MARK: - Original Methods
    /**
     Ethereum: Returns the current ethereum protocol version
     */
    public static func protocolVersion() {
        
    }
    
//    /**
//     Ethereum: Returns an object with data about the sync status or false. Object|Boolean, An object with sync status data or FALSE, when not syncing: startingBlock: QUANTITY - The block at which the import started (will only be reset, after the sync reached his head) currentBlock: QUANTITY - The current block, same as eth_blockNumber highestBlock: QUANTITY - The estimated highest block
//     */
//    public static func syncing() {
//
//    }
    
//    /**
//     Ethereum: Returns the client coinbase address.
//     */
//    public static func coinbase() {
//
//    }
//
//    /**
//     Ethereum: Returns true if client is actively mining new blocks.
//     */
//    public static func mining() {
//
//    }
//
//    /**
//     Ethereum: Returns the number of hashes per second that the node is mining with.
//     */
//    public static func hashrate() {
//
//    }
    
    /**
     Ethereum: Returns the current price per gas in wei.
     */
    public static func gasPrice() {
        
    }
    
//    /**
//     Ethereum: Returns a list of addresses owned by client.
//     */
//    public static func accounts() {
//
//    }
    
    /**
     Ethereum: Returns the number of most recent block.
     */
    public static func blockNumber() {
        
    }
    
    /**
     Ethereum: Returns the balance of the account of given address.
     */
    public static func getBalance() {
        
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
     Ethereum: The sign method calculates an Ethereum specific signature with: sign(keccak256("\x19Ethereum Signed Message:\n" + len(message) + message))).
     By adding a prefix to the message makes the calculated signature recognisable as an Ethereum specific signature. This prevents misuse where a malicious DApp can sign arbitrary data (e.g. transaction) and use the signature to impersonate the victim.
     ??
     
    public static func sign() {
        
    }*/
    
    /**
     Ethereum: Creates new message call transaction or a contract creation, if the data field contains code.
     sendTransaction() only supports sending unsigned transactions. In order to use it, your node must be managing your private key. Since the node must manage your key, you must not use it with a hosted node.
     
    public static func sendTransaction() {
        
    }*/
    
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
    
    /*
    /**
     Ethereum: Returns a list of available compilers in the client.
     */
    public static func getCompilers() {
        
    }*/
    
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
    
    /**
     Ethereum: Returns an array of all logs matching a given filter object.
     */
    public static func getLogs() {
        
    }
    
    /*
    /**
     Ethereum: Returns the hash of the current block, the seedHash, and the boundary condition to be met ("target").
     */
    public static func getWork() {
        
    }
    
    /**
     Ethereum: Used for submitting a proof-of-work solution.
     */
    public static func submitWork() {
        
    }
    
    /**
     Ethereum: Used for submitting mining hashrate.
     */
    public static func submitHashrate() {
        
    }*/
}
