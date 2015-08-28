//
//  ViewController.swift
//  lunch
//
//  Created by 卢伟斌 on 15/7/20.
//  Copyright (c) 2015年 dyqfcl.com. All rights reserved.
//

import UIKit

let at = UIAlertView()
var msg:String = ""
var todayLati:NSObject?
var todayLoti:NSObject?


class ViewController: UIViewController{
    
    //@IBOutlet weak var todayShop: UILabel!
    
    @IBOutlet weak var todayShop: UILabel!
    
    @IBOutlet weak var todayMapBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 开启摇一摇
        UIApplication.sharedApplication().applicationSupportsShakeToEdit = true
        self.becomeFirstResponder()
        if let listArr = defaults.objectForKey("listArr")
        {
            shopList = listArr as! [Dictionary<String, NSObject>];
            print("完整数据")
        }
        print(shopList)
    }
    
    
    
    
   override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
    if motion == UIEventSubtype.MotionShake
    {
        self.todayShop.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        //随机获得店铺
        let sCount = UInt32(shopList.count)
        let sIndex = arc4random_uniform(sCount)
        todayShop.text = shopList[Int(sIndex)]["shopN"] as? String
        todayLati = shopList[Int(sIndex)]["lat"]
        todayLoti = shopList[Int(sIndex)]["lot"]
        
        UIView.animateWithDuration(1, animations: {
            self.todayShop.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
        
        //摇一摇成功后弹出弹框
        msg = todayShop.text!
        at.delegate = self
        at.title = "感谢您的摇晃"
        at.message = msg
        at.addButtonWithTitle("确定")
        at.show()

    }
   }

    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func getShop(sender: AnyObject) {
        //店铺出现的动画
        let py = self.todayShop.center.y;
        self.todayShop.center.y = 0
        
        UIView.animateWithDuration(1, animations: {
            self.todayShop.center.y = py
        })
        
        let sCount = UInt32(shopList.count)
        let sIndex = arc4random_uniform(sCount)
        todayShop.text = shopList[Int(sIndex)]["shopN"] as? String
        todayLati = shopList[Int(sIndex)]["lat"]
        todayLoti = shopList[Int(sIndex)]["lot"]
        print(todayLati)
    }
    
    @IBAction func close(segue:UIStoryboardSegue){
        print("closed")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(todayLati)
        if segue.identifier == "linktodaysmap"{
            var shopName:String
            var lati:CLLocationDegrees
            var loti:CLLocationDegrees
            
            
            let dc = segue.destinationViewController as! shopLocationController
            
            
            dc.shopName = todayShop.text
            
            dc.lati = todayLati! as? CLLocationDegrees
            dc.loti = todayLoti! as? CLLocationDegrees
            
        }
    }



}

