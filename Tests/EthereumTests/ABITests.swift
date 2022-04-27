import XCTest
import BigInt
@testable import Ethereum

class ABITests: XCTestCase {

    func testEncodeMethod() throws {
        
        let params = [SmartContractParam(name: "array", value: ["hello"], type: .array(type: .array(type: .string)))]
        
        let arr = ["hello"]
        print(try! arr.encodeABI())
        
        print(params[0].type.stringValue)
    }

}
