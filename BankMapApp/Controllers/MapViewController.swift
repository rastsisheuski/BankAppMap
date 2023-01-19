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

final class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet weak var citiesCollection: UICollectionView!
    @IBOutlet weak var filterCollection: UICollectionView!
    
    private let dispatchGroup = DispatchGroup()
    private var locationManager = CLLocationManager()
    private var filteredButtons = FilteredButton.allCases
    private var selectedCityIndex = IndexPath(row: 0, section: 0)
    private var selectedFilter = FilteredButton.all
    private var atmsArray = [ATMModel]()
    private var departmentsArray = [DepartmentModel]()
    private var cities = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupCollectionViews()
        getData()
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    private func setupCollectionViews() {
        citiesCollection.delegate = self
        citiesCollection.dataSource = self
        filterCollection.delegate = self
        filterCollection.dataSource = self
        
        let nib = UINib(nibName: String(describing: CollectionViewCell.self), bundle: nil)
        let id = String(describing: CollectionViewCell.self)
        citiesCollection.register(nib, forCellWithReuseIdentifier: id)
        filterCollection.register(nib, forCellWithReuseIdentifier: id)
        
        citiesCollection.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        filterCollection.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    private func setupMyLocation() {
        guard let myPosition = mapView.myLocation?.coordinate else { return }
        
        let camera = GMSCameraPosition(latitude: myPosition.latitude, longitude: myPosition.longitude, zoom: 10)
        
        mapView.animate(to: camera)
    }
    
    private func getATMs() {
        CurrencyExchangeProvider().getATMs(city: nil) { [weak self] data in
            guard let self else { return }
            self.atmsArray = data
        } failure: {
            print("Error")
        }
    }

    private func getDepartments() {
        CurrencyExchangeProvider().getDepartments(city: nil) { [weak self] data in
            guard let self else { return }
            self.departmentsArray = data
        } failure: {
            print("Error")
        }
    }
    
    private func getData() {
        spinnerView.startAnimating()
        
        dispatchGroup.enter()
        print("enter")
        CurrencyExchangeProvider().getATMs { [weak self] data in
            guard let self else { return }
            self.atmsArray = data
            self.dispatchGroup.leave()
            print("leave")
        } failure: {
            print("Error")
        }
        
        dispatchGroup.enter()
        print("enter")
        CurrencyExchangeProvider().getDepartments { [weak self] data in
            guard let self else { return }
            self.departmentsArray = data
            self.dispatchGroup.leave()
            print("leave")
        } failure: {
            print("Error")
        }
        
        dispatchGroup.notify(queue: .main) {
            self.drawATMsMarkers()
            self.drawDepartmentsMarkers()
            self.getCities(self.departmentsArray)
            self.getCities(self.atmsArray)
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
    
    private func getCities(_ array: [Cityable]) {
        array.forEach { [weak self] model in
            guard let self,
                  let cityName = model.cityName
            else { return }
            if !self.cities.contains(cityName) {
                cities.append(cityName)
            }
        }
        self.citiesCollection.reloadData()
    }
}

// MARK: -
// MARK: - Extension MapViewController + GMSMapViewDelegate

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
}

// MARK: -
// MARK: - Extension MapViewController + CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locationManager.location?.coordinate else {
            locationManager.stopUpdatingLocation()
            return
        }
        cameraMove(to: location)
        locationManager.stopUpdatingLocation()
    }
    
    func cameraMove(to location: CLLocationCoordinate2D) {
        mapView.camera = GMSCameraPosition.camera(withTarget: location, zoom: 8)
    }
    
}

extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == citiesCollection {
            return cities.count
        } else {
            return filteredButtons.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = citiesCollection.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath)
       
        
        if collectionView == citiesCollection {
            guard let cityCell = cell as? CollectionViewCell else { return cell }
            cityCell.isSelected = indexPath == selectedCityIndex
            cityCell.set(title: cities[indexPath.row])
            return cityCell
        } else {
            guard let filterCell = cell as? CollectionViewCell else { return cell }
            filterCell.isSelected = selectedFilter == filteredButtons[indexPath.row]
            filterCell.set(title: filteredButtons[indexPath.row].description)
            return filterCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == citiesCollection {
            self.selectedCityIndex = indexPath
            self.citiesCollection.reloadData()
        } else {
            self.selectedFilter = filteredButtons[indexPath.row]
            self.filterCollection.reloadData()
        }
    }
}

extension MapViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    }
}
