//
//  Business.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class Business: NSObject {
    let name: String?
    let address: String?
    let imageURL: NSURL?
    let categories: String?
    let distance: String?
    let ratingImageURL: NSURL?
    let reviewCount: NSNumber?
    
    let phoneNumber: String?
    let openOrClosed: Bool?
    
    let latitude: NSNumber?
    let longitude: NSNumber?
    let displayAddress: String?
    
    let street : String?
    let city: String?
    let state: String?
    let zipCode: String?
    
    let offset: NSNumber?
    
    init(dictionary: NSDictionary) {
        
        phoneNumber = dictionary["display_phone"] as? String
        openOrClosed = dictionary["is_closed"] as? Bool
        
        name = dictionary["name"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = NSURL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        var displayAddress = ""
        var street = ""
        var city = ""
        var state2 = ""
        var zipCode2 = ""
        var latitude : NSNumber?
        var longitude : NSNumber?
        
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
                street = addressArray![0] as! String
                displayAddress = addressArray![0] as! String
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                    displayAddress += ", "
                }
                address += neighborhoods![0] as! String
                displayAddress += neighborhoods![0] as! String
                city = neighborhoods![0] as! String
            }
            
            let state = location!["state_code"] as! String
            displayAddress += ", \(state)"
            state2 = state
            
            let zipCode = location!["postal_code"] as! String
            displayAddress += " \(zipCode)"
            zipCode2 = zipCode
            
            if let coordinate = location!["coordinate"] as? NSDictionary {
                latitude = coordinate["latitude"] as? NSNumber
                longitude = coordinate["longitude"] as? NSNumber
            }
        }
        
        self.address = address
        self.displayAddress = displayAddress
        self.street = street
        self.city = city
        self.state = state2
        self.zipCode = zipCode2
        self.latitude = latitude
        self.longitude = longitude
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joinWithSeparator(", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = NSURL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
        
        self.offset = 20
    }
    
    class func businesses(array array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    class func searchWithTerm(term: String, completion: ([Business]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
    }
    
//    class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: ([Business]!, NSError!) -> Void) -> Void {
//        YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, completion: completion)
//    }
    
    class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, offset: Int?, completion: ([Business]!, NSError!) -> Void) -> Void {
        //Add offset to call in business type
        YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, offset: offset, completion: completion)
    }
}
