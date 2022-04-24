import Foundation
import SwiftKeccak
import BigInt

protocol SmartContractProtocol {
    
    init(abi: String, address: String)
    
    // MARK: - write an extension with default realisation
    func method<T: Codable>(name: String, params: T) -> Transaction
    
    var allMethods: [String] { get }
    
    var allEvents: [String] {get}
    
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
    let value: SmartContractValue
}

public enum SmartContractValue {
    case address(value: String)
    
    case uint(bits: UInt16 = 256, value: BigUInt)
    
    case int(bits: UInt16 = 256, value: BigInt)
    
    case bool(value: Bool)
    case bytes(value: Data)
    case string(value: String)
    
    var stringValue: String {
        switch self {
        case .address(_):
            return "address"
        case .uint(bits: let bits, value: _):
            return "uint\(bits)"
        case .int(bits: let bits, value: _):
            return "int\(bits)"
        case .bool(_):
            return "bool"
        case .bytes(_):
            return "bytes"
        case .string(_):
            return "string"
        }
    }
    
    var isDynamic: Bool {
        switch self {
        case .address(_):
            return false
        case .uint(_, _):
            return false
        case .int(_, _):
            return false
        case .bool(_):
            return false
        case .bytes(_):
            return true
        case .string(_):
            return true
        }
    }
}

