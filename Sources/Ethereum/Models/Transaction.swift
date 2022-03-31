import Foundation

// do we need a separate structure for signed transactions?
// 3 allowed structures: EIP-1559, EIP-2930 and Legacy Transaction
public struct Transaction: Codable, Signable {
    let blockHash: String
    let blockNumber: String
    let from: String
    let gas: String
    let gasPrice: String
    let hash: String
    let input: String
    let nonce: String
    let to: String
    let transactionIndex: String
    let value: String
    let type: String
    let v: String?
    let r: String?
    let s: String?
    
}

//240
