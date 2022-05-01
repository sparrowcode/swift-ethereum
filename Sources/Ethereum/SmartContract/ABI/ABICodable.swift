import Foundation
import BigInt

typealias ABICodable = ABIEncodable & ABIDecodable

protocol ABIEncodable {
    func encodeABI(isDynamic: Bool, type: SmartContractValueType?) throws -> Data
}

protocol ABIDecodable {
    func decodeABI() throws -> Data
}

enum ABIEncoderError: Error {
    case invalidMethodName
    case invalidStringParam
}

extension EthereumAddress: ABICodable {
    
    func encodeABI(isDynamic: Bool, type: SmartContractValueType?) throws -> Data {
        
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
    
    func encodeABI(isDynamic: Bool, type: SmartContractValueType?) throws -> Data {
        
        let data = self.serialize()
        
        let paddedData =  Data(repeating: 0x00, count: 32 - data.count) + data
        
        return paddedData
    }
    
    func decodeABI() throws -> Data {
        return Data()
    }
    
}

extension BigInt: ABICodable {
    
    func encodeABI(isDynamic: Bool, type: SmartContractValueType?) throws -> Data {
        
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

extension Int: ABICodable {
    
    func encodeABI(isDynamic: Bool, type: SmartContractValueType?) throws -> Data {
        
        let bigInt = BigInt(self)
        
        return try bigInt.encodeABI(isDynamic: isDynamic, type: .int())
    }
    
    func decodeABI() throws -> Data {
        return Data()
    }
}

extension Bool: ABICodable {
    
    func encodeABI(isDynamic: Bool, type: SmartContractValueType?) throws -> Data {
        
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
    
    func encodeABI(isDynamic: Bool, type: SmartContractValueType?) throws -> Data {
        
        // MARK: - Use count for characters or for bits in utf8 encoded data?
        let bigUIntCount = BigUInt(self.count)
        
        let lengthData = try bigUIntCount.encodeABI(isDynamic: false, type: .uint())
        
        guard let utfData = self.data(using: .utf8) else { throw ABIEncoderError.invalidStringParam }
        
        let paddedData = utfData + Data(repeating: 0x00, count: 32 - utfData.count)
        
        return lengthData + paddedData
    }
    
    func decodeABI() throws -> Data {
        return Data()
    }
    
}

extension Data: ABICodable {
    
    func encodeABI(isDynamic: Bool, type: SmartContractValueType?) throws -> Data {
        
        let bigUIntCount = BigUInt(self.count)
        
        let lengthData = try bigUIntCount.encodeABI(isDynamic: false, type: .uint())
        
        let paddedData = self + Data(repeating: 0x00, count: 32 - self.count)
        
        return isDynamic ? lengthData + paddedData : paddedData
    }
    
    func decodeABI() throws -> Data {
        return Data()
    }
    
}

extension Array: ABIEncodable where Element: ABIEncodable {
    
    func encodeABI(isDynamic: Bool, type: SmartContractValueType?) throws -> Data {
        
        let bigUIntCount = BigUInt(self.count)
        
        let lengthData = try bigUIntCount.encodeABI(isDynamic: false, type: .uint())
        
        var staticSignature = Data()
        
        var dynamicSignature = Data()
        
        for value in self {
            if type?.isDynamic == true {
                
                //calculate an offset for dynamic type and append it to static signature
                let bigUIntCount = BigUInt(self.count * 32 + dynamicSignature.count)
                let offset = try bigUIntCount.encodeABI(isDynamic: false, type: .uint())
                staticSignature.append(offset)
                
                // calculate the encoded value of a given param and append it to dynamic signature
                let encodedParam = try value.encodeABI(isDynamic: true, type: type?.sequenceElementType)
                dynamicSignature.append(encodedParam)
            } else {
                let encodedParam = try value.encodeABI(isDynamic: false, type: type?.sequenceElementType)
                staticSignature.append(encodedParam)
            }
        }
        
        return isDynamic ? lengthData + staticSignature + dynamicSignature : staticSignature + dynamicSignature
    }
    
}
