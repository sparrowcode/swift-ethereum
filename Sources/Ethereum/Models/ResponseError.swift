import Foundation

public enum ResponseError: Error {
    case errorEncodingJSONRPC
    case errorDecodingJSONRPC
    case nilResponse
    case noResult
    case errorSigningTransaction
    case ethereumError(JSONRPCErrorResult)
    case invalidAmount
}

