import Foundation

public struct SmartContractParam {
    
    let name: String
    let type: SmartContractValueType
    let value: ABIEncodable
    
    public init(name: String = "", type: SmartContractValueType, value: ABIEncodable) {
        self.name = name
        self.type = type
        self.value = value
    }
}
