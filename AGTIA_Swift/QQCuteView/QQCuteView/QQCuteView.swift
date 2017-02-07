//
//  QQCuteView.swift
//  QQCuteView
//
//  Created by fernando on 2017/2/6.
//  Copyright © 2017年 fernando. All rights reserved.
//

import UIKit

struct BubbleOptions {
    var text: String = ""
    var bubbleWidth: CGFloat = 0.0
    var viscosity: CGFloat = 0.0
    var bubbleColor: UIColor = UIColor.white
}

class QQCuteView: UIView {

    var frontView: UIView?
    var bubbleOptions: BubbleOptions {
        didSet {
            bubbleLabel.text = bubbleOptions.text
        }
    }
    
    private var bubbleLabel: UILabel!
    private var containerView: UIView!

    private var cutePath: UIBezierPath!
    private var fillColorForCute: UIColor!
    private var animator: UIDynamicAnimator!
    private var snap: UISnapBehavior!
    private var backView: UIView!
    private var shapeLayer: CAShapeLayer!
    
    private var r1: CGFloat = 0.0
    private var r2: CGFloat = 0.0
    private var x1: CGFloat = 0.0
    private var y1: CGFloat = 0.0
    private var x2: CGFloat = 0.0
    private var y2: CGFloat = 0.0
    private var centerDistance: CGFloat = 0.0
    private var cosDigree: CGFloat = 0.0
    private var sinDigree: CGFloat = 0.0
    
    private var pointA = CGRect.zero
    private var pointB = CGRect.zero
    private var pointC = CGRect.zero
    private var pointD = CGRect.zero
    private var pointO = CGRect.zero
    private var pointP = CGRect.zero
    
    private var initialPoint: CGPoint = CGPoint.zero
    private var oldBackViewFrame: CGRect = CGRect.zero
    private var oldBackViewCenter: CGPoint = CGPoint.zero

    init(point: CGPoint, superView: UIView, options: BubbleOptions) {
        bubbleOptions = options
        super.init(frame: CGRect(x: point.x, y: point.y, width: options.bubbleWidth, height: options.bubbleWidth))
        initialPoint = point
        containerView = superView
        containerView.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
