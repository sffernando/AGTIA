//
//  CircularGradientLayer.swift
//  LiquidLoader
//
//  Created by fernando on 2017/2/10.
//  Copyright © 2017年 fernando. All rights reserved.
//

import Foundation
import UIKit

class CircularGradientLayer: CALayer {
    let colors: [UIColor]
    init(colors: [UIColor]) {
        self.colors = colors
        super.init()
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in ctx: CGContext) {
        var locations = CGMath.lineSpace(0.0, to: 1.0, n: colors.count)
        locations = Array(locations.map { 1.0 - $0 * $0 }.reversed())
        
        let cols = colors.map { $0.cgColor }
        let gradients = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cols as CFArray, locations: locations)
        
        ctx.drawRadialGradient(gradients!, startCenter: self.frame.center, startRadius: CGFloat(0.0), endCenter: self.frame.center, endRadius: max(self.frame.width, self.frame.height), options: CGGradientDrawingOptions(rawValue: 10))
    }
}
