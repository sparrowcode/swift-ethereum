import Foundation

public enum Network: CaseIterable, Equatable {
    
    public static var allCases: [Network] = [.mainnet, .rinkeby, .ropsten, .kovan, .goerli, .custom(-1000)]
    
    case mainnet
    case rinkeby
    case ropsten
    case kovan
    case goerli
    case custom(Int)
    
    var chainID: Int {
        switch self {
        case .mainnet:
            return 1
        case .rinkeby:
            return 4
        case .ropsten:
            return 3
        case .kovan:
            return 42
        case .goerli:
            return 5
        case .custom(let value):
            return value
        }
    }
}


