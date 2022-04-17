//
//  File.swift
//  
//
//  Created by Ertem Biyik on 29.03.2022.
//

import Foundation

public struct Log: Codable {
    public let address: String
    public let topics: [String]
    public let data: String
    public let blockNumber: String
    public let transactionHash: String
    public let transactionIndex: String
    public let blockHash: String
    public let logIndex: String
    public let removed: Bool
}
