//
//  NotificationViewController.swift
//  ADDN
//
//  Created by Jiajie Li on 14/04/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//

// This class is used for allowing user to create new notification preferences by choosing
// different parameters. It will sent the request to server after the user press the done button.

import UIKit
import SwiftyJSON
import SVProgressHUD

class AddNotificationViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate{

    @IBOutlet var pickerView1: UIPickerView!
    

    
    @IBOutlet var slider1: UISlider!
    
    @IBOutlet var slider2: UISlider!
    
    @IBOutlet var sliderValueLabel1: UILabel!
    
    @IBOutlet var sliderValueLabel2: UILabel!
    
    @IBOutlet var myswitch: UISwitch!
    
    @IBOutlet var switchInfo: UILabel!
    
    
    var diabetesType = ["TYPE_1", "TYPE_2", "MONOGENIC", "CFRD", "NEONATAL", "OTHER"]
    
    var deviceToken:String = ""
    var selectedDiabeteType:String = "TYPE_1"
    var maxAge = 50;
    var minAge = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView1.delegate = self
        pickerView1.dataSource = self
        myswitch.addTarget(self, action: #selector(AddNotificationViewController.switchIsChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        switchInfo.text = "Male"
        
        sliderValueLabel1.text = "50"
        sliderValueLabel2.text = "0"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sliderValue1Changed(sender: UISlider) {
        let currentValue = Int(sender.value)
        sliderValueLabel1.text = "\(currentValue)"
        maxAge = currentValue
    }
    
    
    @IBAction func sliderValue2Changed(sender: UISlider) {
        let currentValue = Int(sender.value)
        sliderValueLabel2.text = "\(currentValue)"
        minAge = currentValue
    }
   
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return diabetesType.count
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return diabetesType[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedDiabeteType = diabetesType[row]
        
    }
    
    func switchIsChanged(mySwitch: UISwitch) {
        if mySwitch.on {
            switchInfo.text = "Male"
        } else {
            switchInfo.text = "Female"
        }
    }
    
    
    @IBAction func registerNotification(sender: AnyObject) {
        if(maxAge <= minAge){
            let warning: UIAlertView = UIAlertView(title: "Age Range", message: "The maximum age cannot be smaller than minimnm age", delegate: self, cancelButtonTitle: "Ok")
            warning.show()
        }else{
            let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            let userInfo = userDefaults.objectForKey("UserInfo") as? NSDictionary
            if(userInfo == nil){
                let message:UIAlertView = UIAlertView(title: "", message: "Please Log in First", delegate: self,cancelButtonTitle: "OK")
                message.show()
            }else{
                var parameters = [String:AnyObject]()
                let userid:String = (userInfo!.objectForKey("userid")! as? String)!
                parameters["userid"] = userid
                parameters["command"] = "add"
                parameters["deviceToken"] = AppDelegate.deviceToken
                parameters["minAge"] = minAge
                parameters["maxAge"] = maxAge
                parameters["gender"] = switchInfo.text!
                parameters["interestedId"] = ""
                parameters["diabetesType"] = selectedDiabeteType
                
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
        }
        
    } 
    
    func itemsDownloadedString(items: String) {
        let reply = items
        if(reply == "ok"){
            //print("Notification added")
            SVProgressHUD.showSuccessWithStatus("Notification added")
            self.navigationController!.popViewControllerAnimated(true)
        }else{
            let message:UIAlertView = UIAlertView(title: "Fail", message: "Unable to add notification", delegate: self,cancelButtonTitle: "OK")
            message.show()
        }
    }
    
}
