//
//  DetailViewController.swift
//  Yelp
//
//  Created by Tasfia Addrita on 2/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var enlargedFoodImageView: UIImageView!
    
    var business = Business!()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //enlargedFoodImageView.setImageWithURL(business.imageURL!)
        restaurantNameLabel.text = business.name
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
