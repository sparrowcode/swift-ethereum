import Foundation

public enum JSONRPCError: Error {
    case errorEncodingJSONRPC
    case errorDecodingJSONRPC
    case errorConvertingFromHex
    case nilResponse
    case noResult
    case errorSigningTransaction
}
