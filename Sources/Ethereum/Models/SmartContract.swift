import Foundation

protocol SmartContractProtocol {
    
    var address: String { get set }
    
}

extension SmartContractProtocol {
    // base realisation of smart contracts (call method)
}
// make it reusable (for users to interact with custom smart contracts)

open class SmartContract {
    
    public var address: String
    
    init(address: String) {
        self.address = address
    }

    // methods from ethereum service which are related to smart contract
    
}

