//
//  ViewController.swift
//  Chicago crime map
//
//  Created by Ryoya Hashimoto on 2/10/23.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager:CLLocationManager!
    
    // Create DataManager Object
    let dataManager: DataManager = DataManager.sharedInstance
    
    // To load data from plist
    var crimeArray = [Place]()
    var crimeDict = [String: AnyObject]()
    
    // Keep the UISearchController in memory after it’s created
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Detect first launch of an user
        // Attribution: https://stackoverflow.com/questions/27208103/detect-first-launch-of-ios-app
        let initialDate = UserDefaults.standard.object(forKey: "Initial Launch") as! Date
        let loginCount = UserDefaults.standard.object(forKey: "Login Count") as! Int
        
        if initialDate != nil && loginCount == 3 {
            let alert = UIAlertController(title: "Notice", message: "Please Rate This App in the App Store", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            UserDefaults.standard.set(loginCount + 1, forKey: "Login Count")
        } else if initialDate != nil {
            print("DEBUG ----> Not first launch. Date:\(initialDate) LoginCount:\(loginCount)")
            UserDefaults.standard.set(loginCount + 1, forKey: "Login Count")
        } else {
            print("DEBUG ----> First launch, setting UserDefault.")
            UserDefaults.standard.set(Date(), forKey: "Initial Launch")
        }
        
        // Settings for Location Manager
        //locationManager = CLLocationManager()
        //locationManager.delegate = self
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.requestWhenInUseAuthorization()
        //locationManager.requestLocation()
        //if CLLocationManager.locationServicesEnabled() {
        //    locationManager!.startUpdatingLocation()
        //}
        
        // Set user's initial place
        let coordinate = CLLocationCoordinate2D(latitude: 41.78604, longitude: -87.59395)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.00978871051851371, longitudeDelta: 0.008167393319212124)
        mapView.region = MKCoordinateRegion.init(center: coordinate, span: span)
        
        
        // Settings for Search Bar
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        locationSearchTable.handleMapSearchDelegate = self
        let resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        locationSearchTable.mapView = mapView
        resultSearchController.searchBar.showsCancelButton = true
        resultSearchController.searchBar.placeholder = "Search for places"
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = resultSearchController
        
        // Settings for Navigation Bar
        navigationItem.title = "Chicago Crime Map"
        self.navigationController?.navigationBar.titleTextAttributes = [
            //NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.heavy)
        ]
        //navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .close, target: nil, action: nil)
        navigationController?.navigationBar.backgroundColor = .systemOrange
        
        // Load a CSV file
        // Attribution: https://qiita.com/YutaMatsuura715/items/f5d2903637bfee776411
        var csvLines = [String]()

        guard let path = Bundle.main.path(forResource:"crimeToPresent", ofType:"csv") else {
                print("Failure to find CSV file")
                return
            }

        do {
            let csvString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            csvLines = csvString.components(separatedBy: .newlines)
                    csvLines.removeLast()
            csvLines.removeFirst()
            } catch let error as NSError {
                print("Error: \(error)")
                return
            }
        
        //Convert each row of data to class objects
        // Attribution: https://stackoverflow.com/questions/32313938/parsing-csv-file-in-swift
        for crimeData in csvLines {
            let crimeDetail = crimeData.components(separatedBy: ",")
            
            let place = Place()
            place.id = crimeDetail[0]
            place.date = crimeDetail[2]
            place.address = crimeDetail[3]
            place.crimeType = crimeDetail[5]
            place.crimeDescription = crimeDetail[6]
            place.locationDescription = crimeDetail[7]
            place.arrest = crimeDetail[8]
            place.domestic = crimeDetail[9]
            
            place.title = crimeDetail[5]
            place.subtitle = crimeDetail[2]
            
            //print("date type \(place.date_DATETYPE)")
            
            let lat = (crimeDetail[19] as AnyObject).doubleValue
            let long = (crimeDetail[20] as AnyObject).doubleValue
            place.coordinate = CLLocationCoordinate2DMake(lat!, long!)
            
            crimeArray.append(place)
                }
        
        // Save the data into DataManager
        DataManager.sharedInstance.refreshCrimeData(crimeArray)
        
        // Show each point in the map
        mapView.addAnnotations(crimeArray)
        mapView.selectedAnnotations = crimeArray
            }
    
    // Attribution: https://medium.com/@kiransjadhav111/corelocation-map-kit-get-the-users-current-location-set-a-pin-in-swift-edb12f9166b2
    override func viewDidAppear(_ animated: Bool) {
            determineCurrentLocation()
        }
    
        //MARK:- CLLocationManagerDelegate Methods

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let mUserLocation:CLLocation = locations[0] as CLLocation

            let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
            let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

            mapView.setRegion(mRegion, animated: true)
        }
    
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error - locationManager: \(error.localizedDescription)")
        }
    
        //MARK:- Intance Methods

        func determineCurrentLocation() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()

            if CLLocationManager.locationServicesEnabled() {
                //locationManager.startUpdatingLocation()
            }
        }
    
}

//
// MARK: - MKMapView Delegate
//

extension ViewController: MKMapViewDelegate {

    // Attribution: https://www.letitride.jp/entry/2019/08/23/104809
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //Create annotation view
        let pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        // Display annotation
        pinView.canShowCallout = true
        pinView.displayPriority = .defaultLow
        pinView.clusteringIdentifier = "Place"
        
        // Change images and colors of markers
        // Attribution: https://teratail.com/questions/44811
        pinView.annotation = annotation
        if let pin = annotation as? Place {
            if pin.crimeType == "THEFT"{
                pinView.markerTintColor = .red
            } else if pin.crimeType == "BATTERY"{
                pinView.markerTintColor = .green
            } else if pin.crimeType == "CRIMINAL DAMAGE"{
                pinView.markerTintColor = .blue
            } else if pin.crimeType == "MOTOR VEHICLE THEFT"{
                pinView.markerTintColor = .black
            } else if pin.crimeType == "ASSAULT"{
                pinView.markerTintColor = .orange
            } else if pin.crimeType == "DECEPTIVE PRACTICE"{
                pinView.markerTintColor = .brown
            } else if pin.crimeType == "OTHER OFFENSE"{
                pinView.markerTintColor = .systemPink
            } else if pin.crimeType == "ROBBERY"{
                pinView.markerTintColor = .systemCyan
            } else if pin.crimeType == "BURGLARY"{
                pinView.markerTintColor = .white
            } else if pin.crimeType == "CRIMINAL TRESPASS"{
                pinView.markerTintColor = .darkGray
            } else if pin.crimeType == "NARCOTICS"{
                pinView.markerTintColor = .gray
            } else if pin.crimeType == "OFFENSE INVOLVING CHILDREN"{
                pinView.markerTintColor = .systemMint
            } else if pin.crimeType == "CRIMINAL SEXUAL ASSAULT"{
                pinView.markerTintColor = .systemTeal
            } else if pin.crimeType == "SEX OFFENSE"{
                pinView.markerTintColor = .lightGray
            } else if pin.crimeType == "HOMICIDE"{
                pinView.markerTintColor = .purple
            } else if pin.crimeType == "STALKING"{
                pinView.markerTintColor = .magenta
            }
            
        }
        
        // Add a button to display the detail information
        let button = UIButton(type: .detailDisclosure)
        
        pinView.rightCalloutAccessoryView = button
        return pinView
        }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        // Update a Place object in DataManager
        if let crime = view.annotation as? Place {
            DataManager.sharedInstance.updateCrimeAnnotation(crimeAnnotation: crime)
            
        }
        
        // This illustrates how to detect which annotation type was tapped on for its callout.
        if let detailNavController = storyboard?.instantiateViewController(withIdentifier: "DetailNavController") {
        detailNavController.modalPresentationStyle = .popover
        let presentationController = detailNavController.popoverPresentationController
               
        // Anchor the popover to the button that triggered the popover.
        presentationController?.sourceRect = control.frame
        presentationController?.sourceView = control
                
        present(detailNavController, animated: true, completion: nil)
        }
    }
    
}

//
// MARK: - Navigation
//

extension ViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let filtersVC = segue.destination as? FiltersViewController
        filtersVC?.delegate = self
        
        segue.destination.preferredContentSize = CGSize(width: 340, height: 240)
        
        if let presentationController = segue.destination.popoverPresentationController { // 1
            presentationController.delegate = self // 2
        }
        
    }
}

//
// MARK: - Protocol Extensions
//

extension ViewController: UIPopoverPresentationControllerDelegate {
    
    /// Delegate method to enforce the correct popover style
    func adaptivePresentationStyle(for controller: UIPresentationController,traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension ViewController: PlacesFilterDelegate {
    
    func changeFilter(crimeType: String, date: String) {
        print("DEBUG ----> The changeFilter is activated")
        
        if crimeType == "ALL" && date == "All" {
            DataManager.sharedInstance.updateFilteredCrimes(DataManager.sharedInstance.crimes)
        } else {
            let filteredCrimes = DataManager.sharedInstance.crimes.filter { crime in
                // Extract crime types matches the condition
                var matchesSelectedCrimeType = true
                if crimeType != "ALL" {
                    matchesSelectedCrimeType = crime.crimeType == crimeType
                }
                
                // Compare date
                var matchesSelectedDate = true
                if date == "1 week" {
                    let comparedDate = Calendar.current.date(byAdding: .day, value: -8, to: Date())
                    matchesSelectedDate = crime.date_DATETYPE > comparedDate ?? Date()
                } else if date == "2 weeks" {
                    let comparedDate = Calendar.current.date(byAdding: .day, value: -21, to: Date())
                    matchesSelectedDate = crime.date_DATETYPE > comparedDate ?? Date()
                } else if date == "Month" {
                    let comparedDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
                    matchesSelectedDate = crime.date_DATETYPE > comparedDate ?? Date()
                }
                
                if crimeType == "ALL" && date != "All" {
                    return matchesSelectedDate
                } else if crimeType != "ALL" && date == "All" {
                    return matchesSelectedCrimeType
                } else {
                    return matchesSelectedCrimeType && matchesSelectedDate
                }
            }
            DataManager.sharedInstance.updateFilteredCrimes(filteredCrimes)
        }
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(DataManager.sharedInstance.filteredCrimes)
    }
}

//
// MARK: - LocationSearchTable
//

extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark){
        
        // clear existing pins
        //mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion.init(center: placemark.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }
}
