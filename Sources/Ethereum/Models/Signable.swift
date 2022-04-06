//
//  File.swift
//  
//
//  Created by Ertem Biyik on 05.04.2022.
//

import Foundation

public protocol Signable {
    var rawData: Data? { get }
}

enum SignError: Error {
    case invalidData
}
