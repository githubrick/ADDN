//
//  DiseaseTypeReportTableViewController.swift
//  ADDN
//
//  Created by Jiajie Li on 24/03/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//

// This class is used to display the view of the parameters that used to
// generate the disease type report. It is a table view. And it
// record what parameters the used selects, and prepare to segue to detail
// reesult display view.

import UIKit
import SwiftyJSON
import SVProgressHUD

class DiseaseTypeReportTableViewController: UITableViewController{
    
    let list:[(identifier: String, content: String)] = [("centre","Centre"), ("IPNCFFR", "Include Patients not Consented for future research"),("CAR","Current Age Ranges(years)")]
    
    var centre:Int?
    var IPNCFFR:String?
    var CAR: NSMutableArray?
    var count = 0
    //var homeModel = HomeModel()
    //region
    var region : String = String()
    
    var rowsOfTable: Array<(key:String, array:Array<String>)>!
    let columnsOfTable = ["Total","TYPE_1", "TYPE_2", "MONOGENIC", "CFRD", "NEONATAL", "OTHER"]
    var answer = Dictionary<String, Array<(key:String, array: Array<String>)>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewDidAppear(true)
        setOptionsToDefault()
        self.tableView.tableFooterView = UIView()
        //homeModel.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DiseaseTypeReportTableViewController.startSegue), name: "DiseaseReadyToSegue", object: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override  func viewDidAppear(animated: Bool) {
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        centre = userDefaults.objectForKey("centre") as? Int
        IPNCFFR = userDefaults.objectForKey("IPNCFFR") as? String
        CAR = userDefaults.objectForKey("CAR") as? NSMutableArray
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
        return 3
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let kCellIdentifier = list[indexPath.row].identifier
        let content = list[indexPath.row].content
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell!
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: kCellIdentifier)
        }
        cell.textLabel!.text = content
        // 自我理解写出来的 userdafault
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
            let message:UIAlertView = UIAlertView(title: "No Authority", message: "You do not have permission to access this data in centre " + dic[centre!]!, delegate: self,cancelButtonTitle: "OK")
            message.show()
            return
        }
        
        var CARRowsInReport = [String](count:CAR!.count / 2, repeatedValue: "")
        
        
        for i in 0 ..< CAR!.count / 2 {
            CARRowsInReport[i] = ">=" + (CAR!.objectAtIndex(i * 2) as! String) + " and < " + (CAR!.objectAtIndex(i * 2 + 1) as! String)
        }
        
        
        rowsOfTable =
            [("Number", ["Number"]),
             ("Sex",["Male", "Female"]),
             ("Current Age(years)",CARRowsInReport),
             ("Insulin Regimen",["CSII","BD/Twice Daily","MDI","Other","Nil"]),
             ("Other Medication",["Thyroid hormone"]),
             ("Comorbidities",["Coeliac","Thyroid"]),
             ("Median HbA1c(12m)",["NGSP(%)","IFFC(mmol/mol)"]),
             ("Median BMI SDS",["Median BMI SDS"]),
             ("Severe Hypos/100 Patient Years",["Severe Hypos"]),
             ("DKA Episode/100 Patient Years",["DKA Episode"])]
        
        
        //let queryGenerator = QueryGenerator()
        //var query = ""
        //var ahomeModel = HomeModel()
        for diabetesType in columnsOfTable{
            //            query = queryGenerator.queryGeneratorForDiseaseTypeReport(centre!, IPNCFFR: IPNCFFR!, CAR: CAR!,type: diabetesType)
            //homeModel.downloadItems(query,info: i)
            
            var parameters = [String:String]()
            if let myRegion = NSUserDefaults.standardUserDefaults().dictionaryForKey("UserInfo")?["region"] as? String {
                parameters["centreId"] = myRegion
                parameters["consenttobecontacted"] = self.IPNCFFR!
                parameters["type"] = diabetesType
                //self.region = myRegion
            }
            HttpRequestManager.sharedManager.PostHttpRequest(QueryCentreDiseaseTypeReportAPI, parameters: parameters) { (response) in
                if let value = response.result.value {
                    let jsonArr = JSON(value).array
                    let dic = jsonArr![0].dictionaryObject!
                    self.itemsDownloaded(dic, info: diabetesType)
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
        let arrayofTuple = pairing(items)
        self.answer[key] = arrayofTuple
        count += 1
        //print("count into downloads "+String(count))
        SVProgressHUD.showWithStatus("Loading....")
        //print(self.answer)
        if(count == 7){
            SVProgressHUD.dismiss()
            NSNotificationCenter.defaultCenter().postNotificationName("DiseaseReadyToSegue", object: self)
            count = 0
        }
    }
    
    func pairing(dic:NSDictionary)->Array<(key:String, array:Array<String>)>{
        
        
        let number =  NSString(string: dic["Number"] as! String).floatValue
        let male = castToPercentage(dic["Male"] as! String,number)
        let female = castToPercentage(dic["Female"] as! String,number)
        let CSII = castToPercentage(dic["CSII"] as! String,number)
        let BD = castToPercentage(dic["BD"] as! String,number)
        let MDI = castToPercentage(dic["MDI"] as! String,number)
        let Other = castToPercentage(dic["Other"] as! String,number)
        let Nil = castToPercentage(dic["Nil"] as! String,number)
        let metformin = castToPercentage(dic["Metformin"] as! String,number)
        let sulphonylureas = castToPercentage(dic["Sulphonylureas"] as! String,number)
        let coeliac = castToPercentage(dic["Coeliac"] as! String,number)
        let thyroid = castToPercentage(dic["Thyroid"] as! String,number)
        let ngsp = (dic["NGSP"] is NSNull) ? "-" : (dic["NGSP"] as! String)
        let iffc = (dic["IFFC"] is NSNull) ? "-" : (dic["IFFC"] as! String)
        let bmi = (dic["BMI"] is NSNull) ? "-" : (dic["BMI"] as! String)
        let hypos = (dic["HYPOS"] is NSNull) ? "-" : (dic["HYPOS"] as! String)
        let dka = (dic["DKA"] is NSNull) ? "-" : (dic["DKA"] as! String)
        //let carlength = dic.count - 17
        // MODIFIED -----
        let ageRangCount = CAR!.count / 2
        var carA = [String](count:ageRangCount, repeatedValue:"")
        print ("age range count "+String(ageRangCount))
        for i in 0 ..< ageRangCount{
            let keyforcar = "CAR" + "\(i + 1)"
            carA[i] = castToPercentage(dic[keyforcar] as! String,number)
        }
        
        let rowsOfTable: Array<(key:String, array:Array<String>)> =
            [("Number", ["\(Int(number))"]),
             ("Sex",[male, female]),
             ("Current Age(years)",carA),
             ("Insulin Regimen",[CSII,BD,MDI,Other,Nil]),
             ("Other Medication",[sulphonylureas]),
             ("Comorbidities",[coeliac,thyroid]),
             ("Median HbA1c(12m)",[ngsp,iffc]),
             ("Median BMI SDS",[bmi]),
             ("Severe Hypos/100 Patient Years",[hypos]),
             ("DKA Episode/100 Patient Years",[dka])]
        return rowsOfTable
    }
    
    func castToPercentage(number:String, _ divNumber: Float)->String{
        if(Int(divNumber) != 0){
            var floatValue:Float = NSString(string: number).floatValue
            floatValue = (floatValue / divNumber * 100)
            let intValue = Int(floatValue)
            return "\(intValue)" + "%"
        }else{
            return "-"
        }
    }
    
}
