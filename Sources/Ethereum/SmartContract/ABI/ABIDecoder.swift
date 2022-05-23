import Foundation
import BigInt

public enum ABIDecoder {
    
    public enum ABIDecoderError: Error {
        case errorDecodingInt
        case errorDecodingString
        case noSequenceElementTypeProvidedForArray
    }
    
    static public func decode(_ value: String, to type: SmartContractValueType) throws -> Any {
        
        let bytes = try value.removeHexPrefix().bytes
        
        let data = Data(bytes)
        
        return try decode(data, to: [type])
    }
    
    static public func decode(_ data: Data, to type: SmartContractValueType) throws -> Any {
        
        return try decode(data, to: [type])
    }
    
    static public func decode(_ value: String, to types: [SmartContractValueType]) throws -> Any {
        
        let bytes = try value.removeHexPrefix().bytes
        
        let data = Data(bytes)
        
        return try decode(data, to: types)
    }
    
    static public func decode(_ data: Data, to types: [SmartContractValueType]) throws -> Any {
        
        var values = [Any]()
        
        for word in 0..<types.count {
            
            let currentOffset = 32 * word
            
            switch types[word].isDynamic {
                
            case true:
                let pointerData = data.subdata(in: currentOffset..<data.count)
                let pointer = try decodeInt(from: pointerData)
                
                let dataPart = data.subdata(in: pointer..<data.count)
                
                let value = try decode(dataPart, type: types[word])
                values.append(value)
            case false:
                let dataPart = data.subdata(in: currentOffset..<data.count)
                let value = try decode(dataPart, type: types[word])
                values.append(value)
            }
        }
        
        return values.count > 1 ? values : values[0]
    }
    
    // MARK: - Only for static data parts or for pointed dynamic
    static private func decode(_ value: String, type: SmartContractValueType) throws -> Any {
        
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
    
    static private func decodeAddress(from data: Data) throws -> String {
        
        let addressData = data.subdata(in: 12..<32)
        
        let ethereumAddress = "0x" + String(bytes: addressData)
        
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
        
        let utf8Data = try decodeBytes(from: data, length: nil)
        
        guard let string = String(bytes: utf8Data, encoding: .utf8) else {
            throw ABIDecoderError.errorDecodingString
        }
        
        return string
    }
    
    static private func decodeArray(of type: SmartContractValueType, length: UInt?, from data: Data) throws -> [Any] {
        
        // the resulting values
        var values = [Any]()
        
        var lengthOfArray = 0
        var arrayData = data
        
        // calculate the length of an array from the first word or if the length provided use it
        if let length = length {
            lengthOfArray = Int(length)
        } else {
            lengthOfArray = try decodeInt(from: data)
            arrayData = data.subdata(in: 32..<data.count)
        }
        
        for word in 0..<lengthOfArray {
            
            let currentOffset = 32 * word
            
            switch type.isDynamic {
                
            case true:
                let pointerData = arrayData.subdata(in: currentOffset..<arrayData.count)
                let pointer = try decodeInt(from: pointerData)
                
                let dataPart = arrayData.subdata(in: pointer..<arrayData.count)
                
                let value = try decode(dataPart, type: type)
                values.append(value)
            case false:
                let dataPart = arrayData.subdata(in: currentOffset..<arrayData.count)
                let value = try decode(dataPart, type: type)
                values.append(value)
            }
        }
        
        return values
    }
    
    static private func decodeBytes(from data: Data, length: UInt?) throws -> Data {
        
        var decodedData = Data()
        var encodedData = data
        
        var countOfWords = Double()
        var countOfBytes = Int()
        
        if let length = length {
            countOfBytes = Int(length)
        } else {
            countOfBytes = try decodeInt(from: data)
            encodedData = data.subdata(in: 32..<data.count)
        }
        
        countOfWords = Double(countOfBytes) / 32
        countOfWords.round(.up)
        
        for word in 0..<Int(countOfWords) {
            
            let wordData = encodedData.subdata(in: 32*word..<32*(word+1)).removeTrailingZeros
            decodedData.append(wordData)
        }
        
        return decodedData
    }
}

