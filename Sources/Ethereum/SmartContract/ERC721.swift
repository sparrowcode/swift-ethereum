import Foundation
import BigInt

public protocol ERC721Contract {
    var address: String { get set }
    func balance(of address: String, completion: @escaping (BigUInt?, Error?) -> ())
    func owner(of tokenID: BigUInt, completion: @escaping (String?, Error?) -> ())
    func transfer(to address: String, tokenID: BigUInt, from: Account, completion: @escaping (String?, Error?) -> ())
    func name(completion: @escaping (String?, Error?) -> ())
    func symbol(completion: @escaping (String?, Error?) -> ())
    func tokenURI(tokenID: BigUInt, completion: @escaping (String?, Error?) -> ())
    func tokenMetadata(completion: @escaping (String?, Error?) -> ())
    func totalSupply(completion: @escaping (BigUInt?, Error?) -> ())
    func tokenByIndex(completion: @escaping (String?, Error?) -> ())
    func tokenOfOwnerByIndex(completion: @escaping (String?, Error?) -> ())
}

public extension ERC721Contract {
    
    func balance(of address: String, completion: @escaping (BigUInt?, Error?) -> ()) {
        
        let params = [SmartContractParam(type: .address, value: EthereumAddress(address))]
        
        let method = SmartContractMethod(name: "balanceOf", params: params)
        
        guard let data = method.abiData else {
            completion(nil, ABIError.errorEncodingToABI)
            return
        }
        
        var transaction: Transaction
        
        do {
            transaction = try Transaction(input: data, to: self.address)
        } catch {
            completion(nil, error)
            return
        }
        
        EthereumService.call(transaction: transaction) { hexValue, error in
            
            guard let hexValue = hexValue, error == nil else {
                completion(nil, error)
                return
            }
            
            let value = hexValue.removeHexPrefix()
            
            guard let bigUIntValue = try? ABIDecoder.decode(value, to: .uint()) as? BigUInt else {
                completion(nil, ABIError.errorDecodingFromABI)
                return
            }
            
            completion(bigUIntValue, nil)
        }
        
    }
    
    func owner(of tokenID: BigUInt, completion: @escaping (String?, Error?) -> ()) {
        
        let params = [SmartContractParam(type: .uint(), value: tokenID)]
        
        let method = SmartContractMethod(name: "ownerOf", params: params)
        
        guard let data = method.abiData else {
            completion(nil, ABIError.errorEncodingToABI)
            return
        }
        
        var transaction: Transaction
        
        do {
            transaction = try Transaction(input: data, to: self.address)
        } catch {
            completion(nil, error)
            return
        }
        
        EthereumService.call(transaction: transaction) { hexValue, error in
            
            guard let hexValue = hexValue, error == nil else {
                completion(nil, error)
                return
            }
            
            let value = hexValue.removeHexPrefix()
            
            guard let ownerAddress = try? ABIDecoder.decode(value, to: .address) as? String else {
                completion(nil, ABIError.errorDecodingFromABI)
                return
            }
            
            completion(ownerAddress, nil)
        }
    }
    
    func transfer(to address: String, tokenID: BigUInt, from: Account, completion: @escaping (String?, Error?) -> ()) {
        
    }
    
    func name(completion: @escaping (String?, Error?) -> ()) {
        
        let method = SmartContractMethod(name: "name", params: [])
        
        guard let data = method.abiData else {
            completion(nil, ABIError.errorEncodingToABI)
            return
        }
        
        var transaction: Transaction
        
        do {
            transaction = try Transaction(input: data, to: self.address)
        } catch {
            completion(nil, error)
            return
        }
        
        EthereumService.call(transaction: transaction) { hexValue, error in
            
            guard let hexValue = hexValue, error == nil else {
                completion(nil, error)
                return
            }
            
            let value = hexValue.removeHexPrefix()
            
            guard let name = try? ABIDecoder.decode(value, to: .string) as? String else {
                completion(nil, ABIError.errorDecodingFromABI)
                return
            }
            
            completion(name, nil)
        }
    }
    
    func symbol(completion: @escaping (String?, Error?) -> ()) {
        
        let method = SmartContractMethod(name: "symbol", params: [])
        
        guard let data = method.abiData else {
            completion(nil, ABIError.errorEncodingToABI)
            return
        }
        
        var transaction: Transaction
        
        do {
            transaction = try Transaction(input: data, to: self.address)
        } catch {
            completion(nil, error)
            return
        }
        
        EthereumService.call(transaction: transaction) { hexValue, error in
            
            guard let hexValue = hexValue, error == nil else {
                completion(nil, error)
                return
            }
            
            let value = hexValue.removeHexPrefix()
            
            guard let symbol = try? ABIDecoder.decode(value, to: .string) as? String else {
                completion(nil, ABIError.errorDecodingFromABI)
                return
            }
            
            completion(symbol, nil)
        }
        
    }
    
    func tokenURI(tokenID: BigUInt, completion: @escaping (String?, Error?) -> ()) {
        
        let params = [SmartContractParam(type: .uint(), value: tokenID)]
        
        let method = SmartContractMethod(name: "tokenURI", params: params)
        
        guard let data = method.abiData else {
            completion(nil, ABIError.errorEncodingToABI)
            return
        }
        
        var transaction: Transaction
        
        do {
            transaction = try Transaction(input: data, to: self.address)
        } catch {
            completion(nil, error)
            return
        }
        
        EthereumService.call(transaction: transaction) { hexValue, error in
            
            guard let hexValue = hexValue, error == nil else {
                completion(nil, error)
                return
            }
            
            let value = hexValue.removeHexPrefix()
            
            guard let tokenURI = try? ABIDecoder.decode(value, to: .string) as? String else {
                completion(nil, ABIError.errorDecodingFromABI)
                return
            }
            
            completion(tokenURI, nil)
        }
    }
    
    func tokenMetadata(completion: @escaping (String?, Error?) -> ()) {
        
    }
    
    func totalSupply(completion: @escaping (BigUInt?, Error?) -> ()) {
        
        let method = SmartContractMethod(name: "totalSupply", params: [])
        
        guard let data = method.abiData else {
            completion(nil, ABIError.errorEncodingToABI)
            return
        }
        
        var transaction: Transaction
        
        do {
            transaction = try Transaction(input: data, to: self.address)
        } catch {
            completion(nil, error)
            return
        }
        
        EthereumService.call(transaction: transaction) { hexValue, error in
            
            guard let hexValue = hexValue, error == nil else {
                completion(nil, error)
                return
            }
            
            let value = hexValue.removeHexPrefix()
            
            guard let totalSupply = try? ABIDecoder.decode(value, to: .uint()) as? BigUInt else {
                completion(nil, ABIError.errorDecodingFromABI)
                return
            }
            
            completion(totalSupply, nil)
        }
    }
    
    func tokenByIndex(completion: @escaping (String?, Error?) -> ()) {
        
    }
    
    func tokenOfOwnerByIndex(completion: @escaping (String?, Error?) -> ()) {
        
    }
}
