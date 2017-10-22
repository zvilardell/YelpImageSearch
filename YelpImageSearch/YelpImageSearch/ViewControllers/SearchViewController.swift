//
//  SearchViewController.swift
//  YelpImageSearch
//
//  Created by Zach Vilardell on 10/19/17.
//  Copyright © 2017 zvilardell. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    
    //determines "page" of search results to request next from API, once user scrolls to end of current page
    var pageCount: Int = 0
    
    //hold business image url search results to display
    var searchResults: [String] = []
    
    //the collection view's cell width (calculated on viewDidAppear)
    var cellWidth: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startSearch(keyword: "pizza")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //on viewDidAppear, the collection view's onscreen bounds are accessible and accurate
        //cellWidth is half the width of the collectionview minus half the collectionview's interitem spacing (10/2 = 5)
        cellWidth = floor(searchResultsCollectionView.bounds.width / 2.0) - 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startSearch(keyword: String) {
        //retrieve current page of search results for keyword
        YelpAPIRequestManager.sharedInstance.searchBusinessImages(keyword: keyword, page: pageCount) {[unowned self] results in
            DispatchQueue.main.async {
                self.searchResults.append(contentsOf: results)
                self.searchResultsCollectionView.reloadData()
            }
        }
    }

    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //keyboard's search button was tapped
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: UICollectionView DataSource/Delegate/DelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //number of items is the number of search results plus 1 loading indicator cell at end of page
        return searchResults.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == searchResults.count {
            //reached end of search results, show loading indicator cell while loading next page of results
            return collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingIndicatorCollectionViewCell", for: indexPath)
        }
        
        //prepare image cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessImageCollectionViewCell", for: indexPath) as! BusinessImageCollectionViewCell
        cell.setup(imageURLString: searchResults[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == searchResults.count {
            //reached end of search results, increment page number
            pageCount += 1
            //grab next page of results for current search
            startSearch(keyword: "pizza")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cellWidth != nil { //ensure that cellWidth has been calculated before attempting to use it
        	return CGSize(width: cellWidth, height: cellWidth)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //minimum of 10 points spacing between row items in the collectionview
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //minimum of 10 points spacing between rows in the collectionview
        return 10.0
    }
    
}

