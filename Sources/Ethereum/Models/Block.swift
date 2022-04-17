import Foundation

public struct Block: Codable {
    public let difficulty: String
    public let extraData: String?
    public let gasLimit: String
    public let gasUsed: String
    public let hash: String
    public let logsBloom: String
    public let miner: String
    public let mixHash: String
    public let nonce: String
    public let number: String
    public let parentHash: String
    public let receiptsRoot: String
    public let sha3Uncles: String
    public let size: String
    public let stateRoot: String
    public let timestamp: String
    public let totalDifficulty: String?
    public let transactionsRoot: String
    public let transactions: [String]?
    public let uncles: [String]?
}

//304
