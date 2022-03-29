//
//  File.swift
//  
//
//  Created by Ertem Biyik on 29.03.2022.
//

import Foundation

public struct Log: Codable {
    let address: String
    let topics: [String]
    let data: String
    let blockNumber: String
    let transactionHash: String
    let transactionIndex: String
    let blockHash: String
    let logIndex: String
    let removed: Bool
}
