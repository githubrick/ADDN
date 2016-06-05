//
//  MyAccountViewController.swift
//  ADDN
//
//  Created by Jiajie Li on 12/04/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//


// This is a class used to display the user information, it is one of the tab in the
// tab bar controller. It also provide the sign out function, which needs to interact
// with the server.

import UIKit
import SwiftyJSON
import SVProgressHUD

class MyAccountViewController: UITableViewController {

    @IBOutlet var name: UILabel!
    
    @IBOutlet var email: UILabel!
    
    @IBOutlet var region: UILabel!
    
    @IBOutlet var mobile: UILabel!
    
    var reply:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } 
    
    override func viewDidAppear(animated: Bool) {
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userInfo = userDefaults.objectForKey("UserInfo") as? NSDictionary
        if(userInfo == nil){
            let refreshAlert = UIAlertController(title: "", message: "Please Log in First.", preferredStyle: UIAlertControllerStyle.Alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                self.tabBarController?.selectedIndex = 0
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }else{
            name.text = userInfo!.objectForKey("user_name")! as? String
            region.text = userInfo!.objectForKey("region") as? String
            email.text = userInfo!.objectForKey("email_address") as? String
            mobile.text = userInfo!.objectForKey("user_mobile") as? String
        }
    }
    
    @IBAction func signOut(sender: AnyObject) {
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if(userDefaults.objectForKey("UserInfo") == nil){
            let message:UIAlertView = UIAlertView(title: "", message: "You haven't log in", delegate: self,cancelButtonTitle: "OK")
            message.show()
        }else{
            
            var parameters = [String:AnyObject]()
            parameters["username"] = name.text!
            HttpRequestManager.sharedManager.PostHttpRequest(LogoutAPI, parameters: parameters) { (response) in
                if let value = response.result.value {
                    //let jsonArr = JSON(value).array
                    self.reply = value as! String
                    
                    if(self.reply == "success"){
                        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        userDefaults.removeObjectForKey("UserInfo")
                        let message:UIAlertView = UIAlertView(title: "Sign Out", message: "sign out success", delegate: self,cancelButtonTitle: "OK")
                        message.show()
                    }else{
                        let message:UIAlertView = UIAlertView(title: "Sign Out", message:self.reply, delegate: self,cancelButtonTitle: "OK")
                        message.show()
                    }

                        
                    }
                    
                }
            }
        
    }
    
}
