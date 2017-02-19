//
//  LiquittableCircle.swift
//  LiquidLoader
//
//  Created by fernando on 2017/2/19.
//  Copyright © 2017年 fernando. All rights reserved.
//

import UIKit

class LiquittableCircle: UIView {

    var points: [CGPoint] = []
    var isGrow = false {
        didSet {
            grow(isGrow: isGrow)
        }
    }
    
    var radius: CGFloat {
        didSet {
            setUp()
        }
    }
    
    var color: UIColor = UIColor.red
    var growColor: UIColor = UIColor.white
    
    init(center: CGPoint, radius: CGFloat, color: UIColor, growColor: UIColor?) {
        let frame = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
        self.radius = radius
        self.color = color
        if growColor != nil {
            self.growColor = growColor!
        }
        
        super.init(frame: frame)
        setUp()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        
    }
    
    func grow(isGrow: Bool) {
        
    }
}
