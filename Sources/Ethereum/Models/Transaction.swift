import Foundation
import BigInt

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
    public let to: String
    public let value: String?
    public var chainID: Int?
    public let signature: Signature?
    
    // MARK: - RLP Properties
    private let gasLimitBigUInt: BigUInt?
    
    private let gasPriceBigUInt: BigUInt?
    
    private let valueBigUInt: BigUInt?
    
    public init(
        from: String? = nil,
        gasLimit: String? = nil,
        gasPrice: String? = nil,
        input: Data = Data(),
        nonce: Int? = nil,
        to: String,
        value: String? = nil) throws {
            self.blockHash = nil
            self.blockNumber = nil
            self.from = from
            self.gas = nil
            self.gasLimit = gasLimit
            self.gasPrice = gasPrice
            self.hash = nil
            self.input = input
            self.nonce = nonce
            self.to = to.removeHexPrefix().lowercased()
            self.value = value
            self.chainID = nil
            self.signature = nil
            
            self.gasLimitBigUInt = (gasLimit != nil) ? BigUInt(gasLimit!, radix: 10) : nil
            self.gasPriceBigUInt = (gasPrice != nil) ? BigUInt(gasPrice!, radix: 10) : nil
            self.valueBigUInt = (value != nil) ? BigUInt(value!, radix: 10) : nil
            
        }
    
    init(transaction: Transaction, signature: Signature) throws {
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
        self.signature = signature
        
        self.gasLimitBigUInt = (gasLimit != nil) ? BigUInt(gasLimit!, radix: 10) : nil
        self.gasPriceBigUInt = (gasPrice != nil) ? BigUInt(gasPrice!, radix: 10) : nil
        self.valueBigUInt = (value != nil) ? BigUInt(value!, radix: 10) : nil
    }
    
    public var rlpData: Data? {
        if let signature = signature {
            
            let array: [RLPEncodable?] = [nonce,
                                 gasPriceBigUInt,
                                 gasLimitBigUInt,
                                 to,
                                 valueBigUInt,
                                 input,
                                 signature.v,
                                 signature.r,
                                 signature.s]
            
            let arrayRLP = array.compactMap { $0 }
            
            return RLPEncoder.encode(arrayRLP)
            
        } else {
            
            let array: [RLPEncodable?] = [nonce,
                                 gasPriceBigUInt,
                                 gasLimitBigUInt,
                                 to,
                                 valueBigUInt,
                                 input,
                                 chainID,
                                 0,
                                 0]
            
            let arrayRLP: [RLPEncodable] = array.compactMap { $0 }
            
            return RLPEncoder.encode(arrayRLP)
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
        
        let decodeHexBigUInt = { (key: CodingKeys) throws -> BigUInt? in
            let decodedString = try container.decode(String.self, forKey: key)
            let decodedBigUInt = BigUInt(decodedString, radix: 16)
            return decodedBigUInt
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
        self.from = (try? container.decode(String.self, forKey: .from)) ?? ""
        self.gas = try? decodeHexBigUInt(.gas)?.description
        self.gasLimit = (try? decodeHexBigUInt(.gasLimit)?.description) ?? "0"
        self.gasPrice = (try? decodeHexBigUInt(.gasPrice)?.description) ?? "0"
        self.hash = try? container.decode(String.self, forKey: .hash)
        self.input = (try? decodeData(.input)) ?? Data()
        self.nonce = try? decodeHexInt(.nonce)
        self.to = (try? container.decode(String.self, forKey: .to)) ?? "0x"
        self.value = (try? decodeHexBigUInt(.value)?.description) ?? "0"
        self.chainID = (try? container.decode(Int.self, forKey: .chainId)) ?? 1
        
        if let v = try? decodeHexInt(.v), let r = try? decodeData(.r), let s = try? decodeData(.s) {
            self.signature = Signature(v: v, r: r, s: s)
        } else {
            self.signature = nil
        }
        
        self.gasLimitBigUInt = (try? decodeHexBigUInt(.gasLimit)) ?? nil
        self.gasPriceBigUInt = (try? decodeHexBigUInt(.gasPrice)) ?? nil
        self.valueBigUInt = (try? decodeHexBigUInt(.value)) ?? nil
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let encodeBigUInt = { (value: BigUInt?, key: CodingKeys) throws -> Void in
            if let value = value {
                let encodedValue = String(value, radix: 16).addHexPrefix()
                try container.encode(encodedValue, forKey: key)
            }
            
        }
        
        let encodeOptionalString = { (value: String?, key: CodingKeys) throws -> Void in
            if let value = value {
                try container.encode(value.addHexPrefix(), forKey: key)
            }
        }
        
        let encodeData = { (value: Data, key: CodingKeys) throws -> Void in
            
            if value == Data() {
                try container.encode("", forKey: key)
            } else {
                let encodedValue = String(bytes: value).addHexPrefix()
                try container.encode(encodedValue, forKey: key)
            }
        }
        
        try? encodeOptionalString(to, .to)
        try? encodeOptionalString(from, .from)
        try? encodeData(input, .input)
        try? encodeBigUInt(valueBigUInt, .value)
        try? encodeBigUInt(gasPriceBigUInt, .gasPrice)
        try? encodeBigUInt(gasLimitBigUInt, .gas)
    }
    
}

//240
