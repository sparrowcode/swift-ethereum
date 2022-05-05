import Foundation

public enum JSONRPCError: Error {
    case errorEncodingJSONRPC
    case errorDecodingJSONRPC
    case errorConvertingFromHex
    case nilResponse
    case noResult
    case errorSigningTransaction
    case ethereumError(JSONRPCErrorResult)
    case errorEncodingToABI
    case errorDecodingFromABI
    case invalidAmount
    case providerIsNil
}


