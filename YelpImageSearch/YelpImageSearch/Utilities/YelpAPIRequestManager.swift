//
//  YelpAPIRequestManager.swift
//  YelpImageSearch
//
//  Created by Zach Vilardell on 10/19/17.
//  Copyright © 2017 zvilardell. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

class YelpAPIRequestManager: NSObject {
    
    //base request url and endpoint strings
    let baseRequestURL: String = "https://api.yelp.com/v3"
    let searchEndpoint: String = "/businesses/search"
    
    //authorization token endpoint url string
    let authURL: String = "https://api.yelp.com/oauth2/token"
    
    //---------------------------------------------------------------------------------------------------------------------------
    
    //singleton
    static let sharedInstance = YelpAPIRequestManager()
    private override init() { //overriding init with private function to prevent usage of default public initializer for this class.
        super.init()
    }
    
    //---------------------------------------------------------------------------------------------------------------------------
    
    //retrieve auth token for Yelp API requests
    func getAuthorization(completion: @escaping (String)->()) {
        //check keychain for existing auth token
        if let token = KeychainWrapper.standard.string(forKey: "YelpImageSearch_Token") {
            completion(token)
            return
        } else if let plistPath = Bundle.main.path(forResource: "Info", ofType: "plist"), let plistDict = NSDictionary(contentsOfFile: plistPath),
            let clientID = plistDict["YelpClientID"] as? String, let clientSecret = plistDict["YelpClientSecret"] as? String {
            
            //client credentials retrieved from Info.plist, pass them to auth token request
            let parameterDict: [String:String] = [
                "grant_type" : "client_credentials",
                "client_id" : clientID,
                "client_secret" : clientSecret
            ]
            
            Alamofire.request(authURL, method: .post, parameters: parameterDict).responseJSON { response in
                if let responseDict = response.result.value as? NSDictionary, let token = responseDict["access_token"] as? String {
                    //successful response, store token in keychain for later use
                    //Yelp: "All tokens are now set to expire on January 18, 2038"
                    KeychainWrapper.standard.set(token, forKey: "YelpImageSearch_Token")
                    completion(token)
                } else if let error = response.result.error {
                    //an error occurred, print its details
                    print(error.localizedDescription)
                    completion("")
                } else {
                    print("Unable to retrieve Yelp auth token at this time")
                    completion("")
                }
            }
        }
    }
    
    //search businesses using the passed-in keyword
    func searchBusinesses(keyword: String, completion: ()->()) {
        getAuthorization { [unowned self] token in
            
            //header dictionary with auth token
            let headerDict: [String:String] = [
                "Authorization" : "Bearer \(token)"
            ]
            
            //dictionary of search parameters with keyword and user location
            let parameterDict: [String:Any] = [
                "term" : keyword,
                "latitude" : 37.7670169511878,
                "longitude" : -122.42184275,
                "radius" : 40000 //max search radius allowed (25 miles)
            ]

            Alamofire.request(self.baseRequestURL + self.searchEndpoint, method: .get, parameters: parameterDict, headers: headerDict).responseJSON { response in
                if let responseDict = response.result.value as? NSDictionary {
                    print(responseDict)
                } else if let error = response.result.error {
                    //an error occurred, print its details
                    print(error.localizedDescription)
                } else {
                    print("Unable to search Yelp businesses at this time")
                }
            }
        }
    }

}
