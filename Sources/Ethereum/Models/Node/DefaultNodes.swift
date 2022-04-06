import Foundation

public enum DefaultNodes {
    public static var mainnet = Node(url: URL(string: "https://mainnet.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!)
    public static let ropsten = Node(url: URL(string: "https://ropsten.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!)
    public static let rinkeby = Node(url: URL(string: "https://rinkeby.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!)
    public static let kovan = Node(url: URL(string: "https://kovan.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!)
    public static let goerli = Node(url: URL(string: "https://goerli.infura.io/v3/967cf8dc4a37411c8e62698c7c603cee")!)
}
