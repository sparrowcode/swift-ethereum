import Foundation
import SwiftKeccak
import BigInt

public struct ERC20 {
    
    public let address: String
    
    public init(address: String) {
        self.address = address.lowercased()
    }
    
    public func balance(of account: Account, completion: @escaping (String?, JSONRPCError?) -> ()) {
        
        let params = [SmartContractParam(name: "_owner", value: .address(account.address))]
        
        let method = SmartContractMethod(name: "balanceOf", params: params)
        
        guard let data = method.abiData else {
            completion(nil, .errorEncodingToABI)
            return
        }
        
        guard let transaction = try? Transaction(input: data, to: self.address) else {
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
    
    public func transfer(to address: String, amount: String, gasLimit: String, gasPrice: String, with account: Account, completion: @escaping (String?, JSONRPCError?) -> ()) {
        
        guard let bigUIntAmount = BigUInt(amount) else {
            completion(nil, .invalidAmount)
            return
        }
        
        let params = [SmartContractParam(name: "_to", value: .address(address)),
                      SmartContractParam(name: "_value", value: .uint(bits: 256, bigUIntAmount))]
        
        let method = SmartContractMethod(name: "transfer", params: params)
        
        guard let data = method.abiData else {
            completion(nil, .errorEncodingToABI)
            return
        }
        
        guard let transaction = try? Transaction(gasLimit: gasLimit, gasPrice: gasPrice, input: data, to: self.address, value: "0") else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        EthereumService.sendRawTransaction(account: account, transaction: transaction) { hash, error in
            completion(hash, error)
        }
    }
    
    func decimals(completion: @escaping (Int?, JSONRPCError?) -> ()) {
        
        let method = SmartContractMethod(name: "decimals", params: [])
        
        guard let data = method.abiData else {
            completion(nil, .errorEncodingToABI)
            return
        }
        
        guard let transaction = try? Transaction(input: data, to: self.address) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        EthereumService.call(transaction: transaction) { hexValue, error in
            
            guard let hexValue = hexValue, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            let value = hexValue.removeHexPrefix()
            
            guard let intValue = Int(value, radix: 16) else {
                completion(nil, .errorConvertingFromHex)
                return
            }
            
            completion(intValue, nil)
        }
    }
    
    func symbol(completion: @escaping (String?, JSONRPCError?) -> ()) {
        
        let method = SmartContractMethod(name: "symbol", params: [])
        
        guard let data = method.abiData else {
            completion(nil, .errorEncodingToABI)
            return
        }
        
        guard let transaction = try? Transaction(input: data, to: self.address) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        EthereumService.call(transaction: transaction) { symbol, error in
            
            guard let symbol = symbol, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            // MARK: - ABIDecoder needed to parse the value
            
            completion(symbol, nil)
        }
    }
    
    func totalSupply(completion: @escaping (String?, JSONRPCError?) -> ()) {
        
        let method = SmartContractMethod(name: "totalSupply", params: [])
        
        guard let data = method.abiData else {
            completion(nil, .errorEncodingToABI)
            return
        }
        
        guard let transaction = try? Transaction(input: data, to: self.address) else {
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
