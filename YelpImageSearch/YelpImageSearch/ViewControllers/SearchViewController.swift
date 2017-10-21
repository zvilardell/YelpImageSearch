//
//  SearchViewController.swift
//  YelpImageSearch
//
//  Created by Zach Vilardell on 10/19/17.
//  Copyright © 2017 zvilardell. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    
    //determines "page" of search results to request next from API, once user scrolls to end of current page
    var pageCount: Int = 0
    
    //hold business image url search results to display
    var searchResults: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        YelpAPIRequestManager.sharedInstance.searchBusinessImages(keyword: "pizza", page: pageCount) {[unowned self] results in
            DispatchQueue.main.async {
                self.searchResults.append(contentsOf: results)
                self.searchResultsCollectionView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //keyboard search button was tapped
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: UICollectionView DataSource/Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessImageCollectionViewCell", for: indexPath) as! BusinessImageCollectionViewCell
        cell.setup(imageURLString: searchResults[indexPath.item])
        return cell
    }
}

