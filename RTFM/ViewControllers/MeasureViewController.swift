//
//  MeasureViewController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 28/09/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit
import YandexMapKit
import CoreLocation

class MapView: UIView {
    let mapView: YMKMapView = .init()
    private(set) var userLocation: YMKCircleMapObject?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocation(_ location: CLLocationCoordinate2D) {
        let point = YMKPoint(latitude: location.latitude, longitude: location.longitude)
        let camera = YMKCameraPosition(target: point, zoom: 15, azimuth: 0, tilt: 0)
        let animation = YMKAnimation(type: YMKAnimationType.smooth, duration: 0.5)
        let map: YMKMap = self.mapView.mapWindow.map

        map.move(with: camera,
                 animationType: animation,
                 cameraCallback: nil)
    
        if let circle = self.userLocation {
            map.mapObjects.remove(with: circle)
        }
        let circle = YMKCircle(center: point, radius: 40)
        let objects = map.mapObjects
        self.userLocation = objects.addCircle(with: circle,
                                              stroke: .red,
                                              strokeWidth: 0,
                                              fill: UIColor.green.withAlphaComponent(0.7))
    }
    
    func scrollTo(location: CLLocationCoordinate2D, zoom: Float) {
        let point = YMKPoint(latitude: location.latitude, longitude: location.longitude)
        let camera = YMKCameraPosition(target: point, zoom: zoom, azimuth: 0, tilt: 0)
        let animation = YMKAnimation(type: YMKAnimationType.smooth, duration: 0.5)
        let map: YMKMap = self.mapView.mapWindow.map
        
        map.move(with: camera,
                 animationType: animation,
                 cameraCallback: nil)
    }
}

class MeasureViewController: UIViewController {
    
    private(set) var overlayView: UIView!
    private(set) var signalImageView: UIImageView!
    private(set) var providerLabel: UILabel!
    private(set) var radioTypeLabel: UILabel!
    private(set) var mapView: MapView!
    private(set) var sendButton: UIButton!
    private(set) var powerLabel: UILabel!

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Measure"
        
        LocationManager.shared.register(observer: self)
        TelephonyManager.shared.register(observer: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        LocationManager.shared.unregister(observer: self)
        TelephonyManager.shared.unregister(observer: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        self.mapView = MapView(frame: self.view.bounds)
        self.mapView.mapView.setNoninteractive(true)
        self.view.addSubview(self.mapView)
        self.mapView.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.overlayView = UIView()
        self.overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.view.addSubview(self.overlayView)
        self.overlayView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.signalImageView = UIImageView()
        self.view.addSubview(self.signalImageView)
        self.signalImageView.snp.makeConstraints { (make) in
            make.width.equalTo(165)
            make.height.equalTo(130)
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        
        self.powerLabel = UILabel()
        self.powerLabel.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        self.powerLabel.textColor = .white
        self.signalImageView.addSubview(self.powerLabel)
        self.powerLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
        
        self.providerLabel = UILabel()
        self.providerLabel.textColor = .white
        self.providerLabel.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(self.providerLabel)
        self.providerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.signalImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        self.radioTypeLabel = UILabel()
        self.radioTypeLabel.textColor = UIColor(white: 0.9, alpha: 1.0)
        self.radioTypeLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(self.radioTypeLabel)
        self.radioTypeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.providerLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        self.sendButton = UIButton.makeSystemButton()
        self.sendButton.setTitleColor(UIColorFromHex(rgbValue: 0x294EA5), for: .normal)
        self.sendButton.backgroundColor = rgba(233, 233, 233, 0.8)
        self.sendButton.setTitle("ОТПРАВИТЬ", for: .normal)
        self.sendButton.addTarget(self, action: #selector(actionSend(_:)), for: .touchUpInside)
        self.view.addSubview(self.sendButton)
        self.sendButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
        
        self.updateMapView()
        self.updateSignalView()
        self.updateProviderView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc
    func actionSend(_ sender: Any?) {
        self.sendButton.isEnabled = false
        let hud = self.showLoadingHUD()
        ReportManager.shared.report { (result) in
            self.sendButton.isEnabled = true
            switch result {
            case .success:
                hud.mode = .text
                hud.label.text = "Отправлено"

                delay(2) {
                    hud.hide(animated: true)
                }
            case .failure(let err):
                hud.hide(animated: false)
                self.showError(err)
            }
        }
    }
    
    private func updateMapView() {
        let manager = LocationManager.shared
        if let location = manager.manager.location {
            self.mapView?.setLocation(location.coordinate)
        } else {
            manager.requestLocation { (location, error) in
                if let location = location {
                    self.mapView?.setLocation(location.coordinate)
                } else {
                    self.showError(error!)
                }
            }
        }
    }
    
    private func updateSignalView() {
        let power = TelephonyManager.shared.signalPower

        let color: UIColor
        let image: UIImage
        if let power = power {
            switch power {
            case 0..<25:
                color = UIColorFromHex(rgbValue: 0xE4B5EB)
                image = UIImage(named: "power-bad")!
            case 25..<50:
                color = UIColorFromHex(rgbValue: 0x8155CF)
                image = UIImage(named: "power-normal")!
            case 50..<75:
                color = UIColorFromHex(rgbValue: 0x7390FA)
                image = UIImage(named: "power-fine")!
            case 75..<100:
                color = UIColorFromHex(rgbValue: 0x3025AD)
                image = UIImage(named: "power-exellent")!
            default:
                color = UIColorFromHex(rgbValue: 0x3025AD)
                image = UIImage(named: "power-exellent")!
            }
        } else {
            color = .black
            image = UIImage(named: "power-bad")!
        }
        self.mapView?.userLocation?.fillColor = color.withAlphaComponent(0.6)
        self.signalImageView?.image = image
        self.powerLabel.text = power?.description ?? ""
    }
    
    private func updateProviderView() {
        let nameText: String
        let manager = TelephonyManager.shared
        if let carrier = manager.cellularProviders.first?.value,
            let name = carrier.carrierName?.uppercased() {
            nameText = name
        } else {
            nameText = "unavailable"
        }
        let typeText: String
        if let radioType = manager.radioType {
            typeText = radioType.name
        } else {
            typeText = ""
        }
        self.providerLabel?.text = nameText
        self.radioTypeLabel?.text = typeText
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MeasureViewController: TelephonyManagerObserverProtocol {
    func telephonyManager(_ manager: TelephonyManager, didChangeSignalPower power: Int?) {
        if self.isViewLoaded {
            self.updateSignalView()
            self.updateProviderView()
        }
    }
}

extension MeasureViewController: LocationManagerObserverProtocol {
    func locationManager(_ manager: LocationManager, didUpdate location: CLLocation) {
        if self.isViewLoaded {
            self.updateMapView()
        }
    }
}
