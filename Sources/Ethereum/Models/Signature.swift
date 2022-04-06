import Foundation

public struct Signature {
    
    public let data: Data
    public var v: Int
    public let r: Data
    public let s: Data
    
    public init(_ signedData: Data) {
        self.data = signedData
        self.v = Int(signedData[64])
        self.r = signedData.subdata(in: 0..<32)
        self.s = signedData.subdata(in: 32..<64)
    }
    
    public mutating func calculateV(with chainID: Int?) {
        if v < 37 {
            v += (chainID ?? -1) * 2 + 35
        }
    }
    
}