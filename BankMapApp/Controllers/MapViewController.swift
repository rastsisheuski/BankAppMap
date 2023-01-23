//
//  ViewController.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 17.01.23.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils

final class MapViewController: UIViewController {
    
    // MARK: -
    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet weak var citiesCollection: UICollectionView!
    @IBOutlet weak var filterCollection: UICollectionView!
    
    @IBOutlet weak var nearestATMsButtom: UIButton!
    // MARK: -
    // MARK: - Private Properties
    
    private let dispatchGroup = DispatchGroup()
    private var clusterManager: GMUClusterManager?
    private var locationManager = CLLocationManager()
    private var filteredButtons = FilteredButton.allCases
    private var selectedCityIndex: IndexPath?
    private var selectedFilter = FilteredButton.selectAll
    private var atmsArray = [ATMModel]()
    private var departmentsArray = [DepartmentModel]()
    private var cities = [String]()
    
    // MARK: -
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNearestATMsButton()
        setupMapView()
        setupClusterManager()
        setupCollectionViews()
        getData()
    }
    
    // MARK: -
    // MARK: - Private Methods
    
    private func setupNearestATMsButton() {
        nearestATMsButtom.layer.cornerRadius = 12
        nearestATMsButtom.clipsToBounds = true
        nearestATMsButtom.addTarget(self, action: #selector(nearestATMsButtonDidTap(sender:)), for: .touchUpInside)
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
        
        citiesCollection.backgroundColor = .gray.withAlphaComponent(0.5)
        filterCollection.backgroundColor = .gray.withAlphaComponent(0.5)
        
        citiesCollection.showsHorizontalScrollIndicator = false
        filterCollection.showsHorizontalScrollIndicator = false
        filterCollection.isScrollEnabled = false
    }
    
    private func setupMyLocation() {
        guard let myPosition = mapView.myLocation?.coordinate else { return }
        
        let camera = GMSCameraPosition(latitude: myPosition.latitude, longitude: myPosition.longitude, zoom: 10)
        
        mapView.animate(to: camera)
    }
    
    private func setupClusterManager() {
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        clusterManager?.setMapDelegate(self)
    }
    
    private func getCities(_ array: [Cityable]) {
        array.forEach { [weak self] model in
            guard let self,
                  let cityName = model.cityName
            else { return }
            if !self.cities.contains(cityName), model.cityType == "г." {
                cities.append(cityName)
            }
        }
        self.citiesCollection.reloadData()
    }
    
    private func drawATMsMarkers(from array: [ATMModel]) {
        array.forEach { atmArray in
            guard let lat = Double(atmArray.gpsX),
                  let long = Double(atmArray.gpsY)
            else { return }
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: long))
            if atmArray.atmError == "да" {
                marker.icon = GMSMarker.markerImage(with: .green)
            } else {
                marker.icon = GMSMarker.markerImage(with: .red)
            }
            clusterManager?.add(marker)
            marker.map = mapView
            marker.title = atmArray.adressType + atmArray.adress + atmArray.house
            marker.snippet = "Время работы: \(atmArray.workTime)"
            marker.userData = atmArray
            let camera = GMSCameraPosition(latitude: lat, longitude: long, zoom: 8)
            mapView.animate(to: camera)
            mapView.selectedMarker = marker
            mapView.selectedMarker = nil
            mapView.clear()
            clusterManager?.cluster()
        }
    }
    private func drawDepartmentsMarkers(from array: [DepartmentModel]) {
        array.forEach { depArray in
            guard let lat = Double(depArray.gpsX),
                  let long = Double(depArray.gpsY)
            else { return }
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: long))
            marker.map = mapView
            clusterManager?.add(marker)
            marker.title = depArray.filialName + depArray.nameType + depArray.city + depArray.streetType + depArray.street + depArray.homeNumber
            marker.icon = GMSMarker.markerImage(with: .purple)
            marker.userData = depArray
            let camera = GMSCameraPosition(latitude: lat, longitude: long, zoom: 8)
            mapView.animate(to: camera)
            mapView.selectedMarker = marker
            mapView.selectedMarker = nil
            mapView.clear()
            clusterManager?.cluster()
        }
    }
    
    private func drawMarkersFor(selectedCity: String) {
        mapView.clear()
        clusterManager?.clearItems()
        spinnerView.startAnimating()
        
        switch selectedFilter {
            case .atm:
                getATMs(city: selectedCity) { [weak self] data in
                    guard let self else { return }
                    self.drawATMsMarkers(from: data)
                    self.spinnerView.stopAnimating()
                }
                
            case .department:
                getDepartments(city: selectedCity) { [weak self] data in
                    guard let self else { return }
                    self.drawDepartmentsMarkers(from: data)
                    self.spinnerView.stopAnimating()
                }
               
            case .selectAll:
                getATMs(city: selectedCity) { [weak self] atmsData in
                    guard let self else { return }
                    guard let selectedIndex = self.selectedCityIndex else { return }
                    self.getDepartments(city: self.cities[selectedIndex.row]) { [weak self] departmentData in
                        guard let self else { return }
                        self.drawATMsMarkers(from: atmsData)
                        self.drawDepartmentsMarkers(from: departmentData)
                        self.spinnerView.stopAnimating()
                    }
                }
        }
    }
    
    private func findUsserCityIndexPathFromArray(userCity: String) -> IndexPath {
        for (index, cityName) in cities.enumerated() {
            if userCity == cityName {
                return IndexPath(row: index, section: 0)
            }
        }
        return IndexPath(row: 0, section: 0)
    }
}

// MARK: -
// MARK: - Extension MapViewcontroller + DataRequests

extension MapViewController {
    
    private func getATMs(city: String?, completion: @escaping ([ATMModel]) -> Void ) {
        CurrencyExchangeProvider().getATMs(city: city) { [weak self] data in
            guard let self else { return }
            self.atmsArray = data
            completion(data)
        } failure: {
            self.showAlert()
        }
    }
    
    private func getDepartments(city: String?, completion: @escaping ([DepartmentModel]) -> Void) {
        CurrencyExchangeProvider().getDepartments(city: city) { [weak self] data in
            guard let self else { return }
            self.departmentsArray = data
            completion(data)
        } failure: {
            self.showAlert()
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
            self.showAlert()
        }
        
        dispatchGroup.enter()
        print("enter")
        CurrencyExchangeProvider().getDepartments { [weak self] data in
            guard let self else { return }
            self.departmentsArray = data
            self.dispatchGroup.leave()
            print("leave")
        } failure: {
            self.showAlert()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.getCities(self.departmentsArray)
            self.getCities(self.atmsArray)
            self.spinnerView.stopAnimating()
        }
    }
    
    private func calculateDishCollectionViewCellSize() -> CGSize {
        let cellWidth = (UIScreen.main.bounds.width / 3 - 10)
        let cellHeight = cellWidth * 0.4
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Error", message: "No ATMs or Departments found in the selected region", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okBtn)
        present(alert, animated: true)
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
        
        let geocoder = CLGeocoder()
        
        guard let location = locationManager.location else { return }
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let firstLocation = placemarks?[0],
               let cityName = firstLocation.locality {
                guard let self else { return }
                let empty = self.cities.isEmpty
                guard !empty else { return }
                let cityIndexPath = self.findUsserCityIndexPathFromArray(userCity: cityName)
                self.selectedCityIndex = cityIndexPath
                self.drawMarkersFor(selectedCity: self.cities[cityIndexPath.row])
                self.citiesCollection.reloadData()
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func cameraMove(to location: CLLocationCoordinate2D) {
        mapView.camera = GMSCameraPosition.camera(withTarget: location, zoom: 8)
    }
    
}

// MARK: -
// MARK: - Extension MapViewController + UICollectionViewDataSource

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
        guard let cityIndex = selectedCityIndex else { return }
        
        if collectionView == citiesCollection {
            self.selectedCityIndex = indexPath
            self.drawMarkersFor(selectedCity: cities[indexPath.row])
            citiesCollection.reloadData()
        } else {
            self.selectedFilter = filteredButtons[indexPath.row]
            self.drawMarkersFor(selectedCity: cities[cityIndex.row])
            self.filterCollection.reloadData()
        }
    }
}

// MARK: -
// MARK: - Extension MapViewController + UICollectionViewDelegateFlowLayout

extension MapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        calculateDishCollectionViewCellSize()
    }
}

extension MapViewController {
    private func createRadiusCircle() {
        mapView.clear()
        clusterManager?.clearItems()
        spinnerView.startAnimating()
        guard let myPosition = mapView.myLocation else { return }
        guard let myPositionCoordinates = mapView.myLocation?.coordinate else { return }
        let circle = GMSCircle(position: myPosition.coordinate, radius: 5000)
        circle.fillColor = UIColor.green.withAlphaComponent(0.1)
        circle.map = mapView
        
        CurrencyExchangeProvider().getATMs { result in
            result.forEach { atmsArray in
                guard let lat = Double(atmsArray.gpsX),
                      let long = Double(atmsArray.gpsY)
                else { return }
                self.createMarker(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), position: myPosition)
            }
        } failure: {
            self.spinnerView.stopAnimating()
            self.showAlert()
        }
        
        CurrencyExchangeProvider().getDepartments { result in
            result.forEach { depArray in
                guard let lat = Double(depArray.gpsX),
                      let long = Double(depArray.gpsY)
                else { return }
                self.createMarker(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), position: myPosition)
                let camera = GMSCameraPosition(latitude: myPositionCoordinates.latitude, longitude: myPositionCoordinates.longitude, zoom: 20)
                self.mapView.animate(to: camera)
                self.spinnerView.stopAnimating()
            }
        } failure: {
            self.spinnerView.stopAnimating()
            self.showAlert()
        }
    }
    
    private func createMarker(coordinate: CLLocationCoordinate2D, position: CLLocation) {
        let distance = position.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        if distance < 5000 {
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
            marker.map = mapView
        }
    }
    
    @objc private func nearestATMsButtonDidTap(sender: UIButton) {
        switch sender.isSelected {
            case true:
                createRadiusCircle()
            case false:
                guard let cityIndex = selectedCityIndex else { return }
                self.drawMarkersFor(selectedCity: cities[cityIndex.row])
        }
        sender.isSelected.toggle()
    }
}
