//
//  SearchViewController.swift
//  YelpImageSearch
//
//  Created by Zach Vilardell on 10/19/17.
//  Copyright © 2017 zvilardell. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var searchActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchResultsVeilView: UIView!
    @IBOutlet weak var searchHistoryContainer: UIView!
    @IBOutlet weak var searchHistoryBottomSpaceConstraint: NSLayoutConstraint!
    
    //keep references to embedded components of this page
    var searchResults: SearchResultsCollectionViewController!
    var searchHistory: SearchHistoryTableViewController!
    
    //we will use this object to retrieve user's location
    let locationManager = CLLocationManager()
    
    //set all necessary references involving the embedded components of this page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let id = segue.identifier {
            if id == "SearchResults" {
                searchResults = segue.destination as! SearchResultsCollectionViewController
                searchResults.parentVC = self
            } else if id == "SearchHistory" {
                searchHistory = segue.destination as! SearchHistoryTableViewController
                searchHistory.container = searchHistoryContainer
                searchHistory.veilView = searchResultsVeilView
                searchHistory.bottomSpaceConstraint = searchHistoryBottomSpaceConstraint
                searchHistory.parentVC = self
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set history button tint
        historyButton.tintColor = UIColor.darkGray
        
        //add search image to text field's leftView
        let searchImageView = UIImageView(image: UIImage(named: "search"))
        searchImageView.frame = CGRect(x: 0.0, y: 0.0, width: 25.0, height: 20.0)
        searchImageView.contentMode = .scaleAspectFit
        searchImageView.tintColor = UIColor.lightGray
        searchTextField.leftView = searchImageView
        searchTextField.leftViewMode = .always
        
        //location services
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined {
            //location permissions not yet determined, request them
            locationManager.requestWhenInUseAuthorization()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //create and show an alert from passed-in values
    func showAlert(title: String, message: String, completion: ((UIAlertAction)->())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: completion))
        present(alert, animated: true, completion: nil)
    }

    //handle history button tap
    @IBAction func historyButtonTapped(_ sender: UIButton) {
        if searchHistory.previousSearchKeywords.isEmpty {
            //no search history yet, show alert
            showAlert(title: "No history found", message: "Please perform a search to add a keyword to your search history.", completion: nil)
        } else {
        	searchHistory.toggleHistoryView()
        }
    }
    
    //when a keyword is selected from history, perform search
    func performSearchFromHistory(keyword: String) {
        //set search text
        searchTextField.text = keyword
        //simulate textfield's "Search" keypress to begin search
        let _ = textFieldShouldReturn(searchTextField)
    }
    
    //handle searchResultsVeilView tap
    @IBAction func veilViewTapped(_ sender: Any) {
        //hide history (and veil view)
        searchHistory.toggleHistoryView()
        //hide keyboard
        searchTextField.resignFirstResponder()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //keyboard's search button was tapped
        
        //check location permissions before performing search
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //hide keyboard
            textField.resignFirstResponder()
            
            //begin new search process for entered text
            searchResults.newSearch(keyword: textField.text!)
            
            //add search keyword to history
            searchHistory.addSearch(keyword: textField.text!)
        } else {
            //location permissions denied, show alert
            showAlert(title: "Update Location Permissions", message: "Please allow this app to access your location to provide relevant search results.", completion: { _ in
                //navigate to app settings
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            })
        }
        
        return true
    }
    
    //MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //save user location coordinates to UserDefaults
        let coordinate = locations.first!.coordinate
        UserDefaults.standard.set(coordinate.longitude, forKey: "longitude")
        UserDefaults.standard.set(coordinate.latitude, forKey: "latitude")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            //location permissions granted, start grabbing user's location
            locationManager.startUpdatingLocation()
        } else if status != .notDetermined {
            //location permissions denied, show alert
            showAlert(title: "Update Location Permissions", message: "Please allow this app to access your location to provide relevant search results.", completion: { _ in
                //navigate to app settings
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}

