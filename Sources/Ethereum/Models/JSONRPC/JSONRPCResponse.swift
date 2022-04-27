import Foundation

struct JSONRPCResponse<D: Decodable>: Decodable {
    let id: Int
    let jsonrpc: String
    let result: D
}

struct JSONRPCResponseError: Decodable {
    let id: Int
    let jsonrpc: String
    let error: JSONRPCErrorResult
}

public struct JSONRPCErrorResult: Decodable {
    public let code: Int
    public let message: String
}
