//
//  SignUpViewController.swift
//  ADDN
//
//  Created by Jiajie Li on 12/04/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//


// This class is used to handle the sign up operations, it will interact with the server.

import UIKit
import SwiftyJSON
import SVProgressHUD

class SignUpViewController: UIViewController, UITextFieldDelegate{

    
    var reply = ""
    @IBOutlet var userName: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var region: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var mobile: UITextField!
    
    @IBOutlet var scrollview: UIScrollView!
    var activeField: UITextField?
    
    var userInfo = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate = self
        password.delegate = self
        password!.secureTextEntry = true
        region.delegate = self
        email.delegate = self
        mobile.delegate = self
    } 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(SignUpViewController.keyboardOnScreen(_:)), name: UIKeyboardDidShowNotification, object: nil)
        center.addObserver(self, selector: #selector(SignUpViewController.keyboardOffScreen(_:)), name: UIKeyboardDidHideNotification, object: nil)
         
    }
    
    
    @IBAction func sendSignUp(sender: AnyObject) {
        if(userName.text == "" || password.text == "" || region.text == "" || email.text == "" || mobile.text == ""){
            let warning: UIAlertView = UIAlertView(title: "Empty Field", message: "Some information is missing", delegate: self, cancelButtonTitle: "Ok")
            warning.show()
        }else{
            var parameters = [String:AnyObject]()
            parameters["username"] = userName.text!
            parameters["password"] = password.text!
            parameters["mobile"] = mobile.text!
            parameters["region"] = region.text!
            parameters["email"] = email.text!
            
            HttpRequestManager.sharedManager.PostHttpRequest(SignUpAPI, parameters: parameters) { (response) in
                if let value = response.result.value {
                    let jsonArr = JSON(value).array
                    
                    if let jsonDic = JSON(value).dictionary{
                        let message:UIAlertView = UIAlertView(title: "Sign Up", message: jsonDic["signUp"]!.stringValue, delegate: self,cancelButtonTitle: "OK")
                        message.show()
                        return
                    }
                    
                    let dic = jsonArr![0].dictionaryObject!
                    self.itemsDownloaded(dic, info:"signUp")
                    SVProgressHUD.showSuccessWithStatus("Your account has been created Successful")
                }
            }
            
        }
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
//    func itemsDownloadedString(items: String) {
//        
//        reply = items
//        if(reply == "success"){
//            let message:UIAlertView = UIAlertView(title: "Sign Up", message: "Your account has been created", delegate: self,cancelButtonTitle: "OK")
//            message.show()
//            let homeModel = HomeModel()
//            //homeModel.delegate = self
//            let query = "query=SELECT * FROM Users WHERE user_name = '" + userName.text! + "';"
//            homeModel.downloadItems(query, info: "")
//        }else{
//            let message:UIAlertView = UIAlertView(title: "Sign Up", message: reply, delegate: self,cancelButtonTitle: "OK")
//            message.show()
//        }
//    }

    func  itemsDownloaded(items: Dictionary<String,AnyObject>, info: String){
        //let result: NSDictionary = items.objectAtIndex(0) as! NSDictionary
        userInfo = items
        startSegue()
    }
    
    func startSegue(){
        self.performSegueWithIdentifier("signUpSucceed",sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "signUpSucceed"){
            _ = segue.destinationViewController as! DashboardViewController
            let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.removeObjectForKey("UserInfo")
            userDefaults.setObject(userInfo, forKey: "UserInfo")
            
        }
         
    }
    
    func keyboardOnScreen(notification: NSNotification){
        let info: NSDictionary  = notification.userInfo!
        let kbSize = info.valueForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue().size
        
        let contentInsets:UIEdgeInsets  = UIEdgeInsetsMake(0.0, 0.0, kbSize!.height, 0.0)
        scrollview.contentInset = contentInsets
        scrollview.scrollIndicatorInsets = contentInsets
        var aRect: CGRect = self.view.frame
        aRect.size.height -= kbSize!.height
        
        //you may not need to scroll, see if the active field is already visible
        
        if (!CGRectContainsPoint(aRect, activeField!.frame.origin) ) {
            let scrollPoint:CGPoint = CGPointMake(0.0, activeField!.frame.origin.y - kbSize!.height)
            scrollview.setContentOffset(scrollPoint, animated: true)
        }
        
    }
    
    func keyboardOffScreen(notification: NSNotification){
        scrollview.setContentOffset(CGPoint(x: 0,y: 0),animated:true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        activeField = nil
    }
    
}
