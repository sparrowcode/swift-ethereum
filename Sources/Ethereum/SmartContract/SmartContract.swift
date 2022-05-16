import Foundation
import BigInt

protocol SmartContractProtocol {
    
    init(abi: String, address: String)
    
    // MARK: - write an extension with default realisation
    func method<T: Codable>(name: String, params: T) -> Transaction
    
    var allMethods: [String] { get }
    
    var allEvents: [String] { get }
    
}

extension SmartContractProtocol {}








