//
//  addshopController.swift
//  lunch
//
//  Created by 卢伟斌 on 15/7/20.
//  Copyright (c) 2015年 dyqfcl.com. All rights reserved.
//

import UIKit

class addshopController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var shopName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        shopName.resignFirstResponder()
    }
    
    
    @IBAction func addShop(sender: AnyObject) {
        shopName.resignFirstResponder()
        
        if shopName.text!.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " !")).isEmpty{
            return
        }else{
            let sid = shopList.count + 1
            let shopTin = ["id": sid, "shopN": shopName.text!, "lat":31.22654, "lot":121.366997]
            shopList.append(shopTin as! Dictionary<String, NSObject>)
            print(shopList)
            let defaults = NSUserDefaults.standardUserDefaults();
            defaults.removeObjectForKey("listArr")
            defaults.setObject(shopList,forKey: "listArr")
            defaults.synchronize()
        }
        
    }
   
    
    
}