//
//  InsulinRegimenReport.swift
//  ADDN
//
//  Created by Jiajie Li on 25/03/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//

// This class is used to display the view of the parameters that used to
// generate the Insulin Regimen report. It is a table view. And it
// record what parameters the used selects, and prepare to segue to detail
// reesult display view.

import UIKit
import SVProgressHUD
import SwiftyJSON

class InsulinRegimenReport: UITableViewController{

    
    let list:[(identifier: String, content: String)] = [("centre","Centre"), ("IPNCFFR", "Include Patients not Consented for future research"),("diabetesTypes","Diabetes type"),("CAR","Current Age Ranges(years)"),("diabetesDuration","Diabetes Duration(years)")]
    
    var centre:Int?
    var IPNCFFR:String?
    var CAR: NSMutableArray?
    var diabetesType: String?
    var diabetesDuration: NSMutableArray?
    //var homeModel = HomeModel()
    var count = 0
     
    let columnsOfTable = ["Total","CSII", "BD_TWICE_DAILY", "MDI", "OTHER","NULL"]
    var rowsOfTable: Array<(key:String, array:Array<String>)>!
    var answer = Dictionary<String, Array<(key:String, array: Array<String>)>>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewDidAppear(true)
        setOptionsToDefault() 
        self.tableView.tableFooterView = UIView()
       // homeModel.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InsulinRegimenReport.startSegue), name: "InsulinReadyToSegue", object: self)

    }

    override  func viewDidAppear(animated: Bool) {
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
        [("Number", ["Number"]),
            ("Sex",["Male", "Female"]),
            ("Current Age(years)",CARRowsInReport),
            ("Duration of Diabetes(years)",diabetesDurationRowsInReport),
            ("Mean Insulin Dose(units/kg)",["Mean Insulin Dose"]),
            ("Mean Basal Dose(units/kg)",["Mean Basal Dose"]),
            ("Coeliac",["Coeliac"])]
        
        //let queryGenerator = QueryGenerator()
        //var query = ""
       // var ahomeModel = HomeModel()
        for regimenType in columnsOfTable{
            //query = queryGenerator.queryGeneratorForInsulinRegimenReport(centre!, IPNCFFR: IPNCFFR!, CAR: CAR!, DD: diabetesDuration!, diabetesType: diabetesType!, column: i)
            //homeModel.downloadItems(query,info: i)
            //print(query)
            var parameters = [String:AnyObject]()
            if let myRegion = NSUserDefaults.standardUserDefaults().dictionaryForKey("UserInfo")?["region"] as? String {
                parameters["centreId"] = myRegion
                parameters["consenttobecontacted"] = self.IPNCFFR!
                parameters["diabetesType"] = diabetesType!
                parameters["regimenType"] = regimenType
                parameters["duration"] = self.diabetesDuration!
                parameters["ageRange"] = self.CAR!
                //self.region = myRegion
            }
            HttpRequestManager.sharedManager.PostHttpRequest(QueryCentreInsulinRegimenReportAPI, parameters: parameters) { (response) in
                if let value = response.result.value {
                    let jsonArr = JSON(value).array
                    let dic = jsonArr![0].dictionaryObject!
                    self.itemsDownloaded(dic, info: regimenType)
                    // self.data.setObject(jsonArr![0].dictionaryObject!, forKey: self.region)
                    SVProgressHUD.showSuccessWithStatus("Data Acquired Success")
                    //print(self.dataDic)
                }
            }
        }
        
    }
    
    
    func startSegue(){
        self.performSegueWithIdentifier("displayReportDetail",sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "displayReportDetail"){
            let doneViewController = segue.destinationViewController as! DoneViewController
            doneViewController.rowsOfTable = rowsOfTable
            doneViewController.columnsOfTable = columnsOfTable
            doneViewController.answers = self.answer
        }
        
    }
    
    func  itemsDownloaded(items: Dictionary<String,AnyObject>, info: String){
        //let result: NSDictionary = items.objectAtIndex(0) as! NSDictionary
        let key = info
        var arrayofTuple = pairing(items)
        if(key != "Total"){
           arrayofTuple = percentageliszation(arrayofTuple)
        }
            self.answer[key] = arrayofTuple
        count += 1
        if(count == 6){
            SVProgressHUD.dismiss()
            NSNotificationCenter.defaultCenter().postNotificationName("InsulinReadyToSegue", object: self)
            count = 0
        }
    }
    
    func pairing(dic:NSDictionary)->Array<(key:String, array:Array<String>)>{
        let number =  dic["Number"] as! String
        let male = dic["Male"] as! String
        let female = dic["Female"] as! String
        let mid = (dic["MID"] is NSNull) ? "-" : (dic["MID"] as! String)
        let mbd = (dic["MBD"] is NSNull) ? "-" : (dic["MBD"] as! String)
        let coeliac = dic["Coeliac"] as! String
        
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
            carA[i] = dic[keyforcar] as! String
        }
        for i in 0 ..< ddlength{
            let keyfordd = "DD" + "\(i + 1)"
            ddA[i] = dic[keyfordd] as! String
        }
        
        
        let rowsOfTable:Array<(key:String, array:Array<String>)> =
        [("Number", [number]),
            ("Sex",[male, female]),
            ("Current Age(years)",carA),
            ("Duration of Diabetes(years)",ddA),
            ("Mean Insulin Dose(units/kg)",[mid]),
            ("Mean Basal Dose(units/kg)",[mbd]),
            ("Coeliac",[coeliac])]
        
        return rowsOfTable
    }
    
    
    func percentageliszation(arrayOfTuple: Array<(key:String, array:Array<String>)>) -> Array<(key:String, array:Array<String>)>{
        var newArrayOfTuple = arrayOfTuple
        let div:Float = (newArrayOfTuple[0].array[0] as NSString).floatValue
        if(Int(div) != 0){ 
            for i in 0 ..< newArrayOfTuple[1].array.count{
                newArrayOfTuple[1].array[i] = "\(Int(((newArrayOfTuple[1].array[i] as NSString).floatValue / div * 100)))" + "%"
            }
            for i in 0 ..< newArrayOfTuple[2].array.count{
                newArrayOfTuple[2].array[i] = "\(Int(((newArrayOfTuple[2].array[i] as NSString).floatValue / div * 100)))" + "%"
            }
            for i in 0 ..< newArrayOfTuple[3].array.count{
                newArrayOfTuple[3].array[i] = "\(Int(((newArrayOfTuple[3].array[i] as NSString).floatValue / div * 100)))" + "%"
            }
            
        }
        return newArrayOfTuple
    }
    
}
