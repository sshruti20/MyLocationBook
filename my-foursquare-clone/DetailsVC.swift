//
//  DetailsVC.swift
//  my-foursquare-clone
//
//  Created by Shruti S on 17/05/23.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    @IBOutlet weak var detailsMapView: MKMapView!
    
    var placeLatitude = Double()
    var placeLongitude = Double()
    
    var chosenPlaceId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromParse()
        detailsMapView.delegate = self
    
    }
    
    func getDataFromParse() {
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                
            } else {
                //print(objects)
                if objects?.count == 1 {
                    
                    //OBJECTS
                    let placeObject = objects?.first
                    self.detailsNameLabel.text = placeObject?.object(forKey: "name") as? String
                    
                    self.detailsTypeLabel.text = placeObject?.object(forKey: "type") as? String
                    self.detailsAtmosphereLabel.text = placeObject?.object(forKey: "atmosphere") as? String
                    
                    let imageData = placeObject?.object(forKey: "image") as? PFFileObject
                    imageData?.getDataInBackground { data, error in
                        if error == nil && data != nil {
                            self.detailsImageView.image = UIImage(data: data!)
                        }
                    }
                    
                    let latitude = placeObject?.object(forKey: "latitude") as? String
                    let longtiude = placeObject?.object(forKey: "longitude") as? String
                    
                    
                    self.placeLatitude = Double(latitude!) ?? 0
                    self.placeLongitude = Double(longtiude!) ?? 0
                    
                    // MAPS
                    let location = CLLocationCoordinate2D(latitude: self.placeLatitude, longitude: self.placeLongitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                    let region = MKCoordinateRegion(center: location, span: span)
                    self.detailsMapView.setRegion(region, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotation.title = self.detailsNameLabel.text!
                    annotation.subtitle = self.detailsTypeLabel.text!
                    self.detailsMapView.addAnnotation(annotation)
                }
            }
        } // callback ends
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView?.canShowCallout = true
                let button = UIButton(type: .detailDisclosure)
                pinView?.rightCalloutAccessoryView = button
            } else {
                pinView?.annotation = annotation
            }
            return pinView
        }
 
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.placeLongitude != 0.0 && self.placeLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.placeLatitude, longitude: self.placeLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    
                    if placemark.count > 0 {
                        
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.detailsNameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
    

}
