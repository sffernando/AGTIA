//
//  CGRectEx.swift
//  LiquidLoader
//
//  Created by fernando on 2017/2/9.
//  Copyright © 2017年 fernando. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    var rightBottom: CGPoint {
        get {
            return CGPoint(x: origin.x + width, y: origin.y + height)
        }
    }
    
    var center: CGPoint {
        get {
            return origin.plus(rightBottom).mul(0.5)
        }
    }
}
