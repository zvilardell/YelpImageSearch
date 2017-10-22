//
//  SearchViewController.swift
//  YelpImageSearch
//
//  Created by Zach Vilardell on 10/19/17.
//  Copyright © 2017 zvilardell. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchActivityIndicator: UIActivityIndicatorView!
    
    //keep a reference to the search results collectionviewcontroller component of this page
    var searchResults: SearchResultsCollectionViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //set all necessary references involving the embedded components of this page
        if let id = segue.identifier {
            if id == "SearchResults" {
                searchResults = segue.destination as! SearchResultsCollectionViewController
                searchResults.parentVC = self
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //keyboard's search button was tapped
        
        //hide keyboard
        textField.resignFirstResponder()
        
        //begin new search process for entered text
        searchResults.newSearch(keyword: textField.text!)
        
        return true
    }
    
}

