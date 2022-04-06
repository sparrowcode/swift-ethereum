import Foundation

struct JSONRPCResponse<T: Codable>: Codable {
    let id: Int
    let jsonrpc: String
    let result: T
}
