//
//  FirstNativeViewController.swift
//  ios_app
//
//  Created by zhangwanqing on 2020/3/25.
//  Copyright © 2020 zhangwanqing. All rights reserved.
//

import UIKit

class FirstNativeViewController: UIViewController {
    
    final let CHANNEL_NATIVE = "com.example.flutter/native"
    final let CHANNEL_FLUTTER = "com.example.flutter/flutter"
    var flutterViewController: FlutterViewController!
    var  sMessageFromFlutter = ""
    var returnStrBlock: ReturnStrBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(displayP3Red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: CGFloat(arc4random_uniform(255))/255.0)

        // Do any additional setup after loading the view.
        let button1 = UIButton.init(type: .custom)
        button1.setTitle("打开flutter页面", for: .normal)
        button1.frame = CGRect.init(x: 35, y: 200, width: 300, height: 44)
        self.view.addSubview(button1)
        button1.addTarget(self, action: #selector(button1Click), for: .touchUpInside)
        
        let button2 = UIButton.init(type: .custom)
        button2.setTitle("返回App第一个页面", for: .normal)
        button2.frame = CGRect.init(x: 35, y: 300, width: 300, height: 44)
        self.view.addSubview(button2)
        button2.addTarget(self, action: #selector(button2Click), for: .touchUpInside)
        
    }
    
    @objc func button1Click(){
//        weak var weakSelf = self
        flutterViewController = FlutterViewController.init()
        flutterViewController.setInitialRoute("route1?{\"message\":\"嗨，本文案来自第一个原生页面，将在Flutter页面看到我\"}")
        //初始化messageChannel，CHANNEL_NATIVE为iOS和Flutter两端统一的通信信号
        let binaryMessenger = flutterViewController as! FlutterBinaryMessenger
        let messageChannel = FlutterMethodChannel.init(name: CHANNEL_NATIVE, binaryMessenger: binaryMessenger )
        messageChannel.setMethodCallHandler { ( call: FlutterMethodCall,  result: FlutterResult) in
            if call.method == "openSecondNative" {
                let dict = call.arguments as!  [String: String]
                self.sMessageFromFlutter = dict["message"]!
                self.pushSecondNative()
                result("成功打开第二个原生页面")
            }else if call.method == "backFirstNative" {
                let dict = call.arguments as! [String: String]
                self.sMessageFromFlutter = dict["message"]!
                self.backFirstNative()
                result("成功返回第一个原生页面")
            }
        }
        flutterViewController.modalPresentationStyle = .fullScreen
        self.present(flutterViewController, animated: true, completion: nil)
    }
    
    @objc func button2Click(){
        if (self.returnStrBlock != nil) {
            self.returnStrBlock!("嗨，本文案来自第一个原生页面，将在App第一个页面看到我")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //打开第二个原生页面
    func pushSecondNative() {
        let secondNativeVC = SecondNativeViewController.init()
        secondNativeVC.showMessage = self.sMessageFromFlutter
        secondNativeVC.returnStrBlock = { (message: String) -> Void in
             //从第二个原生页面回来后通知Flutter页面更新文案
            self.sendMessageToFlutter(message: message)
        }
        secondNativeVC.modalPresentationStyle = .fullScreen
        self.present(secondNativeVC, animated: true, completion: nil)
    }
    
    //返回第一个原生页面
    func backFirstNative() {
        //关闭Flutter页面
        self.flutterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    func sendMessageToFlutter(message: String) {
        //初始化messageChannel，CHANNEL_FLUTTER为iOS和Flutter两端统一的通信信号
        let messageChannel = FlutterMethodChannel.init(name: CHANNEL_FLUTTER, binaryMessenger: self.flutterViewController as! FlutterBinaryMessenger)
        messageChannel.invokeMethod("onActivityResult", arguments: "{'message':message}")
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
