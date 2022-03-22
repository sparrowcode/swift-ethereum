import Foundation

struct JSONRPCRequest<T: Codable>: Codable {
    let jsonrpc: String
    let method: String
    let params: T
    let id: Int
    
    init(jsonrpc: String, method: EthereumService.EthereumMethods, params: T, id: Int) {
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
