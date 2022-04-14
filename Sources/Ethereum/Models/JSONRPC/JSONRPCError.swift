import Foundation

public enum JSONRPCError: Error {
    case errorEncodingJSONRPC
    case errorDecodingJSONRPC
    case errorConvertingFromHex
    case nilResponse
    case noResult
    case errorSigningTransaction
    case ethereumError(JSONRPCErrorResult)
}

public struct JSONRPCErrorResult: Codable {
    let code: Int
    let message: String
}
