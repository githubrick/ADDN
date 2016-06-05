//
//  FirstViewController.swift
//  ADDN
//
//  Created by Jiajie Li on 22/03/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//

// This is the class is the first tab of the tab bar controller, it is the first view after
// the application lanuch. It is a flat table that allowing user to choose one of its cell to 
// generate centre summary report. It provides the load button to load the centre summary report data.
// It also provides a button to segue to the login view.

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD


class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var LoginButton: UIBarButtonItem!
    
    let list:[(identifier: String, content: String, name: String, image: String)] = [("NSW","NSW_SYD_CHW","Children's Hospital at Westmead","h1.tiff"), ("QBL", "QLD_BNE_LCH","Lady Cilento Children's Hospital","h2.tiff"),("SAW","SA_ADL_WCH","Women and Children's Hosptial","h3.tiff"),("VMR","VIC_MEL_RCH","Royal Children's Hosptial","h4.tiff"),("WPP","WA_PER_PMH","Princess Margaret Hospital","h5.tiff"),("AllCentre","All Centres","All the hospitals","h6.tiff")]
    
    var data: NSMutableDictionary = NSMutableDictionary()
    //var homeModel = HomeModel()
    var userInfo: NSDictionary!
    var count = 0;
    var selectedRow = -1
    var cellHeight = CGFloat(60)
    var imageHeight = CGFloat(40)
    var imageWidth = CGFloat(40)
    
    
    var dataDic:Dictionary<String,AnyObject> = Dictionary()
    var region : String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
       // homeModel.delegate = self

        self.tableView.tableFooterView = UIView()
       
  
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
    }

    
    // MARK: Get data from server.
    @IBAction func loadData(sender: AnyObject) {
//        count = 0
//        let queryGenerator = QueryGenerator()
//        let queries = queryGenerator.generateQueriesForCentreSummary() as NSMutableArray
//        for i in 0 ..< 6{
//            
//            homeModel.downloadItems(queries.objectAtIndex(i) as! String,info: String(i))
//        }
        
        var parameters = [String:String]()
        if let myRegion = NSUserDefaults.standardUserDefaults().dictionaryForKey("UserInfo")?["region"] as? String {
            parameters["centreId"] = myRegion
            self.region = myRegion
        }
        HttpRequestManager.sharedManager.PostHttpRequest(CentreSummaryAPI, parameters: parameters) { (response) in
            if let value = response.result.value {
                let jsonArr = JSON(value).array
                 self.data.setObject(jsonArr![0].dictionaryObject!, forKey: self.region)
                let warning: UIAlertView = UIAlertView(title: "Success", message: "Data Acquired Success", delegate: nil, cancelButtonTitle: "Ok")
                warning.show()
                SVProgressHUD.showSuccessWithStatus("Data Acquired Success")
                //print(self.dataDic)
            }

        }
        
    }
    
    
    // MARK: HomeModel Delegate
//    func  itemsDownloaded(items: NSMutableArray, info: String){
//        data.setObject(items.objectAtIndex(0) as! NSDictionary, forKey: info)
//        count = count + 1
//        if(count == 6){
//            let message:UIAlertView = UIAlertView(title: "Data Acquired", message: "Success", delegate: self,cancelButtonTitle: "OK")
//            message.show()
//        }
//    }
    
    override func viewWillAppear(animated: Bool){
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userInfo = userDefaults.objectForKey("UserInfo") as? NSDictionary
        if(userInfo != nil){
            let name = userInfo.objectForKey("user_name") as! String
            LoginButton.title = name
        }else{
            LoginButton.title = "Log in"
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

       return 6
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return cellHeight
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kCellIdentifier = list[indexPath.row].identifier
        let content = list[indexPath.row].content
        let name = list[indexPath.row].name
        let image = UIImage(named: list[indexPath.row].image)
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell!
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: kCellIdentifier)
        }
        
        

        if(cell.viewWithTag(1) == nil || cell.viewWithTag(2) == nil || cell.viewWithTag(3) == nil){
            
            let oneLabel:UILabel = UILabel(frame: CGRectMake(60, 0, cell.frame.size.width - cell.imageView!.frame.width, cellHeight / 2 ))
            oneLabel.font = UIFont(name: cell.textLabel!.font.fontName, size: 18)
            oneLabel.textAlignment = NSTextAlignment.Left
            oneLabel.text = content
            oneLabel.tag = 1
            cell!.contentView.addSubview(oneLabel)
            
            let twoLabel:UILabel = UILabel(frame: CGRectMake(60, cellHeight / 2, cell.frame.size.width - cell.imageView!.frame.width, cellHeight / 2))
            twoLabel.font = UIFont(name: cell.textLabel!.font.fontName, size: 14)
            twoLabel.textAlignment = NSTextAlignment.Left
            twoLabel.text = name
            twoLabel.textColor = UIColor.grayColor()
            twoLabel.tag = 2
            cell!.contentView.addSubview(twoLabel)
            
            let imageview: UIImageView = UIImageView(frame: CGRectMake(10, 10, imageWidth, imageHeight))
            imageview.image = image
            cell!.contentView.addSubview(imageview)
            
        }else{
            let label1:UILabel = cell.viewWithTag(1) as! UILabel
            label1.text = content
            let label2:UILabel = cell.viewWithTag(2) as! UILabel
            label2.text = name
            let imageview:UIImageView = cell.viewWithTag(3) as! UIImageView
            imageview.image = image
        }
        

        
        return cell
        

       
    } 

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if (identifier == "showDetail"){
            //if(count < 6){
            if (self.data.count == 0){
                let message:UIAlertView = UIAlertView(title: "Note", message: "Data haven't been loaded or you haven't LogIn", delegate: self,cancelButtonTitle: "OK")
                message.show()
                return false
            }else{
                let dic:[String: String] = ["NSW":"NSW_SYD_CHW", "QBL": "QLD_BNE_LCH","SAW":"SA_ADL_WCH","VMR":"VIC_MEL_RCH","WPP":"WA_PER_PMH","AllCentre":"All"]
                
                let selectedIndex = self.tableView.indexPathForSelectedRow?.row
                let selectedCentre = dic[list[selectedIndex!].identifier]
                if(Authority.check(selectedCentre!)){
                    return true
                }else{
                    let message:UIAlertView = UIAlertView(title: "No Authority", message: "You do not have permission to access this data", delegate: self,cancelButtonTitle: "OK")
                    message.show()
                    return false
                }
            } 
        }
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "showDetail"){
            let selectedIndexPath:NSIndexPath = self.tableView.indexPathForSelectedRow!
           
            let centreSummary: CentreSummary = segue.destinationViewController as! CentreSummary
           
            //let values:NSDictionary = data.objectForKey(String(selectedIndexPath.row)) as! NSDictionary
            
            let selectedIndex = self.tableView.indexPathForSelectedRow?.row
            let selectedCentre = list[selectedIndex!].content
            let values:NSDictionary = data.objectForKey(selectedCentre) as! NSDictionary
            
            centreSummary.activeNumValue = values.objectForKey("Active") as! String
            centreSummary.type1NumValue = values.objectForKey("Type 1") as! String
            centreSummary.type2NumValue = values.objectForKey("Type 2") as! String
            centreSummary.otherTypeNumValue = values.objectForKey("Other") as! String
            centreSummary.inactiveNumValue = values.objectForKey("Inactive") as! String
            centreSummary.dateValue = values.objectForKey("LastUpdate") as! String
            centreSummary.totalNumValue = values.objectForKey("Total") as! String
            centreSummary.centreNamevalue = list[selectedIndexPath.row].content
            
        }
        
    }
    
}

