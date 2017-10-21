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
        YelpAPIRequestManager.sharedInstance.searchBusinessImages(keyword: "pizza", page: pageCount) {[unowned self] results in
            DispatchQueue.main.async {
                self.searchResults.append(contentsOf: results)
                self.searchResultsCollectionView.reloadData()
            }
        }
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

    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //keyboard's search button was tapped
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: UICollectionView DataSource/Delegate/DelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessImageCollectionViewCell", for: indexPath) as! BusinessImageCollectionViewCell
        cell.setup(imageURLString: searchResults[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
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

