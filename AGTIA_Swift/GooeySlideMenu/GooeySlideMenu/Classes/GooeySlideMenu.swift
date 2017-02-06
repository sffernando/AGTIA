//
//  GooeySlideMenu.swift
//  GooeySlideMenu
//
//  Created by fernando on 2017/2/5.
//  Copyright © 2017年 fernando. All rights reserved.
//

import UIKit

typealias MenuButtonClickedBlock = (_ index: Int, _ title: String) -> ()

struct MenuOptions {
    var titles: [String]
    var buttonHeight: CGFloat
    var menuColor: UIColor
    var blurStyle: UIBlurEffectStyle
    var buttonSpace: CGFloat
    var menuBlankWidth: CGFloat
    var menuClickBlock: MenuButtonClickedBlock
}


class GooeySlideMenu: UIView {

    fileprivate var options: MenuOptions
    fileprivate var keyWindow: UIWindow?
    fileprivate var blurView: UIVisualEffectView!
    fileprivate var helperSideView: UIView!
    fileprivate var helperCenterView: UIView!
    
    fileprivate var diff: CGFloat = 0.0
    fileprivate var triggered: Bool = false
    fileprivate var displayLink: CADisplayLink?
    fileprivate var animationCount: Int = 0
    
    init(options: MenuOptions) {
        self.options = options

        if let kWindow = UIApplication.shared.keyWindow {
            keyWindow = kWindow
            let frame = CGRect(x: -(keyWindow?.frame.size.width)!/2 - options.menuBlankWidth, y: 0, width: (keyWindow?.frame.size.width)!/2 + options.menuBlankWidth, height: (keyWindow?.frame.size.height)!)
            super.init(frame: frame)
        } else {
            super.init(frame: .zero)
        }
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: frame.width - options.menuBlankWidth, y: 0))
        path.addQuadCurve(to: CGPoint(x: frame.width - options.menuBlankWidth, y: frame.height), controlPoint: CGPoint(x: frame.width - options.menuBlankWidth + diff, y: frame.height/2))
        path.addLine(to: CGPoint(x: 0, y: frame.height));
        path.close()
        
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(path.cgPath)
        options.menuColor.set()
        context?.fillPath()
    }
    
    func trigger() {
        if triggered {
            tapToUntrigger()
        } else {
            if let keyWindow = keyWindow {
                keyWindow.insertSubview(blurView, belowSubview: self)
                UIView.animate(withDuration: 0.3, animations: { 
                    self.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width/2 + self.options.menuBlankWidth, height: keyWindow.frame.size.height)
                })
                
                beforeAnimation()
                
                UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.9, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                    self.helperSideView.center = CGPoint(x: keyWindow.center.x, y: self.helperSideView.frame.size.height/2)
                }, completion: { (finish) in
                    self.finishAnimation()
                })
                
                UIView.animate(withDuration: 0.3, animations: { 
                    self.blurView.alpha = 1.0
                })
                
                beforeAnimation()
                
                UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: { 
                    self.helperCenterView.center = keyWindow.center
                }, completion: { (finish) in
                    if finish {
                        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapToUntrigger))
                        self.blurView.addGestureRecognizer(tap)
                        self.finishAnimation()
                    }

                })
                
                animateButtons()
                triggered = true
            }
        }
    }
}


extension GooeySlideMenu {

    fileprivate func setUpViews() {
        if let keyWindow = keyWindow {
            blurView = UIVisualEffectView(effect: UIBlurEffect(style: options.blurStyle))
            blurView.frame = keyWindow.frame
            blurView.alpha = 0.0
            
            helperSideView = UIView(frame: CGRect(x: -40, y: 0, width: 40, height: 40))
            helperSideView.backgroundColor = UIColor.red
            helperSideView.isHidden = true
            keyWindow.addSubview(helperSideView)
            
            helperCenterView = UIView(frame: CGRect(x: -40, y: keyWindow.frame.height/2 - 20, width: 40, height: 40))
            helperCenterView.backgroundColor = UIColor.yellow
            helperCenterView.isHidden = true
            keyWindow.addSubview(helperCenterView)
            
            frame = CGRect(x: -keyWindow.frame.size.width/2 - options.menuBlankWidth, y: 0, width: keyWindow.frame.size.width/2+options.menuBlankWidth, height: keyWindow.frame.size.height);
            self.backgroundColor = UIColor.clear;
            backgroundColor = UIColor.clear
            keyWindow.insertSubview(self, belowSubview: helperSideView)
            addButton()
        }
    }
    
    fileprivate func addButton() {
        let titles = options.titles
        if titles.count % 2 == 0 {
            var index_down = titles.count / 2
            var index_up = -1
            for i in 0..<titles.count {
                let title = titles[i]
                let buttonOption = MenuButtonOptions(title: title, buttonColor: options.menuColor, buttonClickBlock: { [weak self] () -> () in
                    self?.tapToUntrigger()
                    self?.options.menuClickBlock(i, title)
                })
                
                let home_button = SlideMenuButton(option: buttonOption)
                home_button.bounds = CGRect(x: 0, y: 0, width: frame.width - options.menuBlankWidth - 20 * 2, height: options.buttonHeight)
                addSubview(home_button)
                if i >= titles.count / 2 {
                    index_up += 1
                    let y = frame.height/2 + options.buttonHeight * CGFloat(index_up) + options.buttonSpace*CGFloat(index_up)
                    home_button.center = CGPoint(x: (frame.width - options.menuBlankWidth)/2, y: y + options.buttonSpace/2 + options.buttonHeight/2)
                } else {
                    index_down -= 1
                    let y = frame.height/2 - options.buttonHeight*CGFloat(index_down) - options.buttonSpace*CGFloat(index_down)
                    home_button.center = CGPoint(x: (frame.width - options.menuBlankWidth)/2, y: y - options.buttonSpace/2 - options.buttonHeight/2)
                }
            }
        } else {
            var index = titles.count / 2 + 1
            for i in 0..<titles.count {
                index -= 1
                let title = titles[i]
                let buttonOption = MenuButtonOptions(title: title, buttonColor: options.menuColor, buttonClickBlock: { [weak self] () -> () in
                    self?.tapToUntrigger()
                    self?.options.menuClickBlock(i, title)
                })
                let home_button = SlideMenuButton(option: buttonOption)
                home_button.bounds = CGRect(x: 0, y: 0, width: frame.width - options.menuBlankWidth - 20 * 2, height: options.buttonHeight)
                home_button.center = CGPoint(x: (frame.width - options.menuBlankWidth)/2, y: frame.height/2 - options.buttonHeight*CGFloat(index) - 20 * CGFloat(index))
                addSubview(home_button)
            }
        }
    }
    
    fileprivate func animateButtons() {
        for i in 0..<subviews.count {
            let menuButton = subviews[i]
            menuButton.transform = CGAffineTransform(translationX: -90, y: 0)
            UIView.animate(withDuration: 0.7, delay: Double(i)*(0.3)/Double(subviews.count), usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: { 
                menuButton.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    @objc fileprivate func tapToUntrigger() {
        UIView.animate(withDuration: 0.3) { 
            self.frame = CGRect(x: -((self.keyWindow?.frame.width)!/2 - self.options.menuBlankWidth), y: 0, width: (self.keyWindow?.frame.size.width)!/2 + self.options.menuBlankWidth, height: (self.keyWindow?.frame.size.height)!)
        }
        beforeAnimation()
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.9, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
            self.helperSideView.center = CGPoint(x:-self.helperSideView.frame.width/2, y: self.helperSideView.frame.size.height/2)
        }, completion: { (finish) in
            self.finishAnimation()
        })
        
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView.alpha = 0.0
        })
        
        beforeAnimation()
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
            self.helperCenterView.center = CGPoint(x: -self.helperCenterView.frame.height/2, y: self.frame.size.height/2)
        }, completion: { (finish) in
            if finish {
                self.finishAnimation()
            }
            
        })
        triggered = false
    }
    
    fileprivate func beforeAnimation() {
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLinkAction(displaylink:)))
            displayLink?.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
        }
        animationCount += 1
    }
    
    fileprivate func finishAnimation() {
        animationCount -= 1
        if animationCount == 0 {
            displayLink?.invalidate()
            displayLink = nil
        }
    }
    
    @objc fileprivate func handleDisplayLinkAction(displaylink: CADisplayLink) {

        let sideHLayer = helperSideView.layer.presentation()
        let centerHLayer = helperCenterView.layer.presentation()
        
        let cr = (centerHLayer?.value(forKeyPath: "frame") as AnyObject).cgRectValue
        let sr = (sideHLayer?.value(forKeyPath: "frame") as AnyObject).cgRectValue
        
        diff = (sr?.origin.x)! - (cr?.origin.x)!
        
        setNeedsDisplay()
    }
    

}

