import Foundation

protocol SmartContractProtocol {
    
    init(abi: String, address: String)
    
    // MARK: - write an extension with default realisation
    func method(name: String, params: ABIParams)
    
}

extension SmartContractProtocol {
    // base realisation of smart contracts (call method)
}





