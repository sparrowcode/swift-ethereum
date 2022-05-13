import Foundation

struct JSONRPCRequest<T: Encodable>: Encodable {
    
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
