import Foundation

protocol ABIEncodable {
    func encode() throws -> Data
}

protocol ABIDecodable {
    func decode() throws -> Data
}

typealias ABICodable = ABIEncodable & ABIDecodable
