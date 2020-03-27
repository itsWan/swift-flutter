//
//  SecondNativeViewController.swift
//  ios_app
//
//  Created by zhangwanqing on 2020/3/25.
//  Copyright © 2020 zhangwanqing. All rights reserved.
//

import UIKit

typealias ReturnStrBlock = (_ message: String)->Void
class SecondNativeViewController: UIViewController {
    
    var showMessage = ""
    var lblTitle: UILabel!
    var returnStrBlock: ReturnStrBlock?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(displayP3Red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: CGFloat(arc4random_uniform(255))/255.0)

        let label = UILabel.init()
        label.frame = CGRect.init(x: 0, y: 200, width: self.view.frame.width, height: 44)
        label.textAlignment = .center
        label.text = self.showMessage
        self.view.addSubview(label)
        
        let button = UIButton.init()
        button.frame = CGRect.init(x: 0, y: 300, width: self.view.frame.width, height: 44)
        button.setTitle("返回Flutter页面", for: .normal)
        button.addTarget(self, action: #selector(didPressedBackFlutter), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func didPressedBackFlutter(){
        if returnStrBlock != nil {
            self.returnStrBlock!("嗨，本文案来自第二个原生页面，将在Flutter页面看到我")
        }
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
