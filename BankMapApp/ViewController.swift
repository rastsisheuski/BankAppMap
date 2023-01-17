//
//  ViewController.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 17.01.23.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController {
    
    var currencyExchanges = [CurrencyExchangeModel]() {
        didSet {
            self.drawAllMarkers()
        }
    }
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData(city: "Минск")
    }
    
    private func setupMapView() {
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
    }
    
    private func setupMyLocation() {
        guard let myPosition = mapView.myLocation?.coordinate else { return }
        
        let camera = GMSCameraPosition(latitude: myPosition.latitude, longitude: myPosition.longitude, zoom: 10)
        
        mapView.animate(to: camera)
    }
    
    private func getData(city: String) {
        spinnerView.startAnimating()
        CurrencyExchangeProvider().getCurrencyExchange(city: city) { [weak self] data in
            guard let self else { return }
            self.currencyExchanges = data
            self.spinnerView.stopAnimating()
        } failure: {
            print("Error")
            self.spinnerView.stopAnimating()
        }
    }
    
    private func drawMarker(name: String, location: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: location)
        marker.title = "Mark №\(name)"
        marker.map = mapView
    }
    
    private func drawAllMarkers() {
        currencyExchanges.forEach { currencyExchange in
            guard let lat = Double(currencyExchange.gpsX),
                  let long = Double(currencyExchange.gpsY)
            else { return }
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let name = currencyExchange.id
            drawMarker(name: name, location: coordinate)
        }
    }
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
}

