import Foundation
import BigInt

public protocol ERC20Contract {
    var address: String { get set }
    func balance(of address: String, completion: @escaping (BigUInt?, Error?) -> ())
    func transfer(to address: String, amount: BigUInt, gasLimit: BigUInt, gasPrice: BigUInt, with account: Account, completion: @escaping (String?, Error?) -> ())
    func decimals(completion: @escaping (BigUInt?, Error?) -> ())
    func symbol(completion: @escaping (String?, Error?) -> ())
    func name(completion: @escaping (String?, Error?) -> ())
    func totalSupply(completion: @escaping (BigUInt?, Error?) -> ())
    func approve(spender: Account, value: BigUInt, completion: @escaping (BigUInt?, Error?) -> ())
    func deploy(with account: Account, binary: Data, gasLimit: BigUInt, gasPrice: BigUInt, completion: @escaping (String?, Error?) -> ())
}

public extension ERC20Contract {
    
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
    
    func transfer(to address: String, amount: BigUInt, gasLimit: BigUInt, gasPrice: BigUInt, with account: Account, completion: @escaping (String?, Error?) -> ()) {
        
        let params = [SmartContractParam(type: .address,  value: EthereumAddress(address)),
                      SmartContractParam(type: .uint(), value: amount)]
        
        let method = SmartContractMethod(name: "transfer", params: params)
        
        guard let data = method.abiData else {
            completion(nil, ABIError.errorEncodingToABI)
            return
        }
        
        var transaction: Transaction
        
        do {
            transaction = try Transaction(gasLimit: gasLimit, gasPrice: gasPrice, input: data, to: self.address, value: amount)
        } catch {
            completion(nil, error)
            return
        }
        
        EthereumService.sendRawTransaction(account: account, transaction: transaction) { hash, error in
            completion(hash, error)
        }
    }
    
    func decimals(completion: @escaping (BigUInt?, Error?) -> ()) {
        
        let method = SmartContractMethod(name: "decimals", params: [])
        
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
        
        EthereumService.call(transaction: transaction) { abiSymbol, error in
            
            guard let abiSymbol = abiSymbol, error == nil else {
                completion(nil, error)
                return
            }
            
            guard let symbol = try? ABIDecoder.decode(abiSymbol.removeHexPrefix(), to: .string) as? String else {
                completion(nil, ABIError.errorDecodingFromABI)
                return
            }
            
            completion(symbol, nil)
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
        
        EthereumService.call(transaction: transaction) { abiName, error in
            
            guard let abiName = abiName, error == nil else {
                completion(nil, error)
                return
            }
            
            guard let name = try? ABIDecoder.decode(abiName.removeHexPrefix(), to: .string) as? String else {
                completion(nil, ABIError.errorDecodingFromABI)
                return
            }
            
            completion(name, nil)
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
            
            guard let bigUIntValue = try? ABIDecoder.decode(value, to: .uint()) as? BigUInt else {
                completion(nil, ABIError.errorDecodingFromABI)
                return
            }
            
            completion(bigUIntValue, nil)
        }
    }
    
    func deploy(with account: Account, binary: Data, gasLimit: BigUInt, gasPrice: BigUInt, completion: @escaping (String?, Error?) -> ()) {
        
        var transaction: Transaction
        
        do {
            transaction = try Transaction(gasLimit: gasLimit, gasPrice: gasPrice, input: binary, to: "0x", value: BigUInt(0))
        } catch {
            completion(nil, error)
            return
        }
        
        EthereumService.sendRawTransaction(account: account, transaction: transaction) { hash, error in
            
            completion(hash, error)
        }
        
    }
    
    func approve(spender: Account, value: BigUInt, completion: @escaping (BigUInt?, Error?) -> ()) {
        
        let params = [SmartContractParam(type: .address, value: EthereumAddress(spender.address)),
                      SmartContractParam(type: .uint(), value: value)]
        
        let method = SmartContractMethod(name: "approve", params: params)
        
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
    
}


extension ERC20Contract {
    func transferTransaction(to address: String, amount: BigUInt, gasLimit: BigUInt, gasPrice: BigUInt, with account: Account) throws -> Transaction {
        
        let params = [SmartContractParam(type: .address,  value: EthereumAddress(address)),
                      SmartContractParam(type: .uint(), value: amount)]
        
        let method = SmartContractMethod(name: "transfer", params: params)
        
        guard let data = method.abiData else {
            throw ABIError.errorEncodingToABI
        }
        
        return try Transaction(gasLimit: gasLimit, gasPrice: gasPrice, input: data, to: self.address, value: BigUInt(0))
        
    }
}
