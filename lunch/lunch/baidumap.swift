//
//  baidumap.swift
//  中午吃啥
//
//  Created by 卢伟斌 on 15/8/10.
//  Copyright © 2015年 dyqfcl.com. All rights reserved.
//


import UIKit

class baidumap: UIViewController, BMKMapViewDelegate, BMKPoiSearchDelegate, BMKLocationServiceDelegate {
    
    
    
    /// 百度地图视图
    var mapView: BMKMapView!
    
    /// 定位服务
    var locationService: BMKLocationService!
    /// 当前用户位置
    var userLocation: BMKUserLocation!
    
    /// Poi 搜索
    var poisearch: BMKPoiSearch!
    /// 搜索页面
    var currentPage = 0
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        //self.title = arrayOfDemoName[8]
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view.frame)
        //mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 31.226528, longitude: 121.367006)
        //缩放级别
        mapView.zoomLevel = Float(18)
        self.view.addSubview(mapView)
        
        // 界面初始化
        mapView.isSelectedAnnotationViewFront = true
        
        // 设置定位精确度，默认：kCLLocationAccuracyBest
        BMKLocationService.setLocationDesiredAccuracy(kCLLocationAccuracyBest)
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        BMKLocationService.setLocationDistanceFilter(10)
        // 定位功能初始化
        locationService = BMKLocationService()
        
        locationService.startUserLocationService()
       print("aaa")
        locationService.startUserLocationService()
        print("bbb")
        mapView.showsUserLocation = false  //先关闭显示的定位图层
        print("ccc")
        mapView.userTrackingMode = BMKUserTrackingModeFollow  //设置定位的状态
        print("yyy")
        mapView.showsUserLocation = true //显示定位图层
        mapView.scrollEnabled = true  // 允许用户移动地图

        // Poi 搜索初始化
        poisearch = BMKPoiSearch()
        
        print("lu")
        /**
        
        **/
        
       
    
    }
    
    
    //实现相关delegate 处理位置信息更新
    //处理方向变更信息
    func didUpdateUserHeading(userLocation: BMKUserLocation!) {
        print("wei")
        //mapView.updateLocationData(userLocation)
        /*
        mapView.updateLocationData(userLocation)
        print(userLocation.location)
        mapView.userTrackingMode = BMKUserTrackingModeNone
      
        let citySearchOption = BMKNearbySearchOption()
        citySearchOption.pageIndex = Int32(currentPage)
        print("bin")
        print(userLocation.location.coordinate.latitude)
        citySearchOption.location = CLLocationCoordinate2D(latitude: userLocation.location.coordinate.latitude, longitude: userLocation.location.coordinate.longitude)
        citySearchOption.radius = 2000
        citySearchOption.pageCapacity = 1000
        citySearchOption.keyword = "美食"
        print("saaa")
        print(citySearchOption.keyword)
        if poisearch.poiSearchNearBy(citySearchOption) {
            print("城市内检索发送成功！")
        }else {
            print("城市内检索发送失败！")
        }
*/
        
    }
    
    //处理位置坐标更新
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        print("lllll")
        mapView.updateLocationData(userLocation)
        mapView.userTrackingMode = BMKUserTrackingModeNone
        
        let citySearchOption = BMKNearbySearchOption()
        citySearchOption.pageIndex = Int32(currentPage)
        print(userLocation.location.coordinate.latitude)
        citySearchOption.location = CLLocationCoordinate2D(latitude: userLocation.location.coordinate.latitude, longitude: userLocation.location.coordinate.longitude)
        citySearchOption.radius = 2000
        citySearchOption.pageCapacity = 1000
        citySearchOption.keyword = "美食"
        print("saaa") 
        print(citySearchOption.keyword)
        if poisearch.poiSearchNearBy(citySearchOption) {
            print("城市内检索发送成功！")
        }else {
            print("城市内检索发送失败！")
        }
        
        
        
    }

    
    // MARK: - 覆盖物协议设置
    
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        // 生成重用标示 ID
        let annotationViewID = "Mark"
        
        // 检查是否有重用的缓存
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationViewID)
        
        // 缓存若没有命中，则自己构造一个，一般首次添加 annotation 代码会运行到此处
        if annotationView == nil {
            annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationViewID)
            (annotationView as! BMKPinAnnotationView).pinColor =  UInt(BMKPinAnnotationColorRed)
            // 设置标注从天上掉下来的效果
            (annotationView as! BMKPinAnnotationView).animatesDrop = true
        }
        
        // 设置位置
        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5))
        annotationView.annotation = annotation
        // 单击弹出泡泡，弹出泡泡的前提是 annotation 必须实现 title 属性
        annotationView.canShowCallout = true
        // 设置是否可以拖拽
        annotationView.draggable = false
        
        return annotationView
    }
    
    func mapView(mapView: BMKMapView!, didSelectAnnotationView view: BMKAnnotationView!) {
        mapView.bringSubviewToFront(view)
        mapView.setNeedsDisplay()
    }
    
    func mapView(mapView: BMKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        print("标注添加前的方法调用")
    }
    
    // MARK: - Poi 搜索的相关方法实现
    func onGetPoiResult(searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        // 清除屏幕中所有的 annotation
        let array = mapView.annotations
        mapView.removeAnnotations(array)
        shopList.removeAll()
        if errorCode.rawValue == 0 {
            for i in 0..<poiResult.poiInfoList.count {
                let poi = poiResult.poiInfoList[i] as! BMKPoiInfo
                let item = BMKPointAnnotation()
                item.coordinate = poi.pt
                item.title = poi.name
                mapView.addAnnotation(item)
                /**
                if i == 0 {
                    // 将第一个点的坐标移到屏幕中央
                    mapView.centerCoordinate = poi.pt
                }
                **/
                let sid = shopList.count + 1
                let shopTin = ["id": sid, "shopN": poi.name, "lat":poi.pt.latitude, "lot":poi.pt.longitude]
                shopList.append(shopTin as! Dictionary<String, NSObject>)
                
            }
            let defaults = NSUserDefaults.standardUserDefaults();
            defaults.removeObjectForKey("listArr")
            defaults.setObject(shopList,forKey: "listArr")
            defaults.synchronize()
        }else if errorCode.rawValue == 2 {
            print("起始点有歧义")
        }else {
            // 各种情况的判断……
        }
    }
    
    // MARK: - 协议代理设置
    
    override func viewWillAppear(animated: Bool) {
        mapView.viewWillAppear()
        mapView.delegate = self  // 此处记得不用的时候需要置nil，否则影响内存的释放
        locationService.delegate = self
        poisearch.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.viewWillDisappear()
        mapView.delegate = nil  // 不用时，置nil
        locationService.delegate = nil
        poisearch.delegate = nil
    }
    
    // MARK: - 内存管理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
