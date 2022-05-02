import Foundation
import BigInt

typealias ABICodable = ABIEncodable & ABIDecodable

protocol ABIEncodable {
    // sequence element type is used to infer the type of element in sequence (ex. array), it is not required for static types and strings
    func encodeABI(isDynamic: Bool, sequenceElementType: SmartContractValueType?) throws -> Data
}

protocol ABIDecodable {
    func decodeABI() throws -> Data
}

enum ABIEncoderError: Error {
    case invalidMethodName
    case invalidStringParam
}

extension EthereumAddress: ABICodable {
    
    func encodeABI(isDynamic: Bool, sequenceElementType: SmartContractValueType?) throws -> Data {
        
        let bytes = try self.address.removeHexPrefix().lowercased().bytes
        
        let data = Data(bytes)
        
        let paddedData = Data(repeating: 0x00, count: 12) + data
        
        return paddedData
    }
    
    func decodeABI() throws -> Data {
        return Data()
    }
    
}

extension BigUInt: ABICodable {
    
    func encodeABI(isDynamic: Bool, sequenceElementType: SmartContractValueType?) throws -> Data {
        
        let data = self.serialize()
        
        let paddedData =  Data(repeating: 0x00, count: 32 - data.count) + data
        
        return paddedData
    }
    
    func decodeABI() throws -> Data {
        return Data()
    }
    
}

extension BigInt: ABICodable {
    
    func encodeABI(isDynamic: Bool, sequenceElementType: SmartContractValueType?) throws -> Data {
        
        let data = self.serialize()
        
        var paddedData = Data()
        
        if self >= 0 {
            paddedData =  Data(repeating: 0x00, count: 32 - data.count) + data
        } else {
            paddedData =  Data(repeating: 0xff, count: 32 - data.count) + data
        }
        
        return paddedData
    }
    
    func decodeABI() throws -> Data {
        return Data()
    }
    
}

extension FixedWidthInteger where Self: SignedInteger {
    
    func encodeABI(isDynamic: Bool, sequenceElementType: SmartContractValueType?) throws -> Data {
        
        let bigInt = BigInt(self)
        
        return try bigInt.encodeABI(isDynamic: isDynamic, sequenceElementType: .int())
    }
    
    func decodeABI() throws -> Data {
        return Data()
    }
    
}

extension FixedWidthInteger where Self: UnsignedInteger {
    
    func encodeABI(isDynamic: Bool, sequenceElementType: SmartContractValueType?) throws -> Data {
        
        let bigUInt = BigUInt(self)
        
        return try bigUInt.encodeABI(isDynamic: isDynamic, sequenceElementType: .int())
    }
    
    func decodeABI() throws -> Data {
        return Data()
    }
    
}

extension Int: ABICodable { }
extension Int8: ABICodable { }
extension Int16: ABICodable { }
extension Int32: ABICodable { }
extension Int64: ABICodable { }

extension UInt: ABICodable { }
extension UInt8: ABICodable { }
extension UInt16: ABICodable { }
extension UInt32: ABICodable { }
extension UInt64: ABICodable { }


extension Bool: ABICodable {
    
    func encodeABI(isDynamic: Bool, sequenceElementType: SmartContractValueType?) throws -> Data {
        
        let uintValue = self ? BigUInt(1) : BigUInt(0)
        
        let data = uintValue.serialize()
        
        let paddedData =  Data(repeating: 0x00, count: 32 - data.count) + data
        
        return paddedData
    }
    
    func decodeABI() throws -> Data {
        return Data()
    }
    
}

extension String: ABICodable {
    
    func encodeABI(isDynamic: Bool, sequenceElementType: SmartContractValueType?) throws -> Data {
        
        // MARK: - Use count for characters or for bits in utf8 encoded data?
        let bigUIntCount = BigUInt(self.count)
        
        let lengthData = try bigUIntCount.encodeABI(isDynamic: false, sequenceElementType: .uint())
        
        guard let utfData = self.data(using: .utf8) else { throw ABIEncoderError.invalidStringParam }
        
        let paddedData = utfData + Data(repeating: 0x00, count: 32 - utfData.count)
        
        return lengthData + paddedData
    }
    
    func decodeABI() throws -> Data {
        return Data()
    }
    
}

extension Data: ABICodable {
    
    func encodeABI(isDynamic: Bool, sequenceElementType: SmartContractValueType?) throws -> Data {
        
        let bigUIntCount = BigUInt(self.count)
        
        let lengthData = try bigUIntCount.encodeABI(isDynamic: false, sequenceElementType: .uint())
        
        let paddedData = self + Data(repeating: 0x00, count: 32 - self.count)
        
        return isDynamic ? lengthData + paddedData : paddedData
    }
    
    func decodeABI() throws -> Data {
        return Data()
    }
    
}

extension Array: ABIEncodable where Element: ABIEncodable {
    
    func encodeABI(isDynamic: Bool, sequenceElementType: SmartContractValueType?) throws -> Data {
        
        let bigUIntCount = BigUInt(self.count)
        
        let lengthData = try bigUIntCount.encodeABI(isDynamic: false, sequenceElementType: .uint())
        
        var staticSignature = Data()
        
        var dynamicSignature = Data()
        
        for value in self {
            if sequenceElementType?.isDynamic == true {
                
                //calculate an offset for dynamic type and append it to static signature
                let bigUIntCount = BigUInt(self.count * 32 + dynamicSignature.count)
                let offset = try bigUIntCount.encodeABI(isDynamic: false, sequenceElementType: .uint())
                staticSignature.append(offset)
                
                // calculate the encoded value of a given param and append it to dynamic signature
                let encodedParam = try value.encodeABI(isDynamic: true, sequenceElementType: sequenceElementType?.sequenceElementType)
                dynamicSignature.append(encodedParam)
            } else {
                let encodedParam = try value.encodeABI(isDynamic: false, sequenceElementType: sequenceElementType?.sequenceElementType)
                staticSignature.append(encodedParam)
            }
        }
        
        return isDynamic ? lengthData + staticSignature + dynamicSignature : staticSignature + dynamicSignature
    }
    
}

extension Array: ABIDecodable where Element: ABIDecodable {
    func decodeABI() throws -> Data {
        return Data()
    }
    
    
}
