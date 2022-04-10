//
//  File.swift
//  
//
//  Created by Ertem Biyik on 06.04.2022.
//

import Foundation
import BigInt

enum Utils {
    
    public static func ethFromWei(_ wei: String) -> String {
        
        var eth = ""
        
        var counter = 0
        
        for char in wei.reversed() {
            if counter < 17 {
                eth.insert(char, at: eth.startIndex)
            } else if counter == 18 {
                eth.insert(".", at: eth.startIndex)
                eth.insert(char, at: eth.startIndex)
            } else {
                eth.insert(char, at: eth.startIndex)
            }
            counter += 1
        }
        
        if eth.count <= 18 {
            let zerosLeft = String(repeating: "0", count: 18 - eth.count)
            eth.insert(contentsOf: "0." + zerosLeft, at: eth.startIndex)
        }
        
        return eth
    }
    
    private static func convert(value: String, base: Int) -> String {
        
        var eth = "0."
        
        if value.count < base {
            let zerosLeft = String(repeating: "0", count: base - value.count)
            eth.append(contentsOf: zerosLeft + value)
        } else {
            let unsignedIndex = value.index(value.startIndex, offsetBy: value.count - base)
            let unsigned = value[value.startIndex..<unsignedIndex]
            let other = String(value[unsignedIndex...])
            eth.append(contentsOf: other)
            eth.removeFirst()
            eth = unsigned + eth
        }
        
        return eth
    }
    
    public static func weiFromEth(_ eth: String) -> String {
        let valueAfterDotStartIndex = eth.index(eth.startIndex, offsetBy: 2)
        let valueAfterDot = eth[valueAfterDotStartIndex...]
        
        var counterOfZeros = 0
        var isBeforeNum = true
        var wei = ""
        for char in valueAfterDot {
            if isBeforeNum {
                if char == "0" {
                    counterOfZeros += 1
                    
                } else {
                    isBeforeNum = false
                    wei += String(char)
                }
            }
            
            wei += String(char)
        }
        
        let zeros = String(repeating: "0", count: counterOfZeros)
        
        wei += zeros
        
        return wei
    }
}

extension String {
    
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
