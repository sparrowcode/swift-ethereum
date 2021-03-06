import Foundation

public enum JSONRPCMethod: String {
    
    case gasPrice = "eth_gasPrice"
    case blockNumber = "eth_blockNumber"
    case getBalance = "eth_getBalance"
    case getStorageAt = "eth_getStorageAt"
    case getTransactionCount = "eth_getTransactionCount"
    case getBlockTransactionCountByHash = "eth_getBlockTransactionCountByHash"
    case getBlockTransactionCountByNumber = "eth_getBlockTransactionCountByNumber"
    case getTransactionByHash = "eth_getTransactionByHash"
    case getCode = "eth_getCode"
    case version = "net_version"
    case listening = "net_listening"
    case peerCount = "net_peerCount"
    case clientVersion = "web3_clientVersion"
    case getBlockByHash = "eth_getBlockByHash"
    case getBlockByNumber = "eth_getBlockByNumber"
    case getUncleByBlockNumberAndIndex = "eth_getUncleByBlockNumberAndIndex"
    case getUncleByBlockHashAndIndex = "eth_getUncleByBlockHashAndIndex"
    case getTransactionByBlockHashAndIndex = "eth_getTransactionByBlockHashAndIndex"
    case getTransactionByBlockNumberAndIndex = "eth_getTransactionByBlockNumberAndIndex"
    case getTransactionReceipt = "eth_getTransactionReceipt"
    case sendRawTransaction = "eth_sendRawTransaction"
    case estimateGas = "eth_estimateGas"
    case call = "eth_call"
}
