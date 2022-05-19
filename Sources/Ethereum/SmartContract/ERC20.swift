import Foundation
import BigInt

public enum ERC20Contract {
    
    case balance(ofAddress: String, contractAddress: String)
    case transfer(value: BigUInt, to: String, gasLimit: BigUInt, gasPrice: BigUInt, contractAddress: String)
    case decimals(contractAddress: String)
    case symbol(contractAddress: String)
    case name(contractAddress: String)
    case totalSupply(contractAddress: String)
    //case deploy
    
    // Feature / extension
    func call(completion: @escaping (Any, Error) -> ()) throws {
        
    }
    
    public func generateTransaction() throws -> Transaction {
        switch self {
            
        case .balance(let ofAddress, let contractAddress):
            let params = [SmartContractParam(type: .address, value: EthereumAddress(ofAddress))]
            
            let method = SmartContractMethod(name: "balanceOf", params: params)
            
            guard let data = method.abiData else {
                throw ABIError.errorEncodingToABI
            }
            
            return try Transaction(input: data, to: contractAddress)
            
        case .transfer(let value, let to, let gasLimit, let gasPrice, let contractAddress):
            let params = [SmartContractParam(type: .address,  value: EthereumAddress(to)),
                          SmartContractParam(type: .uint(), value: value)]
            
            let method = SmartContractMethod(name: "transfer", params: params)
            
            guard let data = method.abiData else {
                throw ABIError.errorEncodingToABI
            }
            
            return try Transaction(gasLimit: gasLimit, gasPrice: gasPrice, input: data, to: contractAddress, value: BigUInt(0))
            
        case .decimals(contractAddress: let contractAddress):
            let method = SmartContractMethod(name: "decimals", params: [])
            
            guard let data = method.abiData else {
                throw ABIError.errorEncodingToABI
            }
            
            return try Transaction(input: data, to: contractAddress)
            
        case .symbol(contractAddress: let contractAddress):
            let method = SmartContractMethod(name: "symbol", params: [])
            
            guard let data = method.abiData else {
                throw ABIError.errorEncodingToABI
            }
            
            return try Transaction(input: data, to: contractAddress)
            
        case .name(contractAddress: let contractAddress):
            let method = SmartContractMethod(name: "name", params: [])
            
            guard let data = method.abiData else {
                throw ABIError.errorEncodingToABI
            }
            
            return try Transaction(input: data, to: contractAddress)
            
        case .totalSupply(contractAddress: let contractAddress):
            let method = SmartContractMethod(name: "totalSupply", params: [])
            
            guard let data = method.abiData else {
                throw ABIError.errorEncodingToABI
            }
            
            return try Transaction(input: data, to: contractAddress)
        }
    }
    
    
    public func decode(output: String) throws -> Any {
        switch self {
            
        case .balance(_, _):
            let value = output.removeHexPrefix()
            
            return try ABIDecoder.decode(value, to: .uint())
            
        case .transfer(_, _, _, _, _):
            return output
            
        case .decimals(_):
            let value = output.removeHexPrefix()
            
            return try ABIDecoder.decode(value, to: .uint())
            
        case .symbol(_):
            let value = output.removeHexPrefix()
            
            return try ABIDecoder.decode(value, to: .string)
            
        case .name(_):
            let value = output.removeHexPrefix()
            
            return try ABIDecoder.decode(value, to: .string)
            
        case .totalSupply(_):
            let value = output.removeHexPrefix()
            
            return try ABIDecoder.decode(value, to: .uint())
        }
    }
}


public enum ERC20TransactionFactory {
    
    public static func generateBalanceTransaction(address: String, contractAddress: String) throws -> Transaction {
        
        let params = [SmartContractParam(type: .address, value: EthereumAddress(address))]
        
        let method = SmartContractMethod(name: "balanceOf", params: params)
        
        guard let data = method.abiData else {
            throw ABIError.errorEncodingToABI
        }
        
        return try Transaction(input: data, to: contractAddress)
        
    }
}

//func deploy(with account: Account, binary: Data, gasLimit: BigUInt, gasPrice: BigUInt, completion: @escaping (String?, Error?) -> ()) {
//
//    var transaction: Transaction
//
//    do {
//        transaction = try Transaction(gasLimit: gasLimit, gasPrice: gasPrice, input: binary, to: "0x", value: BigUInt(0))
//    } catch {
//        completion(nil, error)
//        return
//    }
//
//    EthereumService.sendRawTransaction(account: account, transaction: transaction) { hash, error in
//
//        completion(hash, error)
//    }
//
//}
//
//

//func approve(spender: Account, value: BigUInt, completion: @escaping (BigUInt?, Error?) -> ()) {
//
//    let params = [SmartContractParam(type: .address, value: EthereumAddress(spender.address)),
//                  SmartContractParam(type: .uint(), value: value)]
//
//    let method = SmartContractMethod(name: "approve", params: params)
//
//    guard let data = method.abiData else {
//        completion(nil, ABIError.errorEncodingToABI)
//        return
//    }
//
//    var transaction: Transaction
//
//    do {
//        transaction = try Transaction(input: data, to: self.address)
//    } catch {
//        completion(nil, error)
//        return
//    }
//
//    EthereumService.call(transaction: transaction) { hexValue, error in
//
//        guard let hexValue = hexValue, error == nil else {
//            completion(nil, error)
//            return
//        }
//
//        let value = hexValue.removeHexPrefix()
//
//        guard let bigUIntValue = try? ABIDecoder.decode(value, to: .uint()) as? BigUInt else {
//            completion(nil, ABIError.errorDecodingFromABI)
//            return
//        }
//
//        completion(bigUIntValue, nil)
//    }
//}



enum ERC20ContractError: Error {
    case invalidTransaction(ERC20Contract)
}
