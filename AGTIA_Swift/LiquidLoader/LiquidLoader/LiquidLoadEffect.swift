//
//  LiquidLoadEffect.swift
//  LiquidLoader
//
//  Created by fernando on 2017/2/19.
//  Copyright © 2017年 fernando. All rights reserved.
//

import Foundation
import UIKit

class LiquidLoadEffect: NSObject {
    var numberOfCircles: Int
    var duration: CGFloat
    var circleScale: CGFloat = 1.17
    var moveScale: CGFloat = 0.80
    var color = UIColor.white
    var growColor = UIColor.red
    
    var engine: SimpleCircleLiquidEngine?
    var moveCircle: LiquittableCircle?
    var shadowCircle: LiquittableCircle?
    
    var timer: CADisplayLink?
    
    weak var loader: LiquidLoader!
    
    var isGrow = false {
        didSet {
            grow(isGrow)
        }
    }

    /* the following properties is initialized when frame is assigned */
    var circles: [LiquittableCircle]!
    var circleRadius: CGFloat!
    
    var key: CGFloat = 0.0 {
        didSet {
            updateKeyframe(key)
        }
    }
    
    /* the following properties is initialized when frame is assigned */
//    var circles: [LiquittableCircle]!
//    var circleRadius: CGFloat!
//    
//    var key: CGFloat = 0.0 {
//        didSet {
//            updateKeyframe(self.key)
//        }
//    }
    
    init(loader: LiquidLoader, color: UIColor, circleCount: Int, duration: CGFloat, growColor: UIColor? = UIColor.red) {
        self.numberOfCircles = circleCount
        self.duration = duration
        self.circleRadius = loader.frame.width * 0.05
        self.loader = loader
        self.color = color
        if growColor != nil {
            self.growColor = growColor!
        }
        super.init()
        setup()
    }
    
//    init(loader: LiquidLoader, color: UIColor, circleCount: Int, duration: CGFloat, growColor: UIColor? = UIColor.red) {
//        self.numberOfCircles = circleCount
//        self.duration = duration
//        self.circleRadius = loader.frame.width * 0.05
//        self.loader = loader
//        self.color = color
//        if growColor != nil {
//            self.growColor = growColor!
//        }
//        super.init()
//        setup()
//    }
    
    func setup() {
        
    }
    
    func updateKeyframe(_ key: CGFloat) {
        
    }
    
    func grow(_ isGrow: Bool) {
        
    }
}
