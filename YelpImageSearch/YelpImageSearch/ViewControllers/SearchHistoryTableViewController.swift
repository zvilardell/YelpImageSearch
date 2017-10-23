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
    weak var parentVC: SearchViewController!
    
    //reference to tableviewcontroller's container
    weak var container: UIView!
    
    //reference to the view that "veils" search results while history is shown
    weak var veilView: UIView!
    
    //reference to tableviewcontroller container's bottom space constraint
    weak var bottomSpaceConstraint: NSLayoutConstraint!
    
    //array of user's previous search queries
    var previousSearchKeywords: [String] = []
    
    //height of cells displayed in table
    let rowHeight: CGFloat = 40.0
    
    //maximum possible height for table view (captured on viewDidAppear)
    var maxTableHeight: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        //don't display empty table cells below data
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //history table view is fully expanded but hidden on viewDidAppear
        //capture its height as the maxTableHeight
        maxTableHeight = tableView.bounds.height
        //collapse the hidden table view until user expands it by tapping history button
        bottomSpaceConstraint.constant = maxTableHeight
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //add entered search keywords to history
    func addSearch(keyword: String) {
        if !previousSearchKeywords.contains(keyword) {
            previousSearchKeywords.append(keyword)
            tableView.reloadData()
        }
        //when a search is performed, ensure that the history view is hidden
        if !container.isHidden {
            toggleHistoryView()
        }
    }
    
    //display or hide table view of previous search keywords
    func toggleHistoryView() {
        container.isHidden = !container.isHidden
        veilView.isHidden = !veilView.isHidden
        if !container.isHidden {
            //animate/expand search history into view
            UIView.animate(withDuration: 0.2,
                           animations: { [unowned self] in
                               let expandedHeight = CGFloat(self.previousSearchKeywords.count) * self.rowHeight
                               self.bottomSpaceConstraint.constant = expandedHeight > self.maxTableHeight ? 0.0 //fully expanded
                                                                                                          : self.maxTableHeight - expandedHeight //expanded to reveal populated rows
                               self.parentVC.view.layoutIfNeeded()
                           },
                           completion: { [unowned self] _ in
                               //ensure that the table view always displays the beginning of its content on display
                               self.tableView.setContentOffset(CGPoint.zero, animated: false)
                           })
        } else {
            //collapse hidden table view for next expansion
            bottomSpaceConstraint.constant = maxTableHeight
        }
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //remove cell highlight after selection
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
