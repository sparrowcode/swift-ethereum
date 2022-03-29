import Foundation

public struct Block: Codable {
    let difficulty: String
    let extraData: String?
    let gasLimit: String
    let gasUsed: String
    let hash: String
    let logsBloom: String
    let miner: String
    let mixHash: String
    let nonce: String
    let number: String
    let parentHash: String
    let receiptsRoot: String
    let sha3Uncles: String
    let size: String
    let stateRoot: String
    let timestamp: String
    let totalDifficulty: String?
    let transactionsRoot: String
    let transactions: [String]?
    let uncles: [String]?
}

//304
