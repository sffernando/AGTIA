//
//  SlideMenuButton.swift
//  GooeySlideMenu
//
//  Created by fernando on 2017/2/5.
//  Copyright © 2017年 fernando. All rights reserved.
//

import UIKit

struct MenuButtonOptions {
    var title: String
    var buttonColor: UIColor
    var buttonClickBlock: ()->()
}

class SlideMenuButton: UIView {
    private var option: MenuButtonOptions
    
    init(option: MenuButtonOptions) {
        self.option = option
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.addRect(rect)
        option.buttonColor.set()
        context?.fillPath()
        
        let roundedRectanglePath = UIBezierPath(roundedRect: rect.insetBy(dx: 1, dy: 1), cornerRadius: rect.height / 2)
        option.buttonColor.setFill()
        roundedRectanglePath.fill()
        UIColor.white.setStroke()
        roundedRectanglePath.lineWidth = 1
        roundedRectanglePath.stroke()
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = .center
        let attr = [NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName: UIFont.systemFont(ofSize: 24), NSForegroundColorAttributeName: UIColor.white]
        let size = option.title.size(attributes: attr);
        
        let r = CGRect(x: rect.origin.x, y: rect.origin.y + (rect.size.height - size.height)/2.0, width: rect.size.width, height: size.height)
        option.title.draw(with: r, options: .usesLineFragmentOrigin, attributes: attr, context: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let touch = touch {
            let tapCount = touch.tapCount
            switch tapCount {
            case 1:
                option.buttonClickBlock()
            default:
                break
            }
        }
    }
}
