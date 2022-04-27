import Foundation
import BigInt

typealias ABICodable = ABIEncodable & ABIDecodable

protocol ABIEncodable {
    func encodeABI() throws -> Data
    var isDynamic: Bool { get }
}

protocol ABIDecodable {
    func decodeABI() throws -> Data
}

enum ABIEncoderError: Error {
    case invalidMethodName
    case invalidStringParam
}

extension EthereumAddress: ABICodable {
    
    func encodeABI() throws -> Data {
        
        let bytes = try self.address.removeHexPrefix().lowercased().bytes
        
        let data = Data(bytes)
        
        let paddedData = Data(repeating: 0x00, count: 12) + data
        
        return paddedData
    }
    
    func decodeABI() throws -> Data {
        return Data()
    }
    
    var isDynamic: Bool {
        return false
    }
    
}

extension BigUInt: ABICodable {
    
    func encodeABI() throws -> Data {
        
        let data = self.serialize()
        
        let paddedData =  Data(repeating: 0x00, count: 32 - data.count) + data
        
        return paddedData
    }
    
    func decodeABI() throws -> Data {
        return Data()
    }
    
    var isDynamic: Bool {
        return false
    }
    
}

extension BigInt: ABICodable {
    
    func encodeABI() throws -> Data {
        
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
    
    var isDynamic: Bool {
        return false
    }
    
}

extension Bool: ABICodable {
    
    func encodeABI() throws -> Data {
        
        let uintValue = self ? BigUInt(1) : BigUInt(0)
        
        let data = uintValue.serialize()
        
        let paddedData =  Data(repeating: 0x00, count: 32 - data.count) + data
        
        return paddedData
    }
    
    func decodeABI() throws -> Data {
        return Data()
    }
    
    var isDynamic: Bool {
        return false
    }
    
}

extension String: ABICodable {
    
    func encodeABI() throws -> Data {
        
        let bigUIntCount = BigUInt(self.count)
        
        let lengthData = try bigUIntCount.encodeABI()
        
        guard let utfData = self.data(using: .utf8) else { throw ABIEncoderError.invalidStringParam }
        
        let paddedUtfData =  utfData + Data(repeating: 0x00, count: 32 - utfData.count)
        
        return lengthData + paddedUtfData
    }
    
    func decodeABI() throws -> Data {
        return Data()
    }
    
    var isDynamic: Bool {
        return true
    }
    
}

extension Array: ABICodable where Element: ABICodable {
    
    func encodeABI() throws -> Data {
        
        let bigUIntCount = BigUInt(self.count)
        
        let lengthData = try bigUIntCount.encodeABI()
        
        var staticParamsSignature = Data()
        
        var dynamicParamsSignature = Data()
        
        for element in self {
            
            switch element.isDynamic {
                
            case true:
                // calculate an offset for dynamic type and append it to static signature
                let bigUIntCount = BigUInt(staticParamsSignature.count + dynamicParamsSignature.count)
                let offset = try bigUIntCount.encodeABI()
                staticParamsSignature.append(offset)
                
                // calculate the encoded value of a given param and append it to dynamic signature
                let encodedParam = try element.encodeABI()
                dynamicParamsSignature.append(encodedParam)
                
            case false:
                let encodedParam = try element.encodeABI()
                staticParamsSignature.append(encodedParam)
            }
            
        }
        
        return lengthData + staticParamsSignature + dynamicParamsSignature
    }
    
    func decodeABI() throws -> Data {
        return Data()
    }
    
    var isDynamic: Bool {
        return true
    }
    
    
}
