//
//  roundmap.swift
//  中午吃啥
//
//  Created by 卢伟斌 on 15/8/4.
//  Copyright © 2015年 dyqfcl.com. All rights reserved.
//

import UIKit

let APIKey = "76d1ce0211e82b836aa9f7e9efb5fa39"

class roundmap: UIViewController ,MAMapViewDelegate, AMapSearchDelegate{
    
    var mapView:MAMapView?
    var search:AMapSearchAPI?
    var centerCoordinate:CLLocationCoordinate2D!
    
    var centerMarker:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        MAMapServices.sharedServices().apiKey = APIKey
        
        initMapView()
        
        initSearch()
        
    }
    
    func getLocationRoundFlag(){
        let requestUrl:String = "http://api.map.baidu.com/geosearch/v3/nearby?ak=Wtzq5MdmvCFn2gZepyKRtKIh&geotable_id=6583819&location=121.4879,31.2491&radius=1000000&tags=美食&sortby=distance:1";
        print(requestUrl)
    }
    
    func initMapView(){
        
        mapView = MAMapView(frame: CGRectMake(0, 65, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-65))
        
        mapView!.delegate = self
        
        mapView?.showsLabels = true
        mapView?.setCenterCoordinate(CLLocationCoordinate2DMake(31.220738,121.360656), animated: true)
        mapView?.zoomLevel = 18.5
        
        self.view.addSubview(mapView!)
        
        
        let compassX = mapView?.compassOrigin.x
        
        let scaleX = mapView?.scaleOrigin.x
        
        //设置指南针和比例尺的位置
        mapView?.compassOrigin = CGPointMake(compassX!, 0)
        
        mapView?.scaleOrigin = CGPointMake(scaleX!, 0)
        
        // 开启定位
        mapView!.showsUserLocation = true
        
        // 设置跟随定位模式，将定位点设置成地图中心点
        mapView!.userTrackingMode = MAUserTrackingModeFollow
        
        centerMarker = UIImageView(frame: CGRectMake(0, 0, 38, 50))
        centerMarker.center = mapView!.center
        centerMarker.frame=CGRectMake(centerMarker.frame.origin.x, centerMarker.frame.origin.y-65, 38, 50);
        centerMarker.image = UIImage(named: "pin_red.png")
        self.view.addSubview(centerMarker)
        
    }
    
    // 初始化 AMapSearchAPI
    func initSearch(){
        search = AMapSearchAPI(searchKey: APIKey, delegate: self);
        
        let dbcg:AMapPlaceSearchRequest = AMapPlaceSearchRequest()
        
        dbcg.searchType = AMapSearchType.PlaceAround
        dbcg.location = AMapGeoPoint.locationWithLatitude(CGFloat(31.2491), longitude: CGFloat(121.4879))
        dbcg.keywords="辛香汇"
        dbcg.city = ["shanghai"]
        dbcg.requireExtension = true
        
        //self.search?.AMapGeocodeSearch(request: AMapGeocodeSearchRequest!)
        self.search!.AMapPlaceSearch(dbcg)
        
        
        
    }
    
    // 逆地理编码
    func reverseGeocoding(){
        
        let coordinate = centerCoordinate
        
        // 构造 AMapReGeocodeSearchRequest 对象，配置查询参数（中心点坐标）
        let regeo: AMapReGeocodeSearchRequest = AMapReGeocodeSearchRequest()
        
        regeo.location = AMapGeoPoint.locationWithLatitude(CGFloat(coordinate!.latitude), longitude: CGFloat(coordinate!.longitude))

        
        
        print("regeo :\(regeo)")
        
        // 进行逆地理编码查询
        self.search!.AMapReGoecodeSearch(regeo)
        
    }
    
    // 定位回调
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        if updatingLocation {
            centerCoordinate = userLocation.location.coordinate
            print(centerCoordinate)
        }
    }
    
    // 点击Annoation回调
    func mapView(mapView: MAMapView!, didSelectAnnotationView view: MAAnnotationView!) {
        // 若点击的是定位标注，则执行逆地理编码
        if view.annotation.isKindOfClass(MAUserLocation){
            reverseGeocoding()
        }
    }
    
    // 逆地理编码回调
    func onReGeocodeSearchDone(request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        print("request :\(request)")
        print("response :\(response)")
        
        if (response.regeocode != nil) {
            
            var title = response.regeocode.addressComponent.city
            
            var length: Int{
                if title.isEmpty{
                    return 0
                }else{
                    return 1
                }
               
            }
            
            if (length == 0){
                title = response.regeocode.addressComponent.province
            }
            //给定位标注的title和subtitle赋值，在气泡中显示定位点的地址信息
            mapView?.userLocation.title = title
            mapView?.userLocation.subtitle = response.regeocode.formattedAddress
        }
        
    }
}