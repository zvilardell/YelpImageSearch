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
    func authorize() {
        //check keychain for existing auth token
        if let _ = KeychainWrapper.standard.string(forKey: "YelpImageSearch_Token") {
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
                    KeychainWrapper.standard.set(token, forKey: "YelpImageSearch_Token")
                } else if let error = response.result.error {
                    //an error occurred, print its details
                    print(error.localizedDescription)
                } else {
                    print("Unable to retrieve Yelp auth token at this time")
                }
            }
        }
    }

}
