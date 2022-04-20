import Foundation
import SwiftKeccak
import BigInt

public struct ERC20 {
    
    public let address: String
    
    public init(address: String) {
        self.address = address.lowercased()
    }
    
    public func getBalance(for account: Account, completion: @escaping (String?, JSONRPCError?) -> ()) {
        
        let method = "balanceOf(address)"
        
        guard let methodData = method.data(using: .utf8) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        let kecckakBytes = methodData.keccak()
        
        let index4Bytes = kecckakBytes.subdata(in: 0..<4)
        
        guard let accountBytes = try? account.address.removeHexPrefix().bytes else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        let addressData = Data(accountBytes).removeFirstZeros
        
        let data: Data = index4Bytes + Data(repeating: 0, count: 12) + addressData
        
        guard let transaction = try? Transaction(input: data, to: "0xF65FF945f3a6067D0742fD6890f32A6960dD817d") else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        EthereumService.call(transaction: transaction) { hexValue, error in
            
            guard let hexValue = hexValue, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            let value = hexValue.removeHexPrefix()
            
            guard let bigIntValue = BigInt(value, radix: 16) else {
                completion(nil, .errorConvertingFromHex)
                return
            }
            
            completion(bigIntValue.description, nil)
        }
    
    }
    
}
