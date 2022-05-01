import Foundation

public struct SmartContractMethod {
    let name: String
    let params: [SmartContractParam]
    
    var abiData: Data? {
        return try? ABIEncoder.encode(method: self)
    }
}
