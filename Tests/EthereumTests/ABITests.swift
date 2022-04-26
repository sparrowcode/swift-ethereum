import XCTest
import BigInt
@testable import Ethereum

class ABITests: XCTestCase {

    func testEncodeMethod() throws {
        
        let params = [SmartContractParam(name: "array", value: .array([]))]
        
        
        print(params[0].value.stringValue)
    }

}
