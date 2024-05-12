//
//  LocationManager.swift
//  NearbyApp
//
//  Created by Mayank on 12/05/24.
//

import Foundation
import CoreLocation

protocol LocationPermissable {
    func requestLocationPermission()
}

final class LocationPermissionManager: LocationPermissable {
    private let manager: CLLocationManager = CLLocationManager()
    
    var authStatus: CLAuthorizationStatus {
        manager.authorizationStatus
    }
    
    func requestLocationPermission() {
        guard authStatus == .notDetermined else { return }
        manager.requestAlwaysAuthorization()
    }
}

protocol LocationHandler {
    func isLocationEnabled() -> Bool
    var coordinates: CLLocationCoordinate2D? { get }
    func startUpdatingLocation()
    var locationChangedCallback: ((CLLocationCoordinate2D?)->())? { get set }
}

final class LocationManager: NSObject, LocationHandler, CLLocationManagerDelegate {
    enum LocationErrors {
        // TODO: 
    }
    
    private let manager: CLLocationManager?
    private let permissionManager: any LocationPermissable
    
    var coordinates: CLLocationCoordinate2D? {
        manager?.location?.coordinate
    }
    
    var locationChangedCallback: ((CLLocationCoordinate2D?)->())? = nil
    
    init(manager: CLLocationManager = .init(),
         permissionManager: any LocationPermissable = LocationPermissionManager()) {
        self.manager = manager
        self.permissionManager = permissionManager
        super.init()
        permissionManager.requestLocationPermission()
        manager.delegate = self
    }
    
    func isLocationEnabled() -> Bool {
        return (manager?.authorizationStatus == .authorizedWhenInUse || manager?.authorizationStatus == .authorizedAlways)
    }
    
    func startUpdatingLocation() {
        manager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // TODO: Optimise this for multiple updates.
        // REplace with async stream
//        locationChangedCallback?(locations.first?.coordinate)
    }
}
