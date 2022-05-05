import Foundation
import BigInt

public enum ABIDecoder {
    
    enum ABIDecoderError: Error {
        case errorDecodingInt
        case errorDecodingString
        case noSequenceElementTypeProvidedForArray
    }
    
    static func decode(_ value: String, to type: SmartContractValueType) throws -> Any {
        
        let bytes = try value.bytes
        
        let data = Data(bytes)
        
        return try decode(data, to: [type])
    }
    
    static func decode(_ data: Data, to type: SmartContractValueType) throws -> Any {
        
        return try decode(data, to: [type])
    }
    
    static func decode(_ value: String, to types: [SmartContractValueType]) throws -> Any {
        
        let bytes = try value.bytes
        
        let data = Data(bytes)
        
        return try decode(data, to: types)
    }
    
    static func decode(_ data: Data, to types: [SmartContractValueType]) throws -> Any {
        
        var values = [Any]()
        
        for word in 0..<types.count {
            
            let currentOffset = 32 * word
            
            switch types[word].isDynamic {
                
            case true:
                let pointerStartIndex = data.index(data.startIndex, offsetBy: currentOffset)
                let pointerEndIndex = data.index(data.startIndex, offsetBy: currentOffset + 32)
                let pointerData = Data(data[pointerStartIndex..<pointerEndIndex])
                let pointer = try decodeInt(from: pointerData)
                
                let dataPartStartIndex = data.index(data.startIndex, offsetBy: pointer)
                let datapartEndIndex = data.endIndex
                let dataPart = Data(data[dataPartStartIndex..<datapartEndIndex])
                
                let value = try decode(dataPart, type: types[word])
                values.append(value)
            case false:
                let startIndex = data.index(data.startIndex, offsetBy: currentOffset)
                let endIndex = data.endIndex
                let dataPart = Data(data[startIndex..<endIndex])
                let value = try decode(dataPart, type: types[word])
                values.append(value)
            }
        }
        
        return values.count > 1 ? values : values[0]
    }
    
    // MARK: - Only for static data parts or for pointed dynamic
    static func decode(_ value: String, type: SmartContractValueType) throws -> Any {
        
        let bytes = try value.bytes
        
        let data = Data(bytes)
        
        return try decode(data, type: type)
        
    }
    
    static private func decode(_ data: Data, type: SmartContractValueType) throws -> Any {
        
        switch type {
        case .address:
            return try decodeAddress(from: data)
        case .uint(let bits):
            switch bits {
            case 8:
                return try decodeUInt8(from: data)
            case 16:
                return try decodeUInt16(from: data)
            case 32:
                return try decodeUInt32(from: data)
            case 64:
                return try decodeUInt64(from: data)
            default:
                return try decodeUInt256(from: data)
            }
            
        case .int(let bits):
            switch bits {
            case 8:
                return try decodeInt8(from: data)
            case 16:
                return try decodeInt16(from: data)
            case 32:
                return try decodeInt32(from: data)
            case 64:
                return try decodeInt64(from: data)
            default:
                return try decodeInt256(from: data)
            }
        case .bool:
            return try decodeBool(from: data)
        case .string:
            return try decodeString(from: data)
        case .array(let type, let length):
            return try decodeArray(of: type, length: length, from: data)
        case .bytes(let length):
            return try decodeBytes(from: data, length: length)
        case .fixed(_, _):
            return Data()
        case .ufixed(_, _):
            return Data()
        case .tuple(_):
            return [String]()
        }
        
    }
    
    static private func decodeAddress(from data: Data) throws -> EthereumAddress {
        
        let addressData = data.subdata(in: 12..<32)
        
        let stringValue = "0x" + String(bytes: addressData)
        
        let ethereumAddress = EthereumAddress(stringValue)
        
        return ethereumAddress
    }
    
    static private func decodeUInt8(from data: Data) throws -> UInt8 {
        
        let uintData = data.subdata(in: 0..<32).removeTrailingZeros
        
        let stringValue = String(bytes: uintData)
        
        guard let uint = UInt8(stringValue, radix: 16) else {
            throw ABIDecoderError.errorDecodingInt
        }
        
        return uint
    }
    
    static private func decodeUInt16(from data: Data) throws -> UInt16 {
        
        let uintData = data.subdata(in: 0..<32).removeTrailingZeros
        
        let stringValue = String(bytes: uintData)
        
        guard let uint = UInt16(stringValue, radix: 16) else {
            throw ABIDecoderError.errorDecodingInt
        }
        
        return uint
    }
    
    
    static private func decodeUInt32(from data: Data) throws -> UInt32 {
        
        let uintData = data.subdata(in: 0..<32).removeTrailingZeros
        
        let stringValue = String(bytes: uintData)
        
        guard let uint = UInt32(stringValue, radix: 16) else {
            throw ABIDecoderError.errorDecodingInt
        }
        
        return uint
    }
    
    static private func decodeUInt64(from data: Data) throws -> UInt64 {
        
        let uintData = data.subdata(in: 0..<32).removeTrailingZeros
        
        let stringValue = String(bytes: uintData)
        
        guard let uint = UInt64(stringValue, radix: 16) else {
            throw ABIDecoderError.errorDecodingInt
        }
        
        return uint
    }
    
    static private func decodeUInt256(from data: Data) throws -> BigUInt {
        
        let uintData = data.subdata(in: 0..<32).removeTrailingZeros
        
        let stringValue = String(bytes: uintData)
        
        guard let uint = BigUInt(stringValue, radix: 16) else {
            throw ABIDecoderError.errorDecodingInt
        }
        
        return uint
    }
    
    static private func decodeUInt(from data: Data) throws -> UInt {
        
        let uintData = data.subdata(in: 0..<32).removeTrailingZeros
        
        let stringValue = String(bytes: uintData)
        
        guard let uint = UInt(stringValue, radix: 16) else {
            throw ABIDecoderError.errorDecodingInt
        }
        
        return uint
    }
    
    static private func decodeInt8(from data: Data) throws -> Int8 {
        
        let intData = data.subdata(in: 0..<32).removeTrailingZeros
        
        let stringValue = String(bytes: intData)
        
        guard let int = Int8(stringValue, radix: 16) else {
            throw ABIDecoderError.errorDecodingInt
        }
        
        return int
    }
    
    static private func decodeInt16(from data: Data) throws -> Int16 {
        
        let intData = data.subdata(in: 0..<32).removeTrailingZeros
        
        let stringValue = String(bytes: intData)
        
        guard let int = Int16(stringValue, radix: 16) else {
            throw ABIDecoderError.errorDecodingInt
        }
        
        return int
    }
    
    static private func decodeInt32(from data: Data) throws -> Int32 {
        
        let intData = data.subdata(in: 0..<32).removeTrailingZeros
        
        let stringValue = String(bytes: intData)
        
        guard let int = Int32(stringValue, radix: 16) else {
            throw ABIDecoderError.errorDecodingInt
        }
        
        return int
    }
    
    static private func decodeInt64(from data: Data) throws -> Int64 {
        
        let intData = data.subdata(in: 0..<32).removeTrailingZeros
        
        let stringValue = String(bytes: intData)
        
        guard let int = Int64(stringValue, radix: 16) else {
            throw ABIDecoderError.errorDecodingInt
        }
        
        return int
    }
    
    static private func decodeInt256(from data: Data) throws -> BigInt {
        
        let intData = data.subdata(in: 0..<32).removeTrailingZeros
        
        let stringValue = String(bytes: intData)
        
        guard let int = BigInt(stringValue, radix: 16) else {
            throw ABIDecoderError.errorDecodingInt
        }
        
        return int
    }
    
    static private func decodeInt(from data: Data) throws -> Int {
        
        let intData = data.subdata(in: 0..<32).removeTrailingZeros
        
        let stringValue = String(bytes: intData)
        
        guard let int = Int(stringValue, radix: 16) else {
            throw ABIDecoderError.errorDecodingInt
        }
        
        return int
    }
    
    static private func decodeBool(from data: Data) throws -> Bool {
        
        let boolData = data.subdata(in: 0..<32).removeTrailingZeros
        
        return boolData.last == 1 ? true : false
    }
    
    static private func decodeString(from data: Data) throws -> String {
        
        let utf8Data = data.subdata(in: 32..<64).removeTrailingZeros
        
        guard let string = String(bytes: utf8Data, encoding: .utf8) else {
            throw ABIDecoderError.errorDecodingString
        }
        
        return string
    }
    
    static private func decodeArray(of type: SmartContractValueType, length: UInt?, from data: Data) throws -> [Any] {
        
        var values = [Any]()
        
        if let length = length {
            
            for word in 0..<Int(length) {
                let currentOffset = 32 * word
                let startIndex = data.index(data.startIndex, offsetBy: currentOffset)
                let endIndex = data.index(data.startIndex, offsetBy: currentOffset + 32)
                let data = Data(data[startIndex..<endIndex])
                let value = try decode(data, type: type)
                values.append(value)
            }
            
        } else {
            let countOfArrayStartIndex = data.startIndex
            let countOfArrayEndIndex = data.index(data.startIndex, offsetBy: 32)
            let countOfArrayData = Data(data[countOfArrayStartIndex..<countOfArrayEndIndex])
            let countOfArray = try decodeInt(from: countOfArrayData)
            
            for word in 0..<countOfArray {
                
                let currentOffset = 32 * word
                
                switch type.isDynamic {
                    
                case true:
                    let pointerStartIndex = data.index(data.startIndex, offsetBy: currentOffset) + countOfArrayEndIndex
                    let pointerEndIndex = data.index(data.startIndex, offsetBy: currentOffset + 32) + countOfArrayEndIndex
                    let pointerData = Data(data[pointerStartIndex..<pointerEndIndex])
                    let pointer = try decodeInt(from: pointerData)
                    
                    let dataPartStartIndex = data.index(data.startIndex, offsetBy: pointer) + countOfArrayEndIndex
                    let datapartEndIndex = data.index(data.startIndex, offsetBy: pointer + 64) + countOfArrayEndIndex
                    let dataPart = Data(data[dataPartStartIndex..<datapartEndIndex])
                    
                    let value = try decode(dataPart, type: type)
                    values.append(value)
                case false:
                    let startIndex = data.index(data.startIndex, offsetBy: currentOffset) + countOfArrayEndIndex
                    let endIndex = data.index(data.startIndex, offsetBy: currentOffset + 32) + countOfArrayEndIndex
                    let dataPart = Data(data[startIndex..<endIndex])
                    let value = try decode(dataPart, type: type)
                    values.append(value)
                }
            }
        }
        
        return values
    }
    
    static private func decodeBytes(from data: Data, length: UInt?) throws -> Data {
        
        let dataPart = data.subdata(in: 0..<64)
        
        if let _ = length {
            return dataPart.subdata(in: 0..<32).removeTrailingZeros
        } else {
            let bytesData = dataPart.subdata(in: 32..<64)
            return bytesData.removeTrailingZeros
        }
    }
}

