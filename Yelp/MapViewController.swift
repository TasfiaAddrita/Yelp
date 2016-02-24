//
//  MapViewController.swift
//  Yelp
//
//  Created by Tasfia Addrita on 2/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var latitude = 0.0
    var longitude = 0.0
    var businessName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = businessName
        
        let centerLocation = CLLocation(latitude: latitude, longitude: longitude)
        let annotationLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        goToLocation(centerLocation)
        addAnnotationAtCoordinate(annotationLocation)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.001, 0.001)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = businessName
        mapView.addAnnotation(annotation)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
