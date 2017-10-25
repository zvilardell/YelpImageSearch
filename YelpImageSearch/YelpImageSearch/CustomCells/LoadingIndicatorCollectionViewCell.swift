//
//  LoadingIndicatorCollectionViewCell.swift
//  YelpImageSearch
//
//  Created by Zach Vilardell on 10/22/17.
//  Copyright © 2017 zvilardell. All rights reserved.
//

import UIKit

class LoadingIndicatorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup() {
        //start activity indicator
        loadingActivityIndicator.startAnimating()
    }
    
}
