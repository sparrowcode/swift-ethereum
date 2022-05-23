import Foundation

struct ABIEthereumAddress {
    let address: String
    
    init(_ address: String) {
        self.address = address.lowercased()
    }
}

extension ABIEthereumAddress: Equatable {}
