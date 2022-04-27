import Foundation
import SwiftKeccak
import BigInt

protocol SmartContractProtocol {
    
    init(abi: String, address: String)
    
    // MARK: - write an extension with default realisation
    func method<T: Codable>(name: String, params: T) -> Transaction
    
    var allMethods: [String] { get }
    
    var allEvents: [String] { get }
    
}

extension SmartContractProtocol {
    // base realisation of smart contracts (call method)
}


public struct SmartContractMethod {
    let name: String
    let params: [SmartContractParam]
    
    var abiData: Data? {
        return try? ABIEncoder.encode(method: self)
    }
}

public struct SmartContractParam {
    let name: String
    let value: ABIEncodable
    let type: SmartContractType
}

public indirect enum SmartContractType {
    
    case address
    
    case uint(bits: UInt16 = 256)
    
    case int(bits: UInt16 = 256)
    
    case bool
    
    case bytes
    
    case string
    
    case array(type: SmartContractType)
    
    var stringValue: String {
        switch self {
        case .address:
            return "address"
        case .uint(let bits):
            return "uint\(bits)"
        case .int(let bits):
            return "int\(bits)"
        case .bool:
            return "bool"
        case .bytes:
            return "bytes"
        case .string:
            return "string"
        case .array(let type):
            return type.stringValue + "[]"
        }
    }
    
}

