//
//  DetailViewController.swift
//  Yelp
//
//  Created by Tasfia Addrita on 2/23/16.
//  Copyright © 2016 Tasfia Addrita. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

class DetailViewController: UIViewController {

    @IBOutlet weak var enlargedFoodImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var typeOfFoodLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var openOrClosedLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressButton: UIButton!

    var business = Business!()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = business.name

        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = enlargedFoodImageView.bounds
        enlargedFoodImageView.setImageWithURL(business.imageURL!)
        enlargedFoodImageView.addSubview(blurView)
        
        restaurantNameLabel.text = business.name
        ratingImageView.setImageWithURL(business.ratingImageURL!)
        reviewCountLabel.text = "\(business.reviewCount!) Reviews"
        typeOfFoodLabel.text = business.categories
        phoneNumberLabel.text = business.phoneNumber
        addressLabel.text = business.displayAddress
        addressButton.setTitle(business.displayAddress, forState: .Normal)
        
        restaurantNameLabel.preferredMaxLayoutWidth = restaurantNameLabel.frame.size.width
        
        let openOrClose = business.openOrClosed
        if (openOrClose == false) {
            openOrClosedLabel.text = "Currently Open!"
            openOrClosedLabel.textColor = UIColor(red: 0, green: 125/255, blue: 0, alpha: 1)
        } else {
            openOrClosedLabel.text = "Currently Closed"
            openOrClosedLabel.textColor = UIColor.redColor()
        }
        
        let latitude = business.latitude as! Double
        let longitude = business.longitude as! Double
        
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
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func openMapsApp(sender: AnyObject) {
        
        let latitude = business.latitude as! Double
        let longitude = business.longitude as! Double
        
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        
        let address : [String : AnyObject] = [kABPersonAddressStreetKey as String: business.street!,
            kABPersonAddressCityKey as String: business.city!,
            kABPersonAddressStateKey as String: business.state!,
            kABPersonAddressZIPKey as String: business.zipCode!,
            kABPersonAddressCountryCodeKey as String: "US"]
        
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: address)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(self.business.name!)"
        
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let latitude = business.latitude as! Double
        let longitude = business.longitude as! Double
        let businessName = business.name! as String
        
        let mapViewController = segue.destinationViewController as! MapViewController
        mapViewController.latitude = latitude
        mapViewController.longitude = longitude
        mapViewController.businessName = businessName
    }

}
