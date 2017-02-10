//
//  UIView+Grow.swift
//  LiquidLoader
//
//  Created by fernando on 2017/2/9.
//  Copyright © 2017年 fernando. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
//    func grow(_ baseColor: UIColor, radius: CGFloat, shininess: CGFloat) {
//        guard let sublayers = layer.sublayers as? [CAShapeLayer]  else { return }
//        
//        let growColor = UIColor(red: 0 / 255.0, green: 1, blue: 1, alpha: 1.0)
//        growShadow(radius, growColor: growColor, shininess: shininess)
//        let circle = CAShapeLayer()
//        circle.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius * 2.0, height: radius * 2.0)).cgPath
//        let circleGradient = CircularGradientLayer(colors: [growColor, UIColor(white: 1.0, alpha: 0)])
//        circleGradient.frame = CGRect(x: 0, y: 0, width: radius * 2.0, height: radius * 2.0)
//        circleGradient.opacity = 0.25
//        for sub in sublayers {
//            sub.fillColor = UIColor.clear.cgColor
//        }
//        circleGradient.mask = circle
//        layer.addSublayer(circleGradient)
//    }

    
    func growShadow(_ radius: CGFloat, growColor: UIColor, shininess: CGFloat) {
        let origin = self.center.minus(self.frame.origin).minus(CGPoint(x: radius * shininess, y: radius * shininess))
        let ovalRect = CGRect(origin: origin, size: CGSize(width: 2 * radius * shininess, height: 2 * radius * shininess))
        let shadowPath = UIBezierPath(ovalIn: ovalRect)
        self.layer.shadowColor = growColor.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.shadowOpacity = 1.0
        self.layer.shouldRasterize = true
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
}
