import Foundation
import BigInt

public enum ABIDecoder {
    
    enum ABIDecoderError: Error {
        case errorDecodingInt
        case errorDecodingString
    }
    
    static func decode(_ value: String, to type: SmartContractValueType) throws -> Any {
        
        let bytes = try value.bytes
        
        let data = Data(bytes)
        
        return try decode(data, to: type)
        
    }

    static func decode(_ value: Data, to type: SmartContractValueType) throws -> ABIDecodable {
        
        switch type {
        case .address:
            return try decodeAddress(from: value)
        case .uint(_):
            return try decodeUInt(from: value)
        case .int(_):
            return try decodeInt(from: value)
        case .bool:
            return try decodeBool(from: value)
        case .string:
            return try decodeString(from: value)
        case .array(_, _):
            return [String]()
        case .bytes(_):
            return try decodeBytes(from: value)
        case .fixed(_, _):
            return Data()
        case .ufixed(_, _):
            return Data()
        case .tuple(_):
            return [String]()
        }
        
    }
    
    static func decodeAddress(from value: Data) throws -> EthereumAddress {
        
        let addressData = value.subdata(in: 12..<32)
        
        let stringValue = "0x" + String(bytes: addressData)
        
        let ethereumAddress = EthereumAddress(stringValue)
        
        return ethereumAddress
    }
    
    static func decodeUInt(from value: Data) throws -> BigUInt {
        
        let uintData = value.removeLeadingZeros
        
        let uint = BigUInt(uintData)
        
        return uint
    }
    
    static func decodeInt(from value: Data) throws -> BigInt {
        
        let intData = value.removeLeadingZeros
        
        // some bug in BigInt in init with Data which results to wrong result
        let stringValue = String(bytes: intData)
        
        guard let int = BigInt(stringValue, radix: 16) else {
            throw ABIDecoderError.errorDecodingInt
        }
        
        return int
    }
    
    static func decodeBool(from value: Data) throws -> Bool {
        
        let boolData = value.removeLeadingZeros
        
        if boolData.isEmpty {
            return false
        } else {
            return true
        }
        
    }
    
    static func decodeString(from value: Data) throws -> String {
        
        let utf8Data = value.subdata(in: 32..<64).removeTrailingZeros
        
        guard let string = String(data: utf8Data, encoding: .utf8) else {
            throw ABIDecoderError.errorDecodingString
        }
        
        return string
    }
    
    static func decodeArray(from value: Data) throws -> [Any] {
        return [Any]()
    }
    
    static func decodeBytes(from value: Data) throws -> Data {
        
        if value.count <= 32 {
            return value.removeTrailingZeros
        } else {
            let bytesData = value.subdata(in: 32..<64)
            return bytesData.removeTrailingZeros
        }
    }
}

