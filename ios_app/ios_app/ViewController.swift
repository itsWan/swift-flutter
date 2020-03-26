//
//  ViewController.swift
//  ios_app
//
//  Created by zhangwanqing on 2020/3/24.
//  Copyright © 2020 zhangwanqing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.init(displayP3Red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: CGFloat(arc4random_uniform(255))/255.0)
        
        label = UILabel.init()
        label.frame = CGRect.init(x: 0, y: 200, width: self.view.frame.width, height: 44)
        label.text = "App第一个页面初始文案"
        label.textColor = UIColor.white
        label.textAlignment = .center
        self.view.addSubview(label)
        
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 44)
        button.center = self.view.center
        button.setTitle("嗨，本文案来自App第一个页面，将在第一个原生页面看到我", for: .normal)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func buttonClick() {
        let firstNativeVC = FirstNativeViewController.init()
        firstNativeVC.modalPresentationStyle = .fullScreen
        firstNativeVC.returnStrBlock = { (message : String) -> Void in
            self.label.text = message
        }
        self.present(firstNativeVC, animated: true, completion: nil)
    }


}

