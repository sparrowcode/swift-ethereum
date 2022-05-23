import Foundation
import BigInt

public enum ERC721TransactionFactory {
    
    public static func generateTransferTransaction(tokenId: BigUInt, to address: String, gasPrice: BigUInt?, gasLimit: BigUInt?, contractAddress: String) throws -> Transaction {
        
        let params = [SmartContractParam(type: .address,  value: ABIEthereumAddress(address)),
                      SmartContractParam(type: .uint(), value: tokenId)]
        
        let method = SmartContractMethod(name: "transfer", params: params)
        
        guard let data = method.abiData else {
            throw ABIError.errorEncodingToABI
        }
        
        return try Transaction(gasLimit: gasLimit, gasPrice: gasPrice, input: data, to: contractAddress, value: BigUInt(0))
    }
    
    public static func generateBalanceTransaction(address: String, contractAddress: String) throws -> Transaction {
        
        let params = [SmartContractParam(type: .address, value: ABIEthereumAddress(address))]
        
        let method = SmartContractMethod(name: "balanceOf", params: params)
        
        guard let data = method.abiData else {
            throw ABIError.errorEncodingToABI
        }
        
        return try Transaction(input: data, to: contractAddress)
    }
    
    public static func generateOwnerOfTransaction(tokenId: BigUInt, contractAddress: String) throws -> Transaction {
        
        let params = [SmartContractParam(type: .uint(), value: tokenId)]
        
        let method = SmartContractMethod(name: "ownerOf", params: params)
        
        guard let data = method.abiData else {
            throw ABIError.errorEncodingToABI
        }
        
        return try Transaction(input: data, to: contractAddress)
    }
    
    public static func generateNameTransaction(contractAddress: String) throws -> Transaction {
        
        let method = SmartContractMethod(name: "name", params: [])
        
        guard let data = method.abiData else {
            throw ABIError.errorEncodingToABI
        }
        
        return try Transaction(input: data, to: contractAddress)
    }
    
    public static func generateSymbolTransaction(contractAddress: String) throws -> Transaction {
        
        let method = SmartContractMethod(name: "symbol", params: [])
        
        guard let data = method.abiData else {
            throw ABIError.errorEncodingToABI
        }
        
        return try Transaction(input: data, to: contractAddress)
    }
    
    public static func generateTokenURITransaction(tokenId: BigUInt, contractAddress: String) throws -> Transaction {
        
        let params = [SmartContractParam(type: .uint(), value: tokenId)]
        
        let method = SmartContractMethod(name: "tokenURI", params: params)
        
        guard let data = method.abiData else {
            throw ABIError.errorEncodingToABI
        }
        
        return try Transaction(input: data, to: contractAddress)
    }
    
    public static func generateTotalSupplyTransaction(contractAddress: String) throws -> Transaction {
        
        let method = SmartContractMethod(name: "totalSupply", params: [])
        
        guard let data = method.abiData else {
            throw ABIError.errorEncodingToABI
        }
        
        return try Transaction(input: data, to: contractAddress)
    }
    
    public static func generateTokenByIndexTransaction(index: BigUInt, contractAddress: String) throws -> Transaction {
        
        let params = [SmartContractParam(type: .uint(), value: index)]
        
        let method = SmartContractMethod(name: "tokenByIndex", params: params)
        
        guard let data = method.abiData else {
            throw ABIError.errorEncodingToABI
        }
        
        return try Transaction(input: data, to: contractAddress)
    }
    
    public static func generateTokenOfOwnerByIndexTransaction(ownerAddress: String, index: BigUInt, contractAddress: String) throws -> Transaction {
        
        let params = [SmartContractParam(type: .address, value: ABIEthereumAddress(ownerAddress)),
                      SmartContractParam(type: .uint(), value: index)]
        
        let method = SmartContractMethod(name: "tokenOfOwnerByIndex", params: params)
        
        guard let data = method.abiData else {
            throw ABIError.errorEncodingToABI
        }
        
        return try Transaction(input: data, to: contractAddress)
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
