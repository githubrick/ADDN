//
//  GetConcenedPatients.swift
//  ADDN
//
//  Created by Jiajie Li on 27/04/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//


// This is the class used to get the interested patient. In detail, after the user
// receive the notification, because the notificaiotn payload cannot be too long,
// hence the information it carries is limited, so it cannot directly tell the 
// application the information of the new patient. Instead, it tell the application the
// patient id, therefore, the application can requert the patient data by the id.
// And that is what this class does.

import UIKit
import SwiftyJSON
import SVProgressHUD

class GetConcenedPatients: NSObject{
   
    var patient = ""
    
    func start(patientid:String){
        patient = patientid
//        let bodyData = "query=SELECT addn_id, centre_code,diabetes_type, gender, (DATEDIFF(CURRENT_DATE, date_of_birth)/365) as age, user_name, email_address, user_mobile FROM PATIENT, Users Where record_doctor_id = userid AND addn_id =" + patientid
//        
//        let connection = HomeModel()
//        connection.delegate = self
//        connection.downloadItems(bodyData, info: "")
        
        
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userInfo = userDefaults.objectForKey("UserInfo") as? NSDictionary
        if(userInfo != nil){
            var parameters = [String:AnyObject]()
            let userid:String = (userInfo!.objectForKey("userid")! as? String)!
            parameters["userid"] = userid
            parameters["localid_id"] = patientid
            HttpRequestManager.sharedManager.PostHttpRequest(NotificationAPI, parameters: parameters) { (response) in
                if let value = response.result.value {
                    //let jsonArr = JSON(value).array
                    if  let jsonArr = JSON(value).array{
                        let dic = jsonArr[0].dictionaryObject!
                        self.itemsDownloaded(dic, info: "concernedPatient")
                    }
                        
                    }
                    
                }
                
            }
        
    }
    
    func  itemsDownloaded(items: Dictionary<String,AnyObject>, info: String){
        let returnData = items//items.objectAtIndex(0) as! NSDictionary
        
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let arrayOfConcernedPatients = userDefaults.objectForKey("ConcernedPatients") as? NSArray
        if(arrayOfConcernedPatients == nil){
            let comdata:NSMutableArray = NSMutableArray()
            comdata.addObject(returnData)
            userDefaults.setObject(comdata, forKey: "ConcernedPatients")
        }else{
            let newArray = NSMutableArray()
            for i in 0 ..< arrayOfConcernedPatients!.count{
                newArray.addObject(arrayOfConcernedPatients![i])
            }
            newArray.addObject(returnData)
            userDefaults.removeObjectForKey("ConcernedPatients")
            userDefaults.setObject(newArray, forKey: "ConcernedPatients")
        }
        
    }
    
}


