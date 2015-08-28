//
//  shoplist.swift
//  lunch
//
//  Created by 卢伟斌 on 15/7/20.
//  Copyright (c) 2015年 dyqfcl.com. All rights reserved.
//

import UIKit

var shopList = [
    ["id": 1, "shopN": "京东到家外卖", "lat":31.22654, "lot":121.366997]
]


let defaults = NSUserDefaults.standardUserDefaults();


class ListController: UIViewController ,UITableViewDataSource ,UITableViewDelegate{
    
    
    @IBOutlet weak var tableList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let listArr = defaults.objectForKey("listArr")
        {
            shopList = listArr as! [Dictionary<String, NSObject>];
            print("新数据")
        }

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return shopList.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = self.tableList.dequeueReusableCellWithIdentifier("shopcell")! as UITableViewCell
        let shopTin = shopList[indexPath.row]
        
        let shopname = cell.viewWithTag(101) as! UILabel
        
        shopname.text = String(shopTin["shopN"]!)
        
        return cell
    }
    
    
    //删除一条店铺
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == UITableViewCellEditingStyle.Delete{
            shopList.removeAtIndex(indexPath.row)
            self.tableList.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            defaults.setObject(shopList, forKey: "listArr")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "linkmap"{
            /*
            var shopName:String
            var lati:CLLocationDegrees
            var loti:CLLocationDegrees
            */
            
            let indexPath = self.tableList.indexPathForSelectedRow?.row
            
            print(indexPath)
            
            let vc = segue.destinationViewController as! shopLocationController
            
            vc.shopName = shopList[indexPath!]["shopN"]! as? String
            
            vc.lati = shopList[indexPath!]["lat"]! as? CLLocationDegrees
            vc.loti = shopList[indexPath!]["lot"]! as? CLLocationDegrees
            
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        viewDidLoad()
        tableList.reloadData()
    }
    
    
    
    
    
    
}
