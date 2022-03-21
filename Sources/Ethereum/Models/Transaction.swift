import Foundation

public struct Transaction {
    
    public let from: String?
    public let to: String // recipient
    public let value: String?
    public let data: String?
    public var nonce: Int // the transaction index
    public let gasPrice: String
    public let gasLimit: String
    public let gas: String
    public let blockNumber: String?
    public var hash: String?
    public var chainId: String?
    private var v: String?
    private var r: String?
    private var s: String?
    //    This fields is components of an ECDSA digital signature of the originating EOA. Ethereum transactions use ECDSA(Elliptic Curve Digital Signature Algorithm) as its digital signature for verification. v indicates two things: the chain ID and the recovery ID to help the ECDSArecover function check the signature. r and s are inputs of ECDSA to generate a signature. If you want to know more details, please refer to another resource like here.
    
    // methods from ethereum service which are related to transaction
    
}
