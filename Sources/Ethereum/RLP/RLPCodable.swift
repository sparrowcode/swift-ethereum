import Foundation

protocol RLPEncodable {
    func encode() throws -> Data
}

protocol RLPDecodable {
    func decode() throws -> Data
}

typealias RLPCodable = RLPEncodable & RLPDecodable
