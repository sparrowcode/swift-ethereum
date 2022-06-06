import Foundation
import BigInt

public indirect enum SmartContractValueType {
    
    case address
    
    case uint(_ bits: UInt16 = 256)
    
    case int(_ bits: UInt16 = 256)
    
    case bool 
    
    case string
    
    case array(type: SmartContractValueType, length: UInt? = nil)
    
    case bytes(_ length: UInt? = nil)
    
    case fixed(_ bits: UInt16 = 128, _ length: UInt8 = 18)
    
    case ufixed(_ bits: UInt16 = 128, _ length: UInt8 = 18)
    
    case tuple([SmartContractValueType])
    
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
            
        case .bytes(length: let length):
            if let length = length {
                return "bytes\(length)"
            }
            return "bytes"
            
        case .string:
            return "string"
            
        case .array(type: let type, length: let length):
            if let length = length {
                return type.stringValue + "[\(length)]"
            }
            return type.stringValue + "[]"
            
        case .fixed(_: let bits, _: let length):
            return "fixed\(bits)x\(length)"
            
        case .ufixed(_: let bits, _: let length):
            return "ufixed\(bits)x\(length)"
            
        case .tuple(let types):
            let typesString = types.map { $0.stringValue }.joined(separator: ",")
            return "(\(typesString))"
        }
    }
    
    var isDynamic: Bool {
        switch self {
        case .string:
            return true
        case .array(_, let length):
            return length == nil
        case .bytes(let length):
            return length == nil
        case .tuple(let types):
            return types.count > 1 || types.filter { $0.isDynamic }.count > 0
        default:
            return false
        }
    }
    
    var sequenceElementType: SmartContractValueType? {
        switch self {
        case .array(let type, _):
            return type
        default:
            return nil
        }
    }
}
