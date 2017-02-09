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
    
    // 乘法
    func mul(_ rhs: CGFloat) -> CGPoint {
        return CGPoint(x: self.x * rhs, y: self.y * rhs)
    }

    // 除法
    func div(_ rhs: CGFloat) -> CGPoint {
        return CGPoint(x: self.x / rhs, y: self.y / rhs)
    }
    
    // 长度
    func length() -> CGFloat {
        return sqrt(self.x * self.x + self.y * self.y)
    }

    // 完全反向
    func rev() -> CGPoint {
        return CGPoint(x: -self.x, y: -self.y)
    }

    // 反转x
    func refvX() -> CGPoint {
        return CGPoint(x: -self.x, y: self.y)
    }
    
    // 反转Y
    func revY() -> CGPoint {
        return CGPoint(x: self.x, y: -self.y)
    }
    
    func refX(_ target: CGPoint) -> CGPoint {
        let distance = target.x - self.x
        return CGPoint(x: self.x - distance, y: self.y)
    }
    
    func refY(_ target: CGPoint) -> CGPoint {
        let distance = target.y - self.y
        return CGPoint(x: self.x, y: self.y - distance)
    }
    
    func ceilf() -> CGPoint {
        return CGPoint(x: ceil(self.x), y: ceil(self.y))
    }
    
    func normalized() -> CGPoint {
        return self.div(self.length())
    }
    
    func dot(_ point: CGPoint) -> CGFloat {
        return self.x * point.x + self.y * point.y
    }
    
    func cross(_ point: CGPoint) -> CGFloat {
        return self.x * point.y - self.y * point.x
    }
    
    func split(_ point: CGPoint, ratio: CGFloat) -> CGPoint {
        return self.mul(ratio).plus(point.mul(1.0 - ratio))
    }
    
    func mid(_ point: CGPoint) -> CGPoint {
        return split(point, ratio: 0.5)
    }
    
    func areaSize(_ point: CGPoint) -> CGSize {
        return CGSize(width: abs(x - point.x), height: abs(y - point.y))
    }
    
    func area(_ point: CGPoint) -> CGFloat {
        let size = areaSize(point)
        return size.width * size.height
    }
    
    func origin(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: min(x, point.x), y: min(y, point.y))
    }
    
    static func intersection(_ from: CGPoint, to: CGPoint, from2: CGPoint, to2: CGPoint) -> CGPoint? {
        let ac = CGPoint(x: to.x - from.x, y: to.y - from.y)
        let bd = CGPoint(x: to2.x - from2.x, y: to2.y - from2.y)
        let ab = CGPoint(x: from2.x - from.x, y: from2.y - from.y)
        let bc = CGPoint(x: to.x - from2.x, y: to.y - from2.y)
        
        let area = bd.cross(ab)
        let area2 = bd.cross(bc)
        
        if abs(area + area2) >= 0.1 {
            let ratio = area / (area + area2)
            return CGPoint(x: from.x + ratio * ac.x, y: from.y + ratio * ac.y)
        }
        return nil
    }
    
    func toSize() -> CGSize {
        return CGSize(width: self.x, height: self.y)
    }
}
