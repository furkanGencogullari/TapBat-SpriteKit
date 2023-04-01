//
//  CGFloatExtensions.swift
//  TapBat
//
//  Created by Furkan Gençoğulları on 1.04.2023.
//

import CoreGraphics

extension CGFloat {
    public static func random() -> CGFloat {
        
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        
    }
    
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
    
    
    func clamped(v1: CGFloat, _ v2: CGFloat) -> CGFloat {
        let min = v1 < v2 ? v1 : v2
        let max = v1 > v2 ? v1 : v2
        return self < min ? min : (self > max ? max : self)
    }
    
    
    mutating func clamp(v1: CGFloat, _ v2: CGFloat)  {
        self = clamped(v1: v1, v2)
    }
    
    func degreesToRadians() -> CGFloat {
        return CGFloat.pi * self / 180.0
    }
    
}
