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

class MapViewController: UIViewController {
    
    private(set) var mapView: MapView!
    private(set) var heatMapImageView: UIImageView!

    init() {
        super.init(nibName: nil, bundle: nil)
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
        
        self.mkMapView = .init(frame: self.view.bounds)
        self.updateUserLocation()
        
        self.loadFakeData()
    }

    private func updateUserLocation() {
        let location = CLLocation(latitude: 39.0, longitude: -77.0)
        self.mapView.scrollTo(location: location.coordinate, zoom: 10)

//        if let location = LocationManager.shared.manager.location {
//            self.mapView?.setLocation(location.coordinate)
//        }
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

        let target = cameraPosition.target
        let center = CLLocationCoordinate2D(latitude: target.latitude, longitude: target.longitude)
        let point = self.heatMapCenter
        let zoom = CGFloat(cameraPosition.zoom)
        
        print("Offset: x \(point.latitude - center.latitude) y \(point.longitude - center.longitude) zoom \(zoom)")

        let offsetX = -CGFloat(center.longitude - point.longitude) * 100 * zoom
        let offsetY = CGFloat(center.latitude - point.latitude) * 100 * zoom
        let offsetTransform = CGAffineTransform(translationX: offsetX, y: offsetY)
        view.layer.transform = CATransform3DMakeAffineTransform(offsetTransform)
//        print("\(#function) \(cameraPosition) \(finished)")
    }
}
