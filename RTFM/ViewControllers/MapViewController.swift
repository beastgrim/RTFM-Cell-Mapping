//
//  MapViewController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 29/09/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation
import YandexMapKit
import MBProgressHUD

class MapViewController: UIViewController {
    
    private(set) var mapView: MapView!
    private(set) var heatMapImageView: UIImageView!
    private(set) var radioTypeControl: UISegmentedControl!

    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Карта покрытия"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        LocationManager.shared.unregister(observer: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView = MapView()
        let mapWindow: YMKMapWindow = self.mapView.mapView.mapWindow
        mapWindow.addSizeChangedListener(with: self)
        let map: YMKMap = mapWindow.map
        map.isZoomGesturesEnabled = false
        map.isRotateGesturesEnabled = false
        map.addCameraListener(with: self)
        self.view.addSubview(self.mapView)
        self.mapView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        self.heatMapImageView = UIImageView()
        self.heatMapImageView.contentMode = .scaleAspectFill
        self.view.addSubview(self.heatMapImageView)
        self.heatMapImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        self.radioTypeControl = UISegmentedControl(items: ["GPRS", "EDGE", "LTE"])
        self.radioTypeControl.addTarget(self, action: #selector(actionRadioTypeDidChange(_:)), for: .valueChanged)
        self.radioTypeControl.selectedSegmentIndex = 0
        self.view.addSubview(self.radioTypeControl)
        self.radioTypeControl.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(24)
            make.centerX.equalToSuperview()
        }
        
        self.mkMapView = .init(frame: self.view.bounds)
        self.updateUserLocation()
        
//        self.loadFakeData()
    }
    
    @objc
    func actionRadioTypeDidChange(_ sender: Any?) {
        
//        let host = ApiHostManager.baseUrl.absoluteString
//        let leftTop = CLLocationCoordinate2D(latitude: -5, longitude: -5)
//        let rightBottom = CLLocationCoordinate2D(latitude: 5, longitude: 5)
//        let request = Api.cellHeatMap(host: host,
//                                      leftTop: leftTop,
//                                      rightBottom: rightBottom,
//                                      operatorName: "BEELINE",
//                                      radioType: "LTE", successHandler: { [weak self] (response) in
//
//                                        let signals = response.protobufObject
//                                        self?.handleData(signals)
//        }) { (error) in
//            print("Error request: \(error)")
//        }
//        request.start()
        
        // TODO: connect to server
        let hud = self.showLoadingHUD()
        UIView.animate(withDuration: 0.24, animations: {
            self.heatMapImageView?.alpha = 0.0
        }) { (_) in
            delay(1, closure: {
                hud.hide(animated: true)
                UIView.animate(withDuration: 0.24, animations: {
                    self.heatMapImageView?.alpha = 1.0
                }, completion: nil)
            })
        }
    }

    private func updateUserLocation() {
//        let location = CLLocation(latitude: 39.0, longitude: -77.0)
//        self.mapView.scrollTo(location: location.coordinate, zoom: 10)

        if let location = LocationManager.shared.manager.location {
            self.mapView?.setLocation(location.coordinate)
        }
    }
    
    private func loadMap(region: YMKVisibleRegion) {
        
        let centerLat = (region.topLeft.latitude - region.bottomRight.latitude) / 2
        let centerLon = (region.bottomRight.longitude - region.topLeft.longitude) / 2
        let minLat = min(region.bottomRight.latitude, region.topLeft.latitude)
        let minLon = min(region.bottomRight.longitude, region.topLeft.longitude)
        self.heatMapCenter = CLLocationCoordinate2D(latitude: minLat + centerLat, longitude: minLon + centerLon)
        
        let host = ApiHostManager.baseUrl.absoluteString
        let leftBottom = CLLocationCoordinate2D(latitude: region.bottomLeft.latitude,
                                                longitude: region.bottomLeft.longitude)
        let rightTop = CLLocationCoordinate2D(latitude: region.topRight.latitude,
                                              longitude: region.topRight.longitude)
        
        let request = Api.cellHeatMap(host: host,
                                      leftBottom: leftBottom,
                                      rightTop: rightTop,
                                      operatorName: "BEELINE",
                                      radioType: "LTE", successHandler: { [weak self] (response) in
                                        
                                        let signals = response.protobufObject
                                        self?.handleData(signals, fromRegion: region)
        }) { (error) in
            print("Error request: \(error)")
        }
        request.start()
    }
    
    private func handleData(_ data: SignalMapResponse, fromRegion: YMKVisibleRegion) {
        var data = data

        guard let mapView = self.mapView else {
            return
        }
        var locations: [NSValue] = []
        var weights: [Double] = []
        
        let topLeft = fromRegion.topLeft
        let bottomRight = fromRegion.bottomRight
        let totalWidth: Double = abs(bottomRight.longitude - topLeft.longitude)
        let totalHeight: Double = abs(bottomRight.latitude - topLeft.latitude)
        let minLongitutde = min(topLeft.longitude, bottomRight.longitude)
        let minLatitude = min(topLeft.latitude, bottomRight.latitude)
        let size: CGSize = mapView.bounds.size
        
        // Fill fake data
        if data.points.isEmpty {
            for _ in 0..<100 {
                let randX = Double(arc4random()%1001) / 1000.0
                let randY = Double(arc4random()%1001) / 1000.0
                let randSignal = Double(arc4random()%1001) / 1000.0
                var point = SignalPoint()
                point.longitude = minLongitutde + totalWidth * randX
                point.latitude = minLatitude + totalHeight * randY
                point.reliability =  randSignal
                data.points.append(point)
            }
        }
        
        for point: SignalPoint in data.points {
            let loc = CGPoint(x: (point.longitude - minLongitutde) / totalWidth * Double(size.width),
                              y: (point.latitude - minLatitude) / totalHeight * Double(size.height))
            locations.append(NSValue(cgPoint: loc))
            weights.append(point.reliability)
        }
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let boost: Float = 1.0
        
        let image = LFHeatMap.heatMap(with: rect, boost: boost, points: locations, weights: weights)
        self.heatMapImageView?.image = image
    }
    
    private var mkMapView: MKMapView!
    private var locations: [CLLocation] = []
    private var weights: [Double] = []
    private var heatMapCenter: CLLocationCoordinate2D = .init()
    
    private func loadFakeData() {
        guard let path = Bundle.main.path(forResource: "quake", ofType: "plist") else {
            return
        }
        guard let dataArray = NSArray(contentsOf: URL(fileURLWithPath: path)) else {
            return
        }
        
        for item in dataArray {
            guard let dict = item as? NSDictionary else {
                continue
            }
            let lat = dict.value(forKey: "latitude") as! Double
            let lon = dict.value(forKey: "longitude") as! Double
            let mag = dict.value(forKey: "magnitude") as! Double
            
            let loc = CLLocation(latitude: lat, longitude: lon)
            self.locations.append(loc)
            
            self.weights.append(mag * 10)
        }
        // set map region
        let span = MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 13.0)
        let center = CLLocationCoordinate2DMake(39.0, -77.0)
        self.heatMapCenter = center
        self.mkMapView.region = MKCoordinateRegion(center: center, span: span)  
        
        let boost: Float = 1.0
        let image = LFHeatMap.heatMap(for: self.mkMapView, boost: boost, locations: locations, weights: weights)
        self.heatMapImageView.image = image
//        self.heatMapImageView.isHidden = true
    }

}

extension MapViewController: LocationManagerObserverProtocol {
    func locationManager(_ manager: LocationManager, didUpdate location: CLLocation) {
        if self.isViewLoaded {
            self.updateUserLocation()
        }
    }
}

extension MapViewController: YMKMapSizeChangedListener {
    func onMapWindowSizeChanged(with mapWindow: YMKMapWindow, newWidth: Int, newHeight: Int) {
        print("\(#function) \(newWidth) \(newHeight)")
    }
}

extension MapViewController: YMKMapCameraListener {
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateSource: YMKCameraUpdateSource, finished: Bool) {
        guard let view = self.heatMapImageView else {
            return
        }
        
        if finished {
            let region = map.visibleRegion
            print("Region: \(region.topLeft.latitude) \(region.topLeft.longitude) \(region.bottomRight.latitude) \(region.bottomRight.longitude)")
            self.loadMap(region: region)
        }
        
        let target = cameraPosition.target
        let center = CLLocationCoordinate2D(latitude: target.latitude, longitude: target.longitude)
        let point = self.heatMapCenter
        let zoom = CGFloat(cameraPosition.zoom)
        
//        print("Offset: x \(point.latitude - center.latitude) y \(point.longitude - center.longitude) zoom \(zoom)")

        let offsetX = -CGFloat(center.longitude - point.longitude) * 1500 * zoom
        let offsetY = CGFloat(center.latitude - point.latitude) * 2000 * zoom
        let offsetTransform = CGAffineTransform(translationX: offsetX, y: offsetY)
        view.layer.transform = CATransform3DMakeAffineTransform(offsetTransform)
    }
}
