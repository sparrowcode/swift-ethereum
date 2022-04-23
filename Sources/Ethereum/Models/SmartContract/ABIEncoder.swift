import Foundation
import SwiftKeccak
import BigInt

public enum ABIEncoder {
    
    enum ABIEncoderError: Error {
        case invalidMethodName
    }
    
    static func encode(method: SmartContractMethod) throws -> Data {
        
        let fullMethodName = method.name + "(" + method.params.map {$0.value.stringValue}.joined(separator: ",") + ")"
        
        guard let methodData = fullMethodName.data(using: .utf8) else {
            throw ABIEncoderError.invalidMethodName
        }

        let kecckakBytes = methodData.keccak()

        let methodSignature = kecckakBytes.subdata(in: 0..<4)

        var paramsSignature = Data()
        
        for param in method.params {
            let encodedParam = try encode(param: param)
            paramsSignature.append(encodedParam)
        }
        
        return methodSignature + paramsSignature
    }
    
    static func encode(param: SmartContractParam) throws -> Data {
        switch param.value {
        case .address(value: let value):
            return try encode(address: value)
        case .uint(bits: _, value: let value):
            return encode(uint: value)
        case .int(bits: _, value: let value):
            return encode(int: value)
        case .bool(value: let value):
            return encode(bool: value)
        case .bytes(value: let value):
            return Data()
        case .string(value: let value):
            return Data()
        }
    }
    
    static func encode(address: String) throws -> Data {
        
        let bytes = try address.removeHexPrefix().lowercased().bytes
        
        let data = Data(bytes).removeFirstZeros
        
        let paddedData = Data(repeating: 0, count: 12) + data
        
        return paddedData
    }
    
    static func encode(uint: BigUInt) -> Data {
        
        let bytes = uint.serialize()
        
        let data = Data(bytes).removeFirstZeros
        
        let paddedData =  Data(repeating: 0, count: 32 - bytes.count) + data
        
        return paddedData
    }
    
    static func encode(int: BigInt) -> Data {
        
        let bytes = int.serialize()
        
        let data = Data(bytes).removeFirstZeros
        
        let paddedData =  Data(repeating: 0, count: 32 - bytes.count) + data
        
        return paddedData
    }
    
    static func encode(bool: Bool) -> Data {
        
        let uintValue = bool ? BigUInt(1) : BigUInt(0)
        
        let bytes = uintValue.serialize()
        
        let data = Data(bytes).removeFirstZeros
        
        let paddedData =  Data(repeating: 0, count: 32 - bytes.count) + data
        
        return paddedData
    }
}
