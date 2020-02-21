//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Kyle Wilson on 2020-02-11.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController {
    
    @IBOutlet weak var addPinButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadStudentLocations()
    }
    
    func loadStudentLocations() {
        UdacityClient.getStudentLocations { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            
            guard result != nil else {
                return
            }
            
            StudentLocation.lastFetched = result
            var mapPin = [MKPointAnnotation]()
            
            for location in result! {
                let longitude = CLLocationDegrees(location.longitude!)
                let latitude = CLLocationDegrees(location.latitude!)
                let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let mediaURL = location.mediaURL
                let firstName = location.firstName
                let lastName = location.lastName
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                annotation.title = "\(String(describing: firstName)) \(String(describing: lastName))"
                annotation.subtitle = mediaURL
                mapPin.append(annotation)
                
            }
            self.mapView.addAnnotations(mapPin)
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        loadStudentLocations()
    }
    
    @IBAction func addPinButtonTapped(_ sender: Any) {
        let locationVC = storyboard?.instantiateViewController(identifier: "AddLocationViewController") as! AddLocationViewController
        self.present(locationVC, animated: true, completion: nil)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let open = view.annotation?.subtitle {
                guard let url = URL(string: open!) else { return }
                openInSafari(url: url)
            }
        }
    }
    
    func openInSafari(url: URL) {
        if url.absoluteString.contains("https://") {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Invalid URL", message: "Could not load URL", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
