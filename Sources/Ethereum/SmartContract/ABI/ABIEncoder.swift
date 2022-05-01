import Foundation
import SwiftKeccak
import BigInt

public enum ABIEncoder {
    
    static func encode(method: SmartContractMethod) throws -> Data {
        
        let fullMethodName = method.name + "(" + method.params.map { $0.type.stringValue }.joined(separator: ",") + ")"
        
        guard let methodData = fullMethodName.data(using: .utf8) else {
            throw ABIEncoderError.invalidMethodName
        }

        let kecckakBytes = methodData.keccak()

        let methodSignature = kecckakBytes.subdata(in: 0..<4)

        var staticParamsSignature = Data()
        
        var dynamicParamsSignature = Data()
        
        for param in method.params {
            
            switch param.type.isDynamic {
                
            case true:
                
                // calculate an offset for dynamic type and append it to static signature
                let bigUIntCount = BigUInt(method.params.count * 32 + dynamicParamsSignature.count)
                let offset = try bigUIntCount.encodeABI(isDynamic: false, type: .uint())
                staticParamsSignature.append(offset)
                
                // calculate the encoded value of a given param and append it to dynamic signature           
                let encodedParam = try param.value.encodeABI(isDynamic: true, type: param.type.sequenceElementType)
                dynamicParamsSignature.append(encodedParam)
                
            case false:
                let encodedParam = try param.value.encodeABI(isDynamic: false, type: param.type.sequenceElementType)
                staticParamsSignature.append(encodedParam)
            }
            
        }
        
        return methodSignature + staticParamsSignature + dynamicParamsSignature
    }
}
