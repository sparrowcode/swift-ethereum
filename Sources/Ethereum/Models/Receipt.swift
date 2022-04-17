import Foundation

public struct Receipt: Codable {
    public let blockHash: String
    public let blockNumber: String
    public let contractAddress: String?
    public let cumulativeGasUsed: String
    public let effectiveGasPrice: String
    public let from: String
    public let gasUsed: String
    public let logs: [Log]
    public let logsBloom: String
    public let status: String?
    public let to: String?
    public let root: String?
    public let transactionHash: String
    public let transactionIndex: String
    public let type: String
}

