//
//  File.swift
//  
//
//  Created by Ertem Biyik on 05.06.2022.
//

import Foundation

public extension String {
    
    func removeHexPrefix() -> String {
        
        if self.hasPrefix("0x") {
            let index = self.index(self.startIndex, offsetBy: 2)
            return String(self[index...])
        }
        
        return self
    }
    
    func addHexPrefix() -> String {
        
        if self.hasPrefix("0x") {
            return self
        }
        
        return "0x" + self
    }
}
