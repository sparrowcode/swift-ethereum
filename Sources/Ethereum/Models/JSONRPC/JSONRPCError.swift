import Foundation

enum JSONRPCError: Error {
    case errorEncodingJSONRPC
    case errorDecodingJSONRPC
    case errorConvertingFromHex
    case nilResponse
    case noResult
    case errorSigningTransaction
    case ethereumError(JSONRPCErrorResult)
}

public struct JSONRPCErrorResult: Codable {
    public let code: Int
    public let message: String
}
