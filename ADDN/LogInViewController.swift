//
//  LogInViewController.swift
//  ADDN
//
//  Created by Jiajie Li on 12/04/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//

// This class is used to handle the login operaion of the users. It needs to interact 
// with the server.

import UIKit
import SwiftyJSON
import SVProgressHUD

class LogInViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet var userName: UITextField!
    @IBOutlet var password: UITextField!
 
    var reply:String = ""
    var userInfo = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate = self
        password.delegate = self
        password!.secureTextEntry = true
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if(userDefaults.objectForKey("UserInfo") != nil){
            let warning: UIAlertView = UIAlertView(title: "You already login", message: "To login to another account, please sign out first", delegate: self, cancelButtonTitle: "Ok")
            warning.show()
            return
        }
        if(userName.text == "" || password.text == ""){
            let warning: UIAlertView = UIAlertView(title: "Missing Value", message: "The value cannot be empty", delegate: self, cancelButtonTitle: "Ok")
            warning.show()
        }else{
            var parameters = [String:AnyObject]()
            parameters["username"] = userName.text!
            parameters["password"] = password.text!
            parameters["deviceToken"] = AppDelegate.deviceToken
            //parameters["type"] = "login"
            
            HttpRequestManager.sharedManager.PostHttpRequest(LoginAPI, parameters: parameters) { (response) in
                if let value = response.result.value {
                    let jsonArr = JSON(value).array
                    
                    // if login Failure the return value has only one json string
                    if let jsonDic = JSON(value).dictionary{
                        let message:UIAlertView = UIAlertView(title: "Login", message: jsonDic["login"]!.stringValue, delegate: self,cancelButtonTitle: "OK")
                        message.show()
                        return
                    }
                    
                    let dic = jsonArr![0].dictionaryObject!
                    self.itemsDownloaded(dic, info:"login")
                    SVProgressHUD.showSuccessWithStatus("Login Success")
                    
                    }
                    
                }
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    func  itemsDownloaded(items: Dictionary<String,AnyObject>, info: String){
        //let result: NSDictionary = items.objectAtIndex(0) as! NSDictionary
        userInfo = items
        startSegue()
    }
    
    
    func startSegue(){
        self.performSegueWithIdentifier("logInSucceed",sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "logInSucceed"){
            _ = segue.destinationViewController as! DashboardViewController
            let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.removeObjectForKey("UserInfo")
            userDefaults.setObject(userInfo, forKey: "UserInfo")
        }
        
    }

}
