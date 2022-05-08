import Foundation
import BigInt

public protocol EIP721 {
    var address: String { get set }
    func balance(of address: String, completion: @escaping (BigUInt?, JSONRPCError?) -> ())
    func owner(of tokenID: BigUInt, completion: @escaping (String?, JSONRPCError?) -> ())
    func transfer(to address: String, tokenID: BigUInt, from: Account, completion: @escaping (String?, JSONRPCError?) -> ())
    func name(completion: @escaping (String?, JSONRPCError?) -> ())
    func symbol(completion: @escaping (String?, JSONRPCError?) -> ())
    func tokenURI(tokenID: BigUInt, completion: @escaping (String?, JSONRPCError?) -> ())
    func tokenMetadata(completion: @escaping (String?, JSONRPCError?) -> ())
    func totalSupply(completion: @escaping (BigUInt?, JSONRPCError?) -> ())
    func tokenByIndex(completion: @escaping (String?, JSONRPCError?) -> ())
    func tokenOfOwnerByIndex(completion: @escaping (String?, JSONRPCError?) -> ())
}

public extension EIP721 {
    
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
    
    func owner(of tokenID: BigUInt, completion: @escaping (String?, JSONRPCError?) -> ()) {
        
        let params = [SmartContractParam(type: .uint(), value: tokenID)]
        
        let method = SmartContractMethod(name: "ownerOf", params: params)
        
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
            
            guard let ownerAddress = try? ABIDecoder.decode(value, to: .address) as? String else {
                completion(nil, .errorDecodingFromABI)
                return
            }
            
            completion(ownerAddress, nil)
        }
    }
    
    func transfer(to address: String, tokenID: BigUInt, from: Account, completion: @escaping (String?, JSONRPCError?) -> ()) {
        
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
        
        EthereumService.call(transaction: transaction) { hexValue, error in
            
            guard let hexValue = hexValue, error == nil else {
                completion(nil, error)
                return
            }
            
            let value = hexValue.removeHexPrefix()
            
            guard let name = try? ABIDecoder.decode(value, to: .string) as? String else {
                completion(nil, .errorDecodingFromABI)
                return
            }
            
            completion(name, nil)
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
        
        EthereumService.call(transaction: transaction) { hexValue, error in
            
            guard let hexValue = hexValue, error == nil else {
                completion(nil, error)
                return
            }
            
            let value = hexValue.removeHexPrefix()
            
            guard let symbol = try? ABIDecoder.decode(value, to: .string) as? String else {
                completion(nil, .errorDecodingFromABI)
                return
            }
            
            completion(symbol, nil)
        }
        
    }
    
    func tokenURI(tokenID: BigUInt, completion: @escaping (String?, JSONRPCError?) -> ()) {
        
        let params = [SmartContractParam(type: .uint(), value: tokenID)]
        
        let method = SmartContractMethod(name: "tokenURI", params: params)
        
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
            
            guard let tokenURI = try? ABIDecoder.decode(value, to: .string) as? String else {
                completion(nil, .errorDecodingFromABI)
                return
            }
            
            completion(tokenURI, nil)
        }
    }
    
    func tokenMetadata(completion: @escaping (String?, JSONRPCError?) -> ()) {
        
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
            
            guard let totalSupply = try? ABIDecoder.decode(value, to: .uint()) as? BigUInt else {
                completion(nil, .errorDecodingFromABI)
                return
            }
            
            completion(totalSupply, nil)
        }
    }
    
    func tokenByIndex(completion: @escaping (String?, JSONRPCError?) -> ()) {
        
    }
    
    func tokenOfOwnerByIndex(completion: @escaping (String?, JSONRPCError?) -> ()) {
        
    }
}
