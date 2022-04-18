import Foundation

public struct ERC20: SmartContractProtocol {
    
    public let address: String
    
    private let abi: String
    
    public init(abi: String, address: String) {
        self.abi = abi
        self.address = address
    }
    
    public func method(name: String, params: ABIParams) {
        
    }
}
