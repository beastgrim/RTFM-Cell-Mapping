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
//        let location = CLLocation(latitude: 39.0, longitude: -77.0)
        if let location = LocationManager.shared.manager.location {
            self.mapView?.setLocation(location.coordinate)
        }
    }
    
    
    private var mkMapView: MKMapView!
    private var locations: [CLLocation] = []
    private var weights: [Double] = []
    
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
