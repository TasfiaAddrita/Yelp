//
//  BusinessCell.swift
//  Yelp
//
//  Created by Tasfia Addrita on 2/19/16.
//  Copyright © 2016 Tasfia Addrita. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var business : Business! {
        didSet {
            foodImageView.setImageWithURL(business.imageURL!)
            restaurantNameLabel.text = business.name
            distanceLabel.text = business.distance
            ratingImageView.setImageWithURL(business.ratingImageURL!)
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            addressLabel.text = business.address
            categoryLabel.text = business.categories
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        foodImageView.layer.cornerRadius = 3
        foodImageView.clipsToBounds = true
        
        restaurantNameLabel.preferredMaxLayoutWidth = restaurantNameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        restaurantNameLabel.preferredMaxLayoutWidth = restaurantNameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
