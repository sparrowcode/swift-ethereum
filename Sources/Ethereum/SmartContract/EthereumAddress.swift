import Foundation

struct EthereumAddress {
    let address: String
    
    init(_ address: String) {
        self.address = address.lowercased()
    }
}

extension EthereumAddress: Equatable {
    
}
