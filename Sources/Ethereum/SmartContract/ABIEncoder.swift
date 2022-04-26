import Foundation
import SwiftKeccak
import BigInt

public enum ABIEncoder {
    
    enum ABIEncoderError: Error {
        case invalidMethodName
        case invalidStringParam
    }
    
    static func encode(method: SmartContractMethod) throws -> Data {
        
        let fullMethodName = method.name + "(" + method.params.map { $0.value.stringValue }.joined(separator: ",") + ")"
        
        guard let methodData = fullMethodName.data(using: .utf8) else {
            throw ABIEncoderError.invalidMethodName
        }

        let kecckakBytes = methodData.keccak()

        let methodSignature = kecckakBytes.subdata(in: 0..<4)

        var staticParamsSignature = Data()
        
        var dynamicParamsSignature = Data()
        
        for param in method.params {
            
            switch param.value.isDynamic {
                
            case true:
                // calculate an offset for dynamic type and append it to static signature
                let bigUIntCount = BigUInt(staticParamsSignature.count + dynamicParamsSignature.count)
                let offset = encode(uint: bigUIntCount)
                staticParamsSignature.append(offset)
                
                // calculate the encoded value of a given param and append it to dynamic signature
                let encodedParam = try encode(value: param.value)
                dynamicParamsSignature.append(encodedParam)
            case false:
                let encodedParam = try encode(value: param.value)
                staticParamsSignature.append(encodedParam)
            }
            
        }
        
        return methodSignature + staticParamsSignature + dynamicParamsSignature
    }
    
    
    
    static func encode(value: SmartContractValue) throws -> Data {
        switch value {
        case .address(value: let value):
            return try encode(address: value)
        case .uint(bits: _, _: let value):
            return encode(uint: value)
        case .int(bits: _, _: let value):
            return encode(int: value)
        case .bool(value: let value):
            return encode(bool: value)
        case .bytes(value: let value):
            return Data()
        case .string(value: let value):
            return try encode(string: value)
        case .array(let values):
            return try encode(array: values)
        }
    }
    
    static func encode(address: String) throws -> Data {
        
        let bytes = try address.removeHexPrefix().lowercased().bytes
        
        let data = Data(bytes)
        
        let paddedData = Data(repeating: 0x00, count: 12) + data
        
        return paddedData
    }
    
    static func encode(uint: BigUInt) -> Data {
        
        let data = uint.serialize()
        
        let paddedData =  Data(repeating: 0x00, count: 32 - data.count) + data
        
        return paddedData
    }
    
    static func encode(int: BigInt) -> Data {
        
        let data = int.serialize()
        
        var paddedData = Data()
        
        if int > 0 {
            paddedData =  Data(repeating: 0x00, count: 32 - data.count) + data
        } else {
            paddedData =  Data(repeating: 0xff, count: 32 - data.count) + data
        }
        
        return paddedData
    }
    
    static func encode(bool: Bool) -> Data {
        
        let uintValue = bool ? BigUInt(1) : BigUInt(0)
        
        let data = uintValue.serialize()
        
        let paddedData =  Data(repeating: 0x00, count: 32 - data.count) + data
        
        return paddedData
    }
    
    static func encode(string: String) throws -> Data {
        
        let bigUIntCount = BigUInt(string.count)
        
        let lengthData = encode(uint: bigUIntCount)
        
        guard let utfData = string.data(using: .utf8) else { throw ABIEncoderError.invalidStringParam }
        
        let paddedUtfData =  utfData + Data(repeating: 0x00, count: 32 - utfData.count)
        
        return lengthData + paddedUtfData
    }
    
    // MARK: - No proper offset calculation yet (if you put an embedded array will return wrong result)
    static func encode(array: [SmartContractValue]) throws -> Data {
        
        let bigUIntCount = BigUInt(array.count)
        
        let lengthData = encode(uint: bigUIntCount)
        
        let paddedData = try array.map { try encode(value: $0) }.reduce(Data(), +)
        
        return lengthData + paddedData
    }
}
