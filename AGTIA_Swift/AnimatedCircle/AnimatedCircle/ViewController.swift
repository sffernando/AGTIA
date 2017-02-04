//
//  ViewController.swift
//  AnimatedCircle
//
//  Created by fernando on 2017/2/3.
//  Copyright © 2017年 fernando. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func valueChanged(_ sender: UISlider) {
        valueLabel.text = "current progress: \(sender.value)"
        circleView.circleLayer.progress = CGFloat(sender.value)
    }

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var valueLabel: UILabel!
    private var circleView: CircleView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        circleView = CircleView(frame: CGRect(x: view.frame.size.width/2 - 160, y: view.frame.size.height/2 - 160, width: 320, height: 320))
        view.addSubview(circleView)
        circleView.circleLayer.progress = CGFloat(slider.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

