//
//  ViewController.swift
//  QQCuteView
//
//  Created by fernando on 2017/2/6.
//  Copyright © 2017年 fernando. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var option = BubbleOptions()
        option.viscosity = 20.0
        option.bubbleWidth = 35.0
        option.bubbleColor = UIColor(displayP3Red: 0.0, green: 0.722, blue: 1.0, alpha: 1.0)
        
        let cuteView = QQCuteView(point: CGPoint(x: 25, y: UIScreen.main.bounds.height - 65), superView: view, options: option)
        option.text = "88"
        cuteView.bubbleOptions = option
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

