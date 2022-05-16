import Foundation
import BigInt

public protocol ERC721Contract {
    var address: String { get set }
    func balance(of address: String, completion: @escaping (BigUInt?, Error?) -> ())
    func owner(of tokenID: BigUInt, completion: @escaping (String?, Error?) -> ())
    func transfer(to address: String, tokenID: BigUInt, from account: Account, gasPrice: BigUInt, gasLimit: BigUInt, completion: @escaping (String?, Error?) -> ())
    func name(completion: @escaping (String?, Error?) -> ())
    func symbol(completion: @escaping (String?, Error?) -> ())
    func tokenURI(tokenID: BigUInt, completion: @escaping (String?, Error?) -> ())
    func totalSupply(completion: @escaping (BigUInt?, Error?) -> ())
    func tokenByIndex(index: BigUInt, completion: @escaping (BigUInt?, Error?) -> ())
    func tokenOfOwnerByIndex(owner: String, index: BigUInt, completion: @escaping (BigUInt?, Error?) -> ())
    //func mint(to address: String, tokenId: String, completion: @escaping (String?, Error?) -> ())
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
    
    func transfer(to address: String, tokenID: BigUInt, from account: Account, gasPrice: BigUInt, gasLimit: BigUInt, completion: @escaping (String?, Error?) -> ()) {
        
        let params = [SmartContractParam(type: .address,  value: EthereumAddress(address)),
                      SmartContractParam(type: .uint(), value: tokenID)]
        
        let method = SmartContractMethod(name: "transfer", params: params)
        
        guard let data = method.abiData else {
            completion(nil, ABIError.errorEncodingToABI)
            return
        }
        
        var transaction: Transaction
            
        do {
            transaction = try Transaction(gasLimit: gasLimit, gasPrice: gasPrice, input: data, to: self.address, value: BigUInt(0))
        } catch {
            completion(nil, error)
            return
        }
        
        EthereumService.sendRawTransaction(account: account, transaction: transaction) { hash, error in
            completion(hash, error)
        }
        
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
    
    func tokenByIndex(index: BigUInt, completion: @escaping (BigUInt?, Error?) -> ()) {
        
        let params = [SmartContractParam(type: .uint(), value: index)]
        
        let method = SmartContractMethod(name: "tokenByIndex", params: params)
        
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
            
            guard let tokenId = try? ABIDecoder.decode(value, to: .uint()) as? BigUInt else {
                completion(nil, ABIError.errorDecodingFromABI)
                return
            }
            
            completion(tokenId, nil)
        }
    }
    
    func tokenOfOwnerByIndex(owner: String, index: BigUInt, completion: @escaping (BigUInt?, Error?) -> ()) {
        
        let params = [SmartContractParam(type: .address, value: EthereumAddress(owner)),
                      SmartContractParam(type: .uint(), value: index)]
        
        let method = SmartContractMethod(name: "tokenOfOwnerByIndex", params: params)
        
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
            
            guard let tokenId = try? ABIDecoder.decode(value, to: .uint()) as? BigUInt else {
                completion(nil, ABIError.errorDecodingFromABI)
                return
            }
            
            completion(tokenId, nil)
        }
    }
    
//    func mint(to address: String, tokenId: String, tokenURI: String, with account: Account, completion: @escaping (String?, Error?) -> ()) {
//
//        let params = [SmartContractParam(type: .address,  value: EthereumAddress(address)),
//                      SmartContractParam(type: .string, value: tokenURI)]
//
//        let method = SmartContractMethod(name: "_mint", params: params)
//
//        guard let data = method.abiData else {
//            completion(nil, ABIError.errorEncodingToABI)
//            return
//        }
//
//        var transaction: Transaction
//
//        do {
//            transaction = try Transaction(gasLimit: gasLimit, gasPrice: gasPrice, input: data, to: self.address, value: BigUInt(0))
//        } catch {
//            completion(nil, error)
//            return
//        }
//
//        EthereumService.sendRawTransaction(account: account, transaction: transaction) { hash, error in
//            completion(hash, error)
//        }
//    }
}


extension ERC721Contract {
    
    func transferTransaction(to address: String, tokenId: BigUInt, from account: Account, gasPrice: BigUInt, gasLimit: BigUInt) throws -> Transaction {
        
        let params = [SmartContractParam(type: .address,  value: EthereumAddress(address)),
                      SmartContractParam(type: .uint(), value: tokenId)]
        
        let method = SmartContractMethod(name: "transfer", params: params)
        
        guard let data = method.abiData else {
            throw ABIError.errorEncodingToABI
        }
        
        return try Transaction(gasLimit: gasLimit, gasPrice: gasPrice, input: data, to: self.address, value: BigUInt(0))
        
    }
}
