import Foundation
import BigInt

public protocol EIP20 {
    var address: String { get set }
    func balance(of address: String, completion: @escaping (BigUInt?, JSONRPCError?) -> ())
    func transfer(to address: String, amount: BigUInt, gasLimit: BigUInt, gasPrice: BigUInt, with account: Account, completion: @escaping (String?, JSONRPCError?) -> ())
    func decimals(completion: @escaping (BigUInt?, JSONRPCError?) -> ())
    func symbol(completion: @escaping (String?, JSONRPCError?) -> ())
    func name(completion: @escaping (String?, JSONRPCError?) -> ())
    func totalSupply(completion: @escaping (BigUInt?, JSONRPCError?) -> ())
    func approve(spender: Account, value: BigUInt, completion: @escaping (BigUInt?, JSONRPCError?) -> ())
}

public extension EIP20 {
    
    func balance(of address: String, completion: @escaping (BigUInt?, JSONRPCError?) -> ()) {
        
        let params = [SmartContractParam(type: .address, value: EthereumAddress(address))]
        
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
                completion(nil, error)
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
    
    func transfer(to address: String, amount: BigUInt, gasLimit: BigUInt, gasPrice: BigUInt, with account: Account, completion: @escaping (String?, JSONRPCError?) -> ()) {
        
        let params = [SmartContractParam(type: .address,  value: EthereumAddress(address)),
                      SmartContractParam(type: .uint(), value: amount)]
        
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
                completion(nil, error)
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
                completion(nil, error)
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
                completion(nil, error)
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
                completion(nil, error)
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
    
    func approve(spender: Account, value: BigUInt, completion: @escaping (BigUInt?, JSONRPCError?) -> ()) {
        
        let params = [SmartContractParam(type: .address, value: EthereumAddress(spender.address)),
                      SmartContractParam(type: .uint(), value: value)]
        
        let method = SmartContractMethod(name: "approve", params: params)
        
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
                completion(nil, error)
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
    
}
