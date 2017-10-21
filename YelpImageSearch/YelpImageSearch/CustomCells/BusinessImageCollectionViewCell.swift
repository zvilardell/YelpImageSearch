//
//  BusinessImageCollectionViewCell.swift
//  YelpImageSearch
//
//  Created by Zach Vilardell on 10/21/17.
//  Copyright © 2017 zvilardell. All rights reserved.
//

import UIKit
import SDWebImage

class BusinessImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var businessImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(imageURLString: String) {
        //load image from passed-in url string
        if let imageURL = URL(string: imageURLString) {
            //load image asynchronously from url
            businessImageView.sd_setImage(with: imageURL)
        } else {
            //no image for this cell
            businessImageView.image = nil
        }
    }
}
