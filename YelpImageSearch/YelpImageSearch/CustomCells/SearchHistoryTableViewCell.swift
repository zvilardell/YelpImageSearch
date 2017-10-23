//
//  SearchHistoryTableViewCell.swift
//  YelpImageSearch
//
//  Created by Zach Vilardell on 10/23/17.
//  Copyright © 2017 zvilardell. All rights reserved.
//

import UIKit

class SearchHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchKeywordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchImageView.tintColor = UIColor.darkGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(keyword: String) {
        //set cell text
        searchKeywordLabel.text = keyword
    }

}
