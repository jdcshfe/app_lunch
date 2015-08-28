//
//  shopLocationController.swift
//  中午吃啥
//
//  Created by 卢伟斌 on 15/8/10.
//  Copyright © 2015年 dyqfcl.com. All rights reserved.
//


import UIKit

class shopLocationController: UIViewController, BMKMapViewDelegate, BMKPoiSearchDelegate, BMKLocationServiceDelegate {
    
    var shopName:String?
    var lati:CLLocationDegrees?
    var loti:CLLocationDegrees?
    
    /// 百度地图视图
    var mapView: BMKMapView!
    
    //属性
    var pointAnnotation: BMKPointAnnotation!
    var animatedAnnotation: BMKPointAnnotation!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        self.title = shopName
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view.frame)
        //mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        //mapView.centerCoordinate = CLLocationCoordinate2DMake(31.22654, 121.366997)
        mapView.centerCoordinate = CLLocationCoordinate2DMake(lati!, loti!)
        
        
        //缩放级别
        mapView.zoomLevel = Float(18)
        self.view.addSubview(mapView)
        
        // 界面初始化
        mapView.isSelectedAnnotationViewFront = true
        
        addPointAnnotation()
        
        print(lati!)
        print(loti!)
        
        
    
    }
    
    
    /// 添加标注
    func addPointAnnotation() {
        pointAnnotation = BMKPointAnnotation()
        let coordinator = CLLocationCoordinate2DMake(lati!, loti!)
        pointAnnotation.coordinate = coordinator
        pointAnnotation.title = shopName
        mapView.addAnnotation(pointAnnotation)
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        mapView.viewWillAppear()
        mapView.delegate = self  // 此处记得不用的时候需要置nil，否则影响内存的释放
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.viewWillDisappear()
        mapView.delegate = nil  // 不用时，置nil
    }
    
    // MARK: - 内存管理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
