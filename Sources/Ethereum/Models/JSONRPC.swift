import Foundation

struct JSONRPCRequest<T: Codable>: Codable {
    let jsonrpc: String
    let method: String
    let params: T
    let id: Int
    
    init(jsonrpc: String, method: JSONRPCMethod, params: T, id: Int) {
        self.jsonrpc = jsonrpc
        self.method = method.rawValue
        self.params = params
        self.id = id
    }
}

struct JSONRPCResponse<T: Codable>: Codable {
    let id: Int
    let jsonrpc: String
    let result: T
}

enum JSONRPCMethod: String {
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
}

public enum JSONRPCError: Error {
    case errorEncodingJSONRPC
    case errorDecodingJSONRPC
    case errorConvertingFromHex
    case nilResponse
}
