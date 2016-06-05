//
//  MyNotificationTableViewController.swift
//  ADDN
//
//  Created by Jiajie Li on 14/04/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//


// This is a class used to display how many notification preferences that the 
// user sets, it is a table view, and it will segue to NoficaitionDetailViewController.swift
// when the user press one of the cell of the table. It also provides a new button that can generate
// a new notification preferences. After pressing the new button, it will segue to 
// AddNotificationViewController

import UIKit
import SVProgressHUD
import SwiftyJSON

class MyNotificationTableViewController: UITableViewController{

    
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    var data:NSMutableArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userInfo = userDefaults.objectForKey("UserInfo") as? NSDictionary
        if(userInfo == nil){
            let refreshAlert = UIAlertController(title: "", message: "Please Log in First.", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                self.tabBarController?.selectedIndex = 0
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }else{
            indicator.startAnimating()
            let userid:String = (userInfo!.objectForKey("userid")! as? String)!
            
            var parameters = [String:AnyObject]()
            parameters["userid"] = userid
            parameters["command"] = "view"
            
            // the parameters below is not needed for 'view' command
            parameters["deviceToken"] = AppDelegate.deviceToken
            parameters["minAge"] = ""
            parameters["maxAge"] = ""
            parameters["gender"] = ""
            parameters["interestedId"] = ""
            parameters["diabetesType"] = ""
            
            HttpRequestManager.sharedManager.PostHttpRequest(NotificationAPI, parameters: parameters) { (response) in
                if let value = response.result.value {
                    //let jsonArr = JSON(value).array
                    if let jsonDic = JSON(value).dictionaryObject{
                        self.itemsDownloaded(jsonDic, info:"view")
                        SVProgressHUD.showSuccessWithStatus("Data acquired Success")

                   }
                    
                }
                
            }

        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return data.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        
        let dic = data.objectAtIndex(indexPath.row) as! NSDictionary
        let msg = (dic.objectForKey("interestedId") as! String)
        if(msg == "No Notification added yet"){
            cell.textLabel!.text = msg
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }else{
            cell.textLabel!.text = "NotifiationID " + msg
        }
        return cell
    }

    func  itemsDownloaded(items:Dictionary<String,AnyObject>, info: String){
        indicator.stopAnimating()
        //data.removeAllObjects()
        let tempArr : Array<AnyObject> = items["msg"] as! Array<AnyObject>
        let count =  ((tempArr[0] as! NSMutableArray)[0] as! NSDictionary).objectForKey("NumberOfInterest") as! String
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if( count == "0"){
            userDefaults.removeObjectForKey("userInterested")
            let adic:[String:String] = ["interestedId":"No Notification added yet"]
            data = [adic]
        }else{
            data = tempArr[1] as! NSMutableArray
            userDefaults.removeObjectForKey("userInterested")
            userDefaults.setObject(data, forKey: "userInterested")
        }
        tableView.reloadData()

    }

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if (identifier == "detailNotification"){
            let dic = data.objectAtIndex(0) as! NSDictionary
            let msg = (dic.objectForKey("interestedId") as! String)
            if(msg == "No Notification added yet"){
                return false
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if (segue.identifier == "detailNotification"){
            let selectedIndexPath:NSIndexPath = self.tableView.indexPathForSelectedRow!
            let notificationDetailViewController: NotificationDetailViewController = segue.destinationViewController as! NotificationDetailViewController
            let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            let array = userDefaults.objectForKey("userInterested") as! NSMutableArray
            
            let dic = array[selectedIndexPath.row] as! NSDictionary
            
            let gender = dic.objectForKey("gender") as! String
            let ageMax = dic.objectForKey("ageMax") as! String
            let ageMin = dic.objectForKey("ageMin") as! String
            let diabetesType = dic.objectForKey("diabetesType") as! String
            let interestedId = dic.objectForKey("interestedId") as! String
            notificationDetailViewController.gender = gender
            notificationDetailViewController.maxAge = ageMax
            notificationDetailViewController.minAge = ageMin
            notificationDetailViewController.diabetesType = diabetesType
            notificationDetailViewController.interestedId = interestedId
        }
    }
}
