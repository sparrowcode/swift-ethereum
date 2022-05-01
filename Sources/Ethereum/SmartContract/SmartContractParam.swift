import Foundation

public struct SmartContractParam {
    let name: String
    let type: SmartContractValueType
    let value: ABIEncodable
}
