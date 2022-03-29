import Foundation

public struct Receipt: Codable {
    let blockHash: String
    let blockNumber: String
    let contractAddress: String?
    let cumulativeGasUsed: String
    let effectiveGasPrice: String
    let from: String
    let gasUsed: String
    let logs: [Log]
    let logsBloom: String
    let status: String?
    let to: String?
    let root: String?
    let transactionHash: String
    let transactionIndex: String
    let type: String
}

