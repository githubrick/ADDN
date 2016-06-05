//
//  NotificationDetailViewController.swift
//  ADDN
//
//  Created by Jiajie Li on 14/04/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//


// This class is used to display the detail of the notification preferences that the user
// set previously. 

import UIKit
import SVProgressHUD
import SwiftyJSON

class NotificationDetailViewController: UIViewController {

    
    @IBOutlet var diabetesTypeLabel: UILabel!

    @IBOutlet var genderLabel: UILabel!
    
    @IBOutlet var maxAgeLabel: UILabel!
    
    @IBOutlet var minAgeLabel: UILabel!
    
    var gender:String!
    var maxAge:String!
    var minAge:String!
    var diabetesType:String!
    var interestedId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diabetesTypeLabel.text = diabetesType
        genderLabel.text = gender
        maxAgeLabel.text = maxAge
        minAgeLabel.text = minAge
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func deleteNotification(sender: AnyObject) {
        var parameters = [String:AnyObject]()
        parameters["command"] = "delete"
        parameters["interestedId"] = interestedId
        // the parameters below is not needed for 'delete' command
        parameters["deviceToken"] = AppDelegate.deviceToken
        parameters["minAge"] = ""
        parameters["maxAge"] = ""
        parameters["gender"] = ""
        parameters["diabetesType"] = ""
        
        HttpRequestManager.sharedManager.PostHttpRequest(NotificationAPI, parameters: parameters) { (response) in
            if let value = response.result.value {
                //let jsonArr = JSON(value).array
                if let jsonDic = JSON(value).dictionaryObject{
                    let msg = jsonDic["msg"] as! String
                    //print(msg)
                    self.itemsDownloadedString(msg)
                    
                }
                
            }

        }
        
    }

    func itemsDownloadedString(items: String) {
        
        let reply = items
        if(reply == "ok"){
            //print("Notification deleted")
            SVProgressHUD.showSuccessWithStatus("Notification deleted")
            self.navigationController!.popViewControllerAnimated(true);
        }else{
            let message:UIAlertView = UIAlertView(title: "Fail", message: "Unable to delete notification", delegate: self,cancelButtonTitle: "OK")
            message.show()
        }
    }
    
}
