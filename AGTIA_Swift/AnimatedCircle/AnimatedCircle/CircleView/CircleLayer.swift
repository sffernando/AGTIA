//
//  CircleLayer.swift
//  AnimatedCircle
//
//  Created by fernando on 2017/2/3.
//  Copyright © 2017年 fernando. All rights reserved.
//

import UIKit

enum MovingPoint {
    case Point_B
    case Point_D
}

// 外接矩形的长(宽)
let outsideRectSize: CGFloat = 90

class CircleLayer: CALayer {
    var progress: CGFloat = 0.0 {
        didSet {
            // 外接矩形在左侧，则改变B点，反之在右边，则改变D点
            if progress <= 0.5 {
                movePoint = .Point_B
                print("B点动")
            } else {
                movePoint = .Point_D
                print("D点动")
            }
            
            self.lastProgress = progress
            
            let buff = (progress - 0.5) * (frame.size.width - outsideRectSize)
            let x = position.x - outsideRectSize/2 + buff
            let y = position.y - outsideRectSize/2
            outsideRect = CGRect(x: x, y: y, width: outsideRectSize, height: outsideRectSize)
            
            setNeedsDisplay()
        }
    }
    
    private var outsideRect: CGRect!
    private var lastProgress: CGFloat = 0.5
    private var movePoint: MovingPoint!
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? CircleLayer {
            progress = layer.progress
            lastProgress = layer.lastProgress
            outsideRect = layer.outsideRect
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(in ctx: CGContext) {

        let offset = outsideRect.size.width / 3.6
        let movedDistance = (outsideRect.size.width / 6) * fabs(self.progress - 0.5) * 2
        let rectCenter = CGPoint(x: outsideRect.origin.x + outsideRect.size.width/2, y: outsideRect.origin.y + outsideRect.size.height/2)
        
        
        let pointA = CGPoint(x: rectCenter.x, y: outsideRect.origin.y + movedDistance)
        let pointB = CGPoint(x: movePoint == .Point_D ? rectCenter.x + outsideRect.size.width/2 : rectCenter.x + outsideRect.size.width/2 + movedDistance * 2, y: rectCenter.y)
        let pointC = CGPoint(x: rectCenter.x, y: rectCenter.y + outsideRect.size.height/2 - movedDistance)
        let pointD = CGPoint(x: movePoint == .Point_D ? rectCenter.x - outsideRect.size.width/2 - movedDistance * 2 : rectCenter.x - outsideRect.size.width/2, y: rectCenter.y)
    
        
        let c1 = CGPoint(x: pointA.x + offset, y: pointA.y)
        let c2 = CGPoint(x: pointB.x, y: movePoint == .Point_D ? pointB.y - offset : pointB.y - offset + movedDistance)
        let c3 = CGPoint(x: pointB.x, y: movePoint == .Point_D ? pointB.y + offset : pointB.y + offset - movedDistance)
        let c4 = CGPoint(x: pointC.x + offset, y: pointC.y)
        let c5 = CGPoint(x: pointC.x - offset, y: pointC.y)
        let c6 = CGPoint(x: pointD.x, y: movePoint == .Point_D ? pointD.y + offset - movedDistance : pointD.y + offset)
        let c7 = CGPoint(x: pointD.x, y: movePoint == .Point_D ? pointD.y - offset + movedDistance : pointD.y - offset)
        let c8 = CGPoint(x: pointA.x - offset, y: pointA.y)
        
        // 绘制外接虚线矩形
        let rectPath = UIBezierPath(rect: outsideRect)
        ctx.addPath(rectPath.cgPath)
        ctx.setStrokeColor(UIColor.black.cgColor)
        ctx.setLineWidth(1.0)
        let dash = [CGFloat(5.0), CGFloat(5.0)]
        ctx.setLineDash(phase: 0, lengths: dash)
        ctx.strokePath()

        
        // 圆的边界
        let ovalPath = UIBezierPath()
        ovalPath.move(to: pointA)
        ovalPath.addCurve(to: pointB, controlPoint1: c1, controlPoint2: c2)
        ovalPath.addCurve(to: pointC, controlPoint1: c3, controlPoint2: c4)
        ovalPath.addCurve(to: pointD, controlPoint1: c5, controlPoint2: c6)
        ovalPath.addCurve(to: pointA, controlPoint1: c7, controlPoint2: c8)
        ovalPath.close()
        
        ctx.addPath(ovalPath.cgPath)
        ctx.setStrokeColor(UIColor.black.cgColor)
        ctx.setFillColor(UIColor.blue.cgColor)
        ctx.setLineDash(phase: 0, lengths: [])
        ctx.drawPath(using: .fillStroke)
        
        //标记出每个点并连线，方便观察，给所有关键点染色 -- 黄色,辅助线颜色 -- 绿色
        ctx.setFillColor(UIColor.yellow.cgColor)
        ctx.setStrokeColor(UIColor.green.cgColor)
        let points = [NSValue(cgPoint: pointA),NSValue(cgPoint: c1),NSValue(cgPoint: c2),NSValue(cgPoint: pointB),NSValue(cgPoint: c3),NSValue(cgPoint: c4),NSValue(cgPoint: pointC),NSValue(cgPoint: c5),NSValue(cgPoint: c6),NSValue(cgPoint: pointD),NSValue(cgPoint: c7),NSValue(cgPoint: c8)];
        // 填充点
        drawPoint(points: points, ctx: ctx)
        // 连接点
        let helperLine = UIBezierPath()
        helperLine.move(to: pointA)
        helperLine.addLine(to: c1)
        helperLine.addLine(to: c2)
        helperLine.addLine(to: pointB)
        helperLine.addLine(to: c3)
        helperLine.addLine(to: c4)
        helperLine.addLine(to: pointC)
        helperLine.addLine(to: c5)
        helperLine.addLine(to: c6)
        helperLine.addLine(to: pointD)
        helperLine.addLine(to: c7)
        helperLine.addLine(to: c8)
        helperLine.addLine(to: pointA)
        
        ctx.addPath(helperLine.cgPath)
        let dash2 = [CGFloat(2.0), CGFloat(2.0)]
        ctx.setLineDash(phase: 0, lengths: dash2)
        ctx.strokePath()
    }
    
    private func drawPoint(points: [NSValue], ctx: CGContext) {
        for pointValue in points {
            let point = pointValue.cgPointValue
            ctx.fill(CGRect(x: point.x - 2, y: point.y - 2, width: 4, height: 4))
        }
    }
}
