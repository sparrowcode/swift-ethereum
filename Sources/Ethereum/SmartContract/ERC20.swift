import Foundation
import SwiftKeccak
import BigInt

public struct ERC20 {
    
    public let address: String
    
    public init(address: String) {
        self.address = address.lowercased()
    }
    
    public func balance(of account: Account, completion: @escaping (BigUInt?, JSONRPCError?) -> ()) {
        
        let params = [SmartContractParam(name: "_owner", type: .address, value: EthereumAddress(account.address))]
        
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
            
            guard let bigUIntValue = try? ABIDecoder.decode(value, to: .uint()) as? BigUInt else {
                completion(nil, .errorDecodingFromABI)
                return
            }
            
            completion(bigUIntValue, nil)
        }
        
    }
    
    public func transfer(to address: String, amount: BigUInt, gasLimit: BigUInt, gasPrice: BigUInt, with account: Account, completion: @escaping (String?, JSONRPCError?) -> ()) {
        
        let params = [SmartContractParam(name: "_to", type: .address,  value: EthereumAddress(address)),
                      SmartContractParam(name: "_value", type: .uint(), value: amount)]
        
        let method = SmartContractMethod(name: "transfer", params: params)
        
        guard let data = method.abiData else {
            completion(nil, .errorEncodingToABI)
            return
        }
        
        guard let transaction = try? Transaction(gasLimit: gasLimit, gasPrice: gasPrice, input: data, to: self.address, value: amount) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        EthereumService.sendRawTransaction(account: account, transaction: transaction) { hash, error in
            completion(hash, error)
        }
    }
    
    func decimals(completion: @escaping (BigUInt?, JSONRPCError?) -> ()) {
        
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
            
            guard let bigUIntValue = try? ABIDecoder.decode(value, to: .uint()) as? BigUInt else {
                completion(nil, .errorDecodingFromABI)
                return
            }
            
            completion(bigUIntValue, nil)
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
        
        EthereumService.call(transaction: transaction) { abiSymbol, error in
            
            guard let abiSymbol = abiSymbol, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            guard let symbol = try? ABIDecoder.decode(abiSymbol.removeHexPrefix(), to: .string) as? String else {
                completion(nil, .errorDecodingFromABI)
                return
            }
            
            completion(symbol, nil)
        }
    }
    
    func name(completion: @escaping (String?, JSONRPCError?) -> ()) {
        
        let method = SmartContractMethod(name: "name", params: [])
        
        guard let data = method.abiData else {
            completion(nil, .errorEncodingToABI)
            return
        }
        
        guard let transaction = try? Transaction(input: data, to: self.address) else {
            completion(nil, .errorEncodingJSONRPC)
            return
        }
        
        EthereumService.call(transaction: transaction) { abiName, error in
            
            guard let abiName = abiName, error == nil else {
                completion(nil, .nilResponse)
                return
            }
            
            guard let name = try? ABIDecoder.decode(abiName.removeHexPrefix(), to: .string) as? String else {
                completion(nil, .errorDecodingFromABI)
                return
            }
            
            completion(name, nil)
        }
    }
    
    func totalSupply(completion: @escaping (BigUInt?, JSONRPCError?) -> ()) {
        
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
            
            guard let bigUIntValue = try? ABIDecoder.decode(value, to: .uint()) as? BigUInt else {
                completion(nil, .errorDecodingFromABI)
                return
            }
            
            completion(bigUIntValue, nil)
        }
    }
    
//    func approve(spender: Account, value: String, completion: @escaping (String?, JSONRPCError?) -> ()) {
//        
//        let params = [SmartContractParam(name: "_spender", type: .address, value: spender.address),
//                      SmartContractParam(name: "_value", type: .uint(), value: value)]
//        
//        let method = SmartContractMethod(name: "approve", params: [])
//        
//        guard let data = method.abiData else {
//            completion(nil, .errorEncodingToABI)
//            return
//        }
//        
//        guard let transaction = try? Transaction(input: data, to: self.address) else {
//            completion(nil, .errorEncodingJSONRPC)
//            return
//        }
//        
//        EthereumService.call(transaction: transaction) { hexValue, error in
//            
//            guard let hexValue = hexValue, error == nil else {
//                completion(nil, .nilResponse)
//                return
//            }
//            
//            let value = hexValue.removeHexPrefix()
//            
//            guard let bigIntValue = try? ABIDecoder.decode(value, to: .uint()) as? BigUInt else {
//                completion(nil, .errorDecodingFromABI)
//                return
//            }
//            
//            completion(bigIntValue.description, nil)
//        }
//    }
    
}
