//
//  SearchViewController.swift
//  YelpImageSearch
//
//  Created by Zach Vilardell on 10/19/17.
//  Copyright © 2017 zvilardell. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var searchActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchHistoryContainer: UIView!
    @IBOutlet weak var searchHistoryBottomSpaceConstraint: NSLayoutConstraint!
    
    //keep references to embedded components of this page
    var searchResults: SearchResultsCollectionViewController!
    var searchHistory: SearchHistoryTableViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //set all necessary references involving the embedded components of this page
        if let id = segue.identifier {
            if id == "SearchResults" {
                searchResults = segue.destination as! SearchResultsCollectionViewController
                searchResults.parentVC = self
            } else if id == "SearchHistory" {
                searchHistory = segue.destination as! SearchHistoryTableViewController
                searchHistory.container = searchHistoryContainer
                searchHistory.bottomSpaceConstraint = searchHistoryBottomSpaceConstraint
                searchHistory.parentVC = self
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
        historyButton.tintColor = UIColor.darkGray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(title: String, message: String, completion: (()->())?) {
        //create and show an alert from passed-in values
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: completion)
    }

    @IBAction func historyButtonTapped(_ sender: UIButton) {
        if searchHistory.previousSearchKeywords.isEmpty {
            //no search history yet, show alert
            showAlert(title: "No history found", message: "Please perform a search to add a keyword to your search history.") {}
        } else {
        	searchHistory.toggleHistoryView()
        }
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //keyboard's search button was tapped
        
        //hide keyboard
        textField.resignFirstResponder()
        
        //begin new search process for entered text
        searchResults.newSearch(keyword: textField.text!)
        
        //add search keyword to history
        searchHistory.addSearch(keyword: textField.text!)
        
        return true
    }
    
}

