//
//  Authority.swift
//  ADDN
//
//  Created by Jiajie Li on 27/04/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//

// this is a helper class used to varify the user authority.

import UIKit

class Authority: NSObject {
   
    class func check(centre: String)->Bool{
        
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userInfo = userDefaults.objectForKey("UserInfo") as? NSDictionary
        if(userInfo == nil){
            return false
        }else{
            let authorityCentre = userInfo!.objectForKey("region") as? String
            if(authorityCentre == "All"){
                return true
            }
            else if(authorityCentre == centre){
                return true
            }else{
                return false
            }
        }
    }
}
 