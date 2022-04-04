import Foundation
import SwiftKeccak
import BigInt

// do we need a separate structure for signed transactions?
// 3 allowed structures: EIP-1559, EIP-2930 and Legacy Transaction
public struct Transaction: Codable, Signable {
    
    let blockHash: String?
    let blockNumber: String?
    let from: String?
    let gas: BigUInt?
    let gasLimit: BigUInt?
    let gasPrice: BigUInt?
    var hash: String?
    let input: Data
    var nonce: Int?
    let to: String
    let value: BigUInt?
    var chainID: Int?
    let v: Int?
    let r: Data?
    let s: Data?
    
    init(blockHash: String? = nil,
         blockNumber: String? = nil,
         from: String? = nil,
         gas: String? = nil,
         gasLimit: String,
         gasPrice: String,
         hash: String? = nil,
         input: Data = Data(),
         nonce: Int? = nil,
         to: String,
         value: String,
         chainID: Int,
         v: Int? = nil,
         r: Data? = nil,
         s: Data? = nil) throws {
        self.blockHash = blockHash
        self.blockNumber = blockNumber
        self.from = from
        self.gas = (gas != nil) ? BigUInt(gas!, radix: 10) : nil
        self.gasLimit = BigUInt(gasLimit, radix: 10)
        self.gasPrice = BigUInt(gasPrice, radix: 10)
        self.hash = hash
        self.input = input
        self.nonce = nonce
        self.to = to
        self.value = BigUInt(value, radix: 10)
        self.chainID = chainID
        self.v = v
        self.r = r
        self.s = s
    }
    
    init(transaction: Transaction, v: Int, r: Data, s: Data) {
        self.blockHash = transaction.blockHash
        self.blockNumber = transaction.blockNumber
        self.from = transaction.from
        self.gas = transaction.gas
        self.gasLimit = transaction.gasLimit
        self.gasPrice = transaction.gasPrice
        self.hash = transaction.hash
        self.input = transaction.input
        self.nonce = transaction.nonce
        self.to = transaction.to
        self.value = transaction.value
        self.chainID = transaction.chainID
        self.v = v
        self.r = r
        self.s = s
    }
    
    public var rawData: Data? {
        if let v = v, let r = r, let s = s {
            let array: [Any?] = [nonce, gasPrice, gasLimit, to, value, input, v, r, s]
            return RLP.encode(array)
        } else {
            let array: [Any?] = [nonce, gasPrice, gasLimit, to, value, input, chainID, 0, 0]
            return RLP.encode(array)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case blockHash
        case blockNumber
        case from
        case gas
        case gasLimit
        case gasPrice
        case hash
        case input
        case nonce
        case to
        case value
        case chainID
        case v
        case r
        case s
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let decodeHexUInt = { (key: CodingKeys) throws -> BigUInt? in
            let decodedString = try container.decode(String.self, forKey: key)
            return BigUInt(decodedString, radix: 16)
        }
        
        let decodeHexInt = { (key: CodingKeys) throws -> Int? in
            let decodedString = try container.decode(String.self, forKey: key)
            return Int(decodedString, radix: 16)
        }
        
        let decodeData = { (key: CodingKeys) throws -> Data? in
            let decodedString = try container.decode(String.self, forKey: key)
            return try Data(decodedString.bytes)
        }
        
        self.blockHash = try? container.decode(String.self, forKey: .blockHash)
        self.blockNumber = try? container.decode(String.self, forKey: .blockNumber)
        self.from = try? container.decode(String.self, forKey: .from)
        self.gas = try? decodeHexUInt(.gas)
        self.gasLimit = try? decodeHexUInt(.gasLimit)
        self.gasPrice = try? decodeHexUInt(.gasPrice)
        self.hash = try? container.decode(String.self, forKey: .hash)
        self.input = (try? decodeData(.input)) ?? Data()
        self.nonce = try? decodeHexInt(.nonce)
        self.to = try container.decode(String.self, forKey: .to)
        self.value = try? decodeHexUInt(.value)
        self.chainID = nil
        self.v = try? decodeHexInt(.v)
        self.r = try? decodeData(.r)
        self.s = try? decodeData(.s)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(to, forKey: .to)
        try? container.encode(from, forKey: .from)
        try? container.encode(input, forKey: .input)
        try? container.encode(value, forKey: .value)
        try? container.encode(gasPrice, forKey: .gasPrice)
        try? container.encode(gasLimit, forKey: .gasLimit)
        try? container.encode(gas, forKey: .gas)
        try? container.encode(nonce, forKey: .nonce)
        try? container.encode(blockNumber, forKey: .blockNumber)
        try? container.encode(hash, forKey: .hash)
    }
    
}

//240
