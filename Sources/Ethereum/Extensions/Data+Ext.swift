//
//  File.swift
//  
//
//  Created by Ertem Biyik on 05.06.2022.
//

import Foundation

extension Data {
    
    var removeLeadingZeros: Data {
        var bytes = self.bytes
        while bytes.first == 0 {
            bytes.removeFirst()
        }
        return Data(bytes)
    }
    
    var removeTrailingZeros: Data {
        var bytes = self.bytes
        while bytes.last == 0 {
            bytes.removeLast()
        }
        return Data(bytes)
    }
}
