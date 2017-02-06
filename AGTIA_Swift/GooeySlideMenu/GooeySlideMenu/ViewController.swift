//
//  ViewController.swift
//  GooeySlideMenu
//
//  Created by fernando on 2017/2/5.
//  Copyright © 2017年 fernando. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var menu: GooeySlideMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "首页"
        let menuOptions = MenuOptions(titles: ["首页", "消息", "发现", "设置", "我的"],
                                      buttonHeight: 40.0,
                                      menuColor: UIColor(red: 0.0, green: 0.722, blue: 1.0, alpha: 1.0),
                                      blurStyle: .dark,
                                      buttonSpace: 30.0,
                                      menuBlankWidth: 50.0) { (index, title) in
                                        print("index:\(index) title:\(title)")
        }
        menu = GooeySlideMenu(options: menuOptions)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func trgger(_ sender: Any) {
        menu?.trigger()
    }

}

