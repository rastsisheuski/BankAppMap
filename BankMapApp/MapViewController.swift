//
//  ViewController.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 17.01.23.
//

import UIKit
import GoogleMaps
import CoreLocation
import ObjectMapper

class MapViewController: UIViewController {
    
    var atmsArray = [ATMModel]() {
        didSet {
            self.drawATMsMarkers()
        }
    }
    var departmentsArray = [DepartmentModel]()
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet weak var citiesCollection: UICollectionView!
    @IBOutlet weak var filterCollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDishesCollectionView()
        getATMs()
        getDepartments()
    }
    
    private func setupMapView() {
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
    }
    
    private func setupDishesCollectionView() {
        let nib = UINib(nibName: String(describing: CollectionViewCell.self), bundle: nil)
        let id = String(describing: CollectionViewCell.self)
        citiesCollection.register(nib, forCellWithReuseIdentifier: id)
        filterCollection.register(nib, forCellWithReuseIdentifier: id)
        citiesCollection.delegate = self
        citiesCollection.dataSource = self
        filterCollection.delegate = self
        filterCollection.dataSource = self
    }
    
    private func setupMyLocation() {
        guard let myPosition = mapView.myLocation?.coordinate else { return }
        
        let camera = GMSCameraPosition(latitude: myPosition.latitude, longitude: myPosition.longitude, zoom: 10)
        
        mapView.animate(to: camera)
    }
    
    private func getATMs() {
        spinnerView.startAnimating()
        CurrencyExchangeProvider().getATMs { [weak self] data in
            guard let self else { return }
            self.atmsArray = data
            self.spinnerView.stopAnimating()
            self.citiesCollection.reloadData()
        } failure: {
            print("Error")
            self.spinnerView.stopAnimating()
        }
    }
    
    private func getDepartments() {
        spinnerView.startAnimating()
        CurrencyExchangeProvider().getDepartments { [weak self] data in
            guard let self else { return }
            self.departmentsArray = data
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
    
    private func drawATMsMarkers() {
        atmsArray.forEach { atm in
            guard let lat = Double(atm.gpsX),
                  let long = Double(atm.gpsY)
            else { return }
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let name = atm.id
            drawMarker(name: name, location: coordinate)
        }
    }
    private func drawDepartmentsMarkers() {
        departmentsArray.forEach { department in
            guard let lat = Double(department.gpsX),
                  let long = Double(department.gpsY)
            else { return }
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let name = department.filialName
            drawMarker(name: name, location: coordinate)
        }
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
}

extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return atmsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = citiesCollection.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath)
        guard let cityCell = cell as? CollectionViewCell else { return cell }
        cityCell.set(title: atmsArray[indexPath.item].city)
        return cell
    }
}

extension MapViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    }
}
