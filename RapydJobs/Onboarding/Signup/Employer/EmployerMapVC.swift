//
//  EmployerMapVC.swift
//  rapydjobs
//
//  Created by Muhammad Khan on 17/09/2018.
//  Copyright © 2018 Muhammad Khan. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire
import SwiftyJSON

class EmployerMapVC: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var centerCoordinate: CLLocationCoordinate2D!
    var address = ""
    var postalCode = ""
    var completion: (([String:Any]) -> Void)?
    
    @IBOutlet weak var currentLocationImg: UIImageView! {
        didSet {
            currentLocationImg.layer.zPosition = 1
        }
    }
    
    lazy var mapView: GMSMapView = {
        let mv = GMSMapView()
        return mv
    }()
    
    let searchInput: UISearchBar = {
        let input = UISearchBar()
        input.placeholder = "Find Location..."
        input.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        input.keyboardType = .default
        input.layer.cornerRadius = 12
        input.clipsToBounds = true
        input.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    let saveButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = AppConstants.shared.buttonGradientStart
        btn.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btn.titleLabel?.font = AppConstants.shared.buttonFont
        btn.setTitle("SAVE LOCATION", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(save), for: .touchUpInside)
        return btn
    }()
    
    let searchTableView: UITableView = {
        let tv = UITableView()
        tv.layer.cornerRadius = 12
        tv.clipsToBounds = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var currentLocation: CLLocation = {
        let cl = CLLocation()
        return cl
    }()
    
    var lat = 0.0//37.779593871626
    var lng = 0.0//-122.283288314939
    var searchResults = [String]()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        
        if let user = AppContainer.shared.user.user, let address = user.address {
            
            let latitude = Double(address.latitude ?? "") ?? 0.0
            let longitude = Double(address.longitude ?? "") ?? 0.0
            
            self.centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

            self.showMap(with: self.centerCoordinate.latitude, and: self.centerCoordinate.longitude, and: nil)
            
        } else {
            // LONDON
            let latitude = Double("51.5287718") ?? 0.0
            let longitude = Double("-0.2416818") ?? 0.0
            
            self.centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
//            self.showMap(with: self.centerCoordinate.latitude, and: self.centerCoordinate.longitude, and: nil)
            
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
        }
        
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        let topFrameHeight = UIApplication.shared.statusBarFrame.height + 30
        
        view.addSubview(searchInput)
        searchInput.topAnchor.constraint(equalTo: view.topAnchor, constant: topFrameHeight).isActive = true
        searchInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        searchInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        searchInput.heightAnchor.constraint(equalToConstant: 45).isActive = true
        searchInput.delegate = self
        
        view.addSubview(saveButton)
        saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saveButton.layer.cornerRadius = 20
        
        view.addSubview(searchTableView)
        searchTableView.topAnchor.constraint(equalTo: searchInput.bottomAnchor, constant: 8).isActive = true
        searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        searchTableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -240).isActive = true
        searchTableView.alpha = 0
        searchTableView.backgroundColor = .clear
        //searchTableView.separatorColor = .clear
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "employerSearchCell")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            lat = location.coordinate.latitude
            lng = location.coordinate.longitude
            self.centerCoordinate = location.coordinate
            reverseCodeGeocoordinate(with: location.coordinate)
            locationManager.stopUpdatingLocation()
            
//            let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: lat, longitude: lng), zoom: 16)
//
////            mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
////            mapView.animate(to: camera)

            self.showMap(with: lat, and: lng, and: nil)
            
//            mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
         
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.centerCoordinate = position.target
        self.reverseCodeGeocoordinate(with: self.centerCoordinate)
    }
    
    func showMap(with lat: Double, and lng: Double, and name: String?) {
        
        let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: lat, longitude: lng), zoom: 16)
        
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.zoomGestures = true
        
        view.addSubview(mapView)
        view.bringSubview(toFront: searchInput)
        view.bringSubview(toFront: saveButton)
        view.bringSubview(toFront: searchTableView)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        reverseCodeGeocoordinate(with: coordinate)
    }
    
    func reverseCodeGeocoordinate(with coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
            if let err = error {
                print("Error : ", err)
            } else {
                if let addres = response?.firstResult() {
                    if let lines = addres.lines {
                        self.address = lines[0]
                        self.postalCode = addres.postalCode ?? ""
                        //self.showMap(with: coordinate.latitude, and: coordinate.longitude, and: lines[0])
                        
                        let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), zoom: 16)
                        self.mapView.animate(to: camera)
                        
//                        UIView.animate(withDuration: 0.3, animations: {
//                            self.view.layoutIfNeeded()
//                        })
                    }
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchTableView.alpha = 0
            searchResults.removeAll()
        } else {
            print("Searching for ... ", searchText)
            searchTableView.alpha = 1
            
            let placesClient = GMSPlacesClient()
            
            let visibleRegion = mapView.projection.visibleRegion()
            let bounds = GMSCoordinateBounds(coordinate: visibleRegion.nearLeft, coordinate: visibleRegion.nearRight)
            
            let filter = GMSAutocompleteFilter()
            filter.type = .noFilter
            
            placesClient.autocompleteQuery(searchText, bounds: bounds, filter: filter) { (results, error) in
                
                if let err = error {
                    print("🔥 Error : ", err)
                } else {
                    
                    if results == nil { return }
                    
                    for result in results! {
                        let result = result as GMSAutocompletePrediction
                        self.searchResults.append(result.attributedFullText.string)
                        self.searchTableView.reloadData()
                    }
                }
            }
        }
        searchResults.removeAll()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employerSearchCell", for: indexPath)
        if searchResults.count > 0 {
            cell.textLabel?.text = searchResults[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchTableView.alpha = 0
        
        let searchResult = searchResults[indexPath.row]
        
        searchInput.text = searchResult
        
        address = searchResult
        
        view.endEditing(true)
        
        JobseekerSignupAPIService.shared.searchLocation(searchText: searchResult) { (result, error) in
            if let err = error {
                print("Error: ", err)
            } else {
                //self.showMap(with: result!.lat, and: result!.lng, and: result!.name)
                self.reverseCodeGeocoordinate(with:  CLLocationCoordinate2D(latitude: result!.lat, longitude: result!.lng))
//                let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: result!.lat, longitude: result!.lng), zoom: 16)
//                self.mapView.animate(to: camera)
            }
        }
    }
    
    @objc private func save() {
        var selectedAddress = [String:Any]()
        selectedAddress["coordinate"] = self.centerCoordinate
        selectedAddress["address"] = self.address
        selectedAddress["postalCode"] = self.postalCode
        self.completion?(selectedAddress)
        navigationController?.popViewController(animated: true)
    }
}
