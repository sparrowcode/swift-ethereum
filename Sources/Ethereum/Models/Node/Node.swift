import Foundation

// TODO: Make default nodes
enum DefaultNodes {
    static let mainnet = Node(url: URL(string: "https://speedy-nodes-nyc.moralis.io/b383c412901116039315dd16/eth/mainnet")!)
    static let ropsten = Node(url: URL(string: "https://speedy-nodes-nyc.moralis.io/b383c412901116039315dd16/eth/ropsten")!)
    static let rinkeby = Node(url: URL(string: "https://speedy-nodes-nyc.moralis.io/b383c412901116039315dd16/eth/rinkeby")!)
    static let kovan = Node(url: URL(string: "https://speedy-nodes-nyc.moralis.io/b383c412901116039315dd16/eth/kovan")!)
    static let goerli = Node(url: URL(string: "https://speedy-nodes-nyc.moralis.io/b383c412901116039315dd16/eth/goerli")!)
}

public struct Node {
    
    // MARK: - Net
    
    public let url: URL
    
    public static func version() {
        //Provider(node: self).sendRequest(jsonRPCData: , completion: )
    }
    
    public static func listening() {
        
    }
    
    public static func peerCount() {
        
    }
    
    // MARK: - Web3
    
    public static func clientVersion() {
        
    }
    
    public static func sha3() {
        
    }
}
