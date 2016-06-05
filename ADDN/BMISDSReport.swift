//
//  BMISDSReport.swift
//  ADDN
//
//  Created by Jiajie Li on 25/03/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//

// This class is used to display the view of the parameters that used to
// generate the BMI SDS report. It is a table view. And it
// record what parameters the used selects, and prepare to segue to detail
// reesult display view.

import UIKit
import SwiftyJSON
import SVProgressHUD

class BMISDSReport: UITableViewController{

    let list:[(identifier: String, content: String)] = [("centre","Centre"), ("IPNCFFR", "Include Patients not Consented for future research"),("diabetesTypes","Diabetes type"),("CAR","Current Age Ranges(years)"),("diabetesDuration","Diabetes Duration(years)")]
    
    var centre:Int?
    var IPNCFFR:String?
    var CAR: NSMutableArray?
    var diabetesType: String?
    var diabetesDuration: NSMutableArray?
    //var homeModel = HomeModel()
    var count = 0
    
    let columnsOfTable = ["Number","Mean BMI SDS"]
    var rowsOfTable: Array<(key:String, array:Array<String>)>!
    var answer = Dictionary<String, Array<(key:String, array: Array<String>)>>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewDidAppear(true)
        setOptionsToDefault()
        self.tableView.tableFooterView = UIView()
       // homeModel.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BMISDSReport.startSegue), name: "BMIReadyToSegue", object: self)
    }

    override func viewDidAppear(animated: Bool) {
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        centre = userDefaults.objectForKey("centre") as? Int
        IPNCFFR = userDefaults.objectForKey("IPNCFFR") as? String
        CAR = userDefaults.objectForKey("CAR") as? NSMutableArray
        diabetesType = userDefaults.objectForKey("diabetesType") as? String
        diabetesDuration = userDefaults.objectForKey("diabetesDuration") as? NSMutableArray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 5
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let kCellIdentifier = list[indexPath.row].identifier
            let content = list[indexPath.row].content
            var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell!
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: kCellIdentifier)
            }
            cell.textLabel!.text = content
            return cell
    }
    
    
    
    func setOptionsToDefault(){
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        /* If this is the first time enter this view centre value should be the  default value
        And userdefaults still dont have the key centre
        */
        if(centre == nil){
            userDefaults.removeObjectForKey("centre")
            let centreValue = 6
            userDefaults.setObject(centreValue,forKey:"centre")
            
            self.centre = centreValue
        }
        if(IPNCFFR == nil){
            userDefaults.removeObjectForKey("IPNCFFR")
            let IPNCFFRValue = "1"
            userDefaults.setObject(IPNCFFRValue, forKey: "IPNCFFR")
            self.IPNCFFR = IPNCFFRValue
        }
        if(CAR == nil){
            let textFieldFront = "0.0"
            let textFiledBack = "5.0"
            userDefaults.removeObjectForKey("CAR")
            let CARValue = NSMutableArray()
            CARValue.addObject(textFieldFront)
            CARValue.addObject(textFiledBack)
            userDefaults.setObject(CARValue,forKey:"CAR")
            self.CAR = CARValue
        }
        if(diabetesType == nil){
            userDefaults.removeObjectForKey("diabetesType")
            let diabetesTypeValue = "TYPE_1"
            userDefaults.setObject(diabetesTypeValue, forKey: "diabetesType")
            self.diabetesType = diabetesTypeValue
        }
        if(diabetesDuration == nil){
            let textFieldFront = "0.0"
            let textFiledBack = "1.0"
            userDefaults.removeObjectForKey("diabetesDuration")
            let diabetesDurationValue = NSMutableArray()
            diabetesDurationValue.addObject(textFieldFront)
            diabetesDurationValue.addObject(textFiledBack)
            userDefaults.setObject(diabetesDurationValue,forKey:"diabetesDuration")
            self.diabetesDuration = diabetesDurationValue
        }
        userDefaults.synchronize()
    } 

    
    func startSegue(){
        self.performSegueWithIdentifier("displayReportDetail",sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "displayReportDetail"){
            let doneViewController = segue.destinationViewController as! DoneViewController
            doneViewController.rowsOfTable = rowsOfTable
            doneViewController.columnsOfTable = columnsOfTable
            doneViewController.answers = self.answer
            
        }
        
    }
    
    func  newItemsDownloaded(items:  Dictionary<String,AnyObject>, info: String){
        //let result: NSDictionary = items.objectAtIndex(0) as! NSDictionary
        let key = info
        
        let arrayofTuple = pairing(items)
        self.answer[key] = arrayofTuple
        count += 1
        if(count == 2){
            NSNotificationCenter.defaultCenter().postNotificationName("BMIReadyToSegue", object: self)
            count = 0
        }
    }

    
    @IBAction func getData(sender: AnyObject) {
        
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userInfo = userDefaults.objectForKey("UserInfo") as? NSDictionary
        if(userInfo == nil){
            let refreshAlert = UIAlertController(title: "", message: "You haven't login", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                self.tabBarController?.selectedIndex = 0
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
        
        let dic:[Int: String] = [1:"NSW_SYD_CHW", 2: "QLD_BNE_LCH",3:"SA_ADL_WCH",4:"VIC_MEL_RCH",5:"WA_PER_PMH",6:"All"]
        
        if(!Authority.check(dic[centre!]!)){
            let message:UIAlertView = UIAlertView(title: "No Authority", message: "You are not allow to see the data in centre: " + dic[centre!]!, delegate: self,cancelButtonTitle: "OK")
            message.show()
            return
        }
        
        var CARRowsInReport = [String](count:CAR!.count / 2, repeatedValue: "")
        var diabetesDurationRowsInReport = [String](count:diabetesDuration!.count / 2, repeatedValue: "")
        
        for i in 0 ..< CAR!.count / 2 {
            CARRowsInReport[i] = ">=" + (CAR!.objectAtIndex(2 * i) as! String) + " and < " + (CAR!.objectAtIndex(2 * i + 1) as! String)
        }
        for i in 0 ..< diabetesDuration!.count / 2 {
            diabetesDurationRowsInReport[i] = ">=" + (diabetesDuration!.objectAtIndex(2 * i) as! String) + " and < " + (diabetesDuration!.objectAtIndex(2 * i + 1) as! String)
        }
        rowsOfTable =
            [("Total", ["Total"]),
                ("Sex",["Male", "Female"]),
                ("Current Age(years)",CARRowsInReport),
                ("Insulin Regimen",["CSII","BD/Twice Daily","MDI","Other","Nil"]),
                ("Duration of Diabetes(years)",diabetesDurationRowsInReport)]
//        let queryGenerator = QueryGenerator()
//        var query = ""
//        //var ahomeModel = HomeModel()
//        query = queryGenerator.queryGeneratorForBMISDSReport(centre!, IPNCFFR: IPNCFFR!, CAR: CAR!, DD: diabetesDuration!, diabetesType: diabetesType!, column: "Number",value: "1", option: "COUNT")
//        homeModel.downloadItems(query,info: "Number")
//        query = queryGenerator.queryGeneratorForBMISDSReport(centre!, IPNCFFR: IPNCFFR!, CAR: CAR!, DD: diabetesDuration!, diabetesType: diabetesType!, column: "Mean BMI SDS",value: "bmi_sds", option: "AVG")
        
        
        var parameters = [String:AnyObject]()
        if let myRegion = NSUserDefaults.standardUserDefaults().dictionaryForKey("UserInfo")?["region"] as? String {
            parameters["centreId"] = myRegion
            parameters["consenttobecontacted"] = self.IPNCFFR!
            parameters["diabetesType"] = diabetesType!
            parameters["duration"] = self.diabetesDuration!
            parameters["ageRange"] = self.CAR!
            parameters["method"] = "AVG"
            //self.region = myRegion
        }
        // request for avg
        HttpRequestManager.sharedManager.PostHttpRequest(QueryCentreBmiSdsReportAPI, parameters: parameters) { (response) in
            if let value = response.result.value {
                let jsonArr = JSON(value).array
                let dic = jsonArr![0].dictionaryObject!
                self.newItemsDownloaded(dic, info: "Mean BMI SDS")
                // self.data.setObject(jsonArr![0].dictionaryObject!, forKey: self.region)
                SVProgressHUD.showSuccessWithStatus("Data Acquired Success")
                //print(self.dataDic)
            }
        }
        
        // request for count
        parameters["method"] = "COUNT"
        HttpRequestManager.sharedManager.PostHttpRequest(QueryCentreBmiSdsReportAPI, parameters: parameters) { (response) in
            if let value = response.result.value {
                let jsonArr = JSON(value).array
                let dic = jsonArr![0].dictionaryObject!
                self.newItemsDownloaded(dic, info: "Number")
                // self.data.setObject(jsonArr![0].dictionaryObject!, forKey: self.region)
                SVProgressHUD.showSuccessWithStatus("Data Acquired Success")
                //print(self.dataDic)
            }
        }
        
        //print(query)
        //homeModel.downloadItems(query,info: "Mean BMI SDS")
        
    }
    
        
    func pairing(dic:NSDictionary)->Array<(key:String, array:Array<String>)>{
        
        //var mid = (dic["MID"] is NSNull) ? "-" : (dic["MID"] as String)
        
        let number =  dic["Total"] is NSNull ? "-" : dic["Total"] as! String
        let male =  dic["Male"] is NSNull ? "-" : dic["Male"] as! String
        let female = dic["Female"] is NSNull ? "-" : dic["Female"] as! String
        
        let CSII = dic["CSII"] is NSNull ? "-" : dic["CSII"] as! String
        let BD = dic["BD"] is NSNull ? "-" : dic["BD"] as! String
        let MDI = dic["MDI"] is NSNull ? "-" : dic["MDI"] as! String
        let Other = dic["Other"] is NSNull ? "-" : dic["Other"] as! String
        let Nil = dic["Nil"] is NSNull ? "-" : dic["Nil"] as! String
        
        var carlength = 0;
        while(dic["CAR" + "\(carlength + 1)"] != nil){
            carlength = carlength + 1
        }
        var ddlength = 0; 
        while(dic["DD" + "\(ddlength + 1)"] != nil){
            ddlength = ddlength + 1
        }
        var carA = [String](count:carlength, repeatedValue:"")
        var ddA = [String](count:ddlength, repeatedValue:"")
        for i in 0 ..< carlength{
            let keyforcar = "CAR" + "\(i + 1)"
            carA[i] = dic[keyforcar] is NSNull ? "-" : dic[keyforcar] as! String
        }
        for i in 0 ..< ddlength{
            let keyfordd = "DD" + "\(i + 1)"
            ddA[i] = dic[keyfordd] is NSNull ? "-" : dic[keyfordd] as! String
        }
        
        let rowsOfTable:Array<(key:String, array:Array<String>)> =
            [("Total", [number]),
                ("Sex",[male, female]),
                ("Current Age(years)",carA),
                ("Insulin Regimen",[CSII,BD,MDI,Other,Nil]),
                ("Duration of Diabetes(years)",ddA)]
        
        return rowsOfTable
    }
        
        
}
