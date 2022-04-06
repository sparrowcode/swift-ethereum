import Foundation
import SwiftKeccak
import BigInt

// do we need a separate structure for signed transactions?
// 3 allowed structures: EIP-1559, EIP-2930 and Legacy Transaction
public struct Transaction: Codable, Signable {
    
    public let blockHash: String?
    public let blockNumber: String?
    public let from: String?
    public let gas: String?
    public let gasLimit: String?
    public let gasPrice: String?
    public var hash: String?
    public let input: Data
    public var nonce: Int?
    public let to: String?
    public let value: String?
    public var chainID: Int?
    public let v: Int?
    public let r: Data?
    public let s: Data?
    
    // MARK: - RLP Properties
    private var gasLimitBigUInt: BigUInt? {
        (gasLimit != nil) ? BigUInt(gasLimit!, radix: 10) : nil
    }
    
    private var gasPriceBigUInt: BigUInt? {
        (gasPrice != nil) ? BigUInt(gasPrice!, radix: 10) : nil
    }
    
    private var valueBigUInt: BigUInt? {
        (value != nil) ? BigUInt(value!, radix: 10) : nil
    }
    
    public init(
         gasLimit: String,
         gasPrice: String,
         input: Data = Data(),
         nonce: Int? = nil,
         to: String,
         value: String,
         chainID: Int) throws {
        self.blockHash = nil
        self.blockNumber = nil
        self.from = nil
        self.gas = nil
        self.gasLimit = gasLimit
        self.gasPrice = gasPrice
        self.hash = nil
        self.input = input
        self.nonce = nonce
        self.to = to
        self.value = value
        self.chainID = chainID
        self.v = nil
        self.r = nil
        self.s = nil
    }
    
    public init(transaction: Transaction, v: Int, r: Data, s: Data) {
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
            let array: [Any?] = [nonce, gasPriceBigUInt, gasLimitBigUInt, to, valueBigUInt, input, v, r, s]
            return RLP.encode(array)
        } else {
            let array: [Any?] = [nonce, gasPriceBigUInt, gasLimitBigUInt, to, valueBigUInt, input, chainID, 0, 0]
            return RLP.encode(array)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
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
        case chainId
        case v
        case r
        case s
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let decodeHexBigUInt = { (key: CodingKeys) throws -> String? in
            let decodedString = try container.decode(String.self, forKey: key)
            let decodedBigUInt = BigUInt(decodedString, radix: 16)
            return decodedBigUInt?.description
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
        self.gas = try? decodeHexBigUInt(.gas)
        self.gasLimit = try? decodeHexBigUInt(.gasLimit)
        self.gasPrice = try? decodeHexBigUInt(.gasPrice)
        self.hash = try? container.decode(String.self, forKey: .hash)
        self.input = (try? decodeData(.input)) ?? Data()
        self.nonce = try? decodeHexInt(.nonce)
        self.to = try? container.decode(String.self, forKey: .to)
        self.value = try? decodeHexBigUInt(.value)
        self.chainID = try? container.decode(Int.self, forKey: .chainId)
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
