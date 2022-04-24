import XCTest
import BigInt
@testable import Ethereum

class ABITests: XCTestCase {

    func testEncodeMethod() throws {
        
//        let params = [SmartContractParam(name: <#T##String#>, value: <#T##SmartContractValue#>)]
//
//        let method = SmartContractMethod(name: "", params: <#T##[SmartContractParam]#>)
        
        print(Data(repeating: 0xff, count: 12))
        print(Data())
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
