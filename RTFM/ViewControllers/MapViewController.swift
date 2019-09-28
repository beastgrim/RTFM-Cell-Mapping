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
        
        self.updateUserLocation()
    }

    private func updateUserLocation() {
        if let location = LocationManager.shared.manager.location {
            self.mapView?.setLocation(location.coordinate)
        }
    }

}

extension MapViewController: LocationManagerObserverProtocol {
    func locationManager(_ manager: LocationManager, didUpdate location: CLLocation) {
        if self.isViewLoaded {
            self.updateUserLocation()
        }
    }
}
