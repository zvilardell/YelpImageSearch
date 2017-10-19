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
    
    //authorization endpoint url string
    let authURL: String = "https://api.yelp.com/oauth2/token"
    
    //---------------------------------------------------------------------------------------------------------------------------
    
    //singleton
    static let sharedInstance = YelpAPIRequestManager()
    private override init() { //overriding init with private function to prevent usage of default public initializer for this class.
        super.init()
    }
    
    //---------------------------------------------------------------------------------------------------------------------------
    
    //retrieve auth token for API requests
    func authorize() {
        //grab client credentials from info.plist
        if let plistPath = Bundle.main.path(forResource: "Info", ofType: "plist"), let plistDict = NSDictionary(contentsOfFile: plistPath),
        let clientID = plistDict["YelpClientID"] as? String, let clientSecret = plistDict["YelpClientSecret"] as? String {
            print(clientID)
            print(clientSecret)
        }
    }

}
