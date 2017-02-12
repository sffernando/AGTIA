//
//  ObjC.swift
//  LiquidLoader
//
//  Created by fernando on 2017/2/11.
//  Copyright © 2017年 fernando. All rights reserved.
//

import Foundation
import UIKit

@objc public enum ObjCEffect: Int {
    case line
    case circle
    case growLine
    case growCircle
}

extension LiquidLoader {
    @objc public convenience init(frame: CGRect, effect: ObjCEffect, color: UIColor, numberOfCircle: Int, duration: CGFloat, growColor: UIColor? = UIColor.red) {
//        var s = Effect
        
    }
}

//extension LiquidLoader {
//    
//    @objc public convenience init(frame: CGRect, effect: ObjCEffect, color: UIColor, numberOfCircle: Int, duration: CGFloat, growColor: UIColor? = UIColor.red) {
//        var s: Effect
//        
//        if effect == .line {
//            s = Effect.Line(color, numberOfCircle, duration, growColor)
//        } else if effect == .circle {
//            s = Effect.Circle(color, numberOfCircle, duration, growColor)
//        } else if effect == .growLine {
//            s = Effect.GrowLine(color, numberOfCircle, duration, growColor)
//        } else { //if effect == .GrowCircle {
//            s = Effect.GrowCircle(color, numberOfCircle, duration, growColor)
//        }
//        
//        self.init(frame: frame, effect: s)
//    }
//    
//}
