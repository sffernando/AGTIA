//
//  CGPointEx.swift
//  LiquidLoader
//
//  Created by fernando on 2017/2/8.
//  Copyright © 2017年 fernando. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    // 加法
    func plus(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + point.x, y: self.y + point.y)
    }
    
    func plusX(_ dx: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + dx, y: self.y)
    }
    
    func plusY(_ dy: CGFloat) -> CGPoint {
        return CGPoint(x: self.x, y: self.y + dy)
    }
    
    // 减法
    func minus(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - point.x, y: self.y - point.y)
    }
    
    func minusX(_ dx: CGFloat) -> CGPoint {
        return CGPoint(x: self.x - dx, y: self.y)
    }
    
    func minusY(_ dy: CGFloat) -> CGPoint {
        return CGPoint(x: self.x, y: self.y - dy)
    }

}
