//
//  SubmitViewController.swift
//  OnTheMap
//
//  Created by Kyle Wilson on 2020-02-11.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import UIKit
import MapKit

class SubmitViewController: UIViewController {
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var locationRetrieved: String!
    
    var location: String = ""
    var coordinate: CLLocationCoordinate2D?
    
    var objectId: String = ""
    var uniqueKey: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var mapString: String = ""
    var mediaURL: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var studentLocation: StudentLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 5
        print(locationRetrieved!)
        search()
    }
    
    func search() {
        guard let location = locationRetrieved else {
            print("You have to enter your location first")
            return
        }
        CLGeocoder().geocodeAddressString(location) { (placemark, error) in
            
            guard error == nil else {
                print("Could not find your location")
                return
            }
            
            self.location = location
            self.coordinate = placemark!.first!.location!.coordinate
            self.pin(coordinate: self.coordinate!)
            self.latitude = (placemark?.first?.location?.coordinate.latitude)!
            self.longitude = (placemark?.first?.location?.coordinate.longitude)!
        }
    }
    
    func getUserInfo() {
        UdacityClient.getUser() { (success, student, error) in
            if success {
                print("student unique: \(student?.uniqueKey ?? "no key")")
                print("student first name: \(student?.firstName ?? "no first name")")
                print("student last name: \(student?.lastName ?? "no last name")")
                self.sendInformation(student!)
                
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Error", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func sendInformation(_ student: StudentLocation) {
        UdacityClient.postStudentLocation(student: student) { (success, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            
            if success {
                print("success")
                DispatchQueue.main.async {
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            } else {
                print("error")
            }
        }
    }
    
    func pin(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        DispatchQueue.main.async {
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(region, animated: true)
            self.mapView.regionThatFits(region)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        getUserInfo()
    }
}
