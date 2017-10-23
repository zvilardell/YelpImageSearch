//
//  SearchHistoryTableViewController.swift
//  YelpImageSearch
//
//  Created by Zach Vilardell on 10/22/17.
//  Copyright © 2017 zvilardell. All rights reserved.
//

import UIKit

class SearchHistoryTableViewController: UITableViewController {
    
    //keep a reference to our parent viewcontroller
    weak var parentVC: SearchViewController?
    
    //array of user's previous search queries
    var previousSearchKeywords: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        //don't display empty table cells below data
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UITableView DataSource/Delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previousSearchKeywords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryTableViewCell", for: indexPath) as! SearchHistoryTableViewCell
        cell.setup(keyword: previousSearchKeywords[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
