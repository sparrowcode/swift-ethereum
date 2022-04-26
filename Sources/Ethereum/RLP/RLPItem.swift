import Foundation
import BigInt

enum RLPItem {
    
    case int(_ value: Int)
    
    case string(_ value: String)
    
    case bigInt(_ value: BigInt)
    
    case array(_ value: [RLPItem])
    
    case bigUInt(_ value: BigUInt)
    
    case data(_ value: Data)
    
    init?(_ value: Any?) {
        switch value {
        case let int as Int:
            self = .int(int)
        case let string as String:
            self = .string(string)
        case let bigInt as BigInt:
            self = .bigInt(bigInt)
        case let array as [RLPItem]:
            self = .array(array)
        case let bigUInt as BigUInt:
            self = .bigUInt(bigUInt)
        case let data as Data:
            self = .data(data)
        default:
            return nil
        }
    }
}
