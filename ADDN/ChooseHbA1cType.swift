//
//  ChooseHbA1cType.swift
//  ADDN
//
//  Created by Jiajie Li on 25/03/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//

// This class provides the UI view for users to select the Hba1c Type(either NGSP or IFFC) parameters. 

import UIKit

class ChooseHbA1cType: UITableViewController {

    let list:[(identifier: String, content: String)] = [("NGSP","NGSP(%)"), ("IFFC", "IFFC(MMOL/MOL)")]
    var selectedRow = -1
    
    var hba1cType: String?
    var NGSP: NSMutableArray?
    var IFFC: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        NGSP = userDefaults.objectForKey("NGSP") as? NSMutableArray
        IFFC = userDefaults.objectForKey("IFFC") as? NSMutableArray
        loadAllLists(hba1cType, NGSP: NGSP, IFFC: IFFC)
        self.tableView.tableFooterView = UIView()
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
        return 2
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        selectedRow = indexPath.row
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("hba1cType")
        userDefaults.setObject(list[selectedRow].content, forKey: "hba1cType")
        self.tableView.reloadData()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kCellIdentifier = list[indexPath.row].identifier
        let content = list[indexPath.row].content
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell!
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: kCellIdentifier)
        }
        cell.textLabel!.text = content
        //cell.accessoryType= UITableViewCellAccessoryCheckmark
        
        if( selectedRow == indexPath.row){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }

 
    
    func loadAllLists(hba1cType: String?, NGSP: NSMutableArray?, IFFC: NSMutableArray?){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let type = userDefaults.objectForKey("hba1cType") as! String
        self.hba1cType = type
        if( type == "NGSP(%)"){
            selectedRow = 0
        }else{
            selectedRow = 1 
        }
        if(NGSP == nil){
            userDefaults.removeObjectForKey("NGSP")
            let textFieldFront = "0.0"
            let textFiledBack = "7.5"
            let NGSPValue = NSMutableArray()
            NGSPValue.addObject(textFieldFront)
            NGSPValue.addObject(textFiledBack)
            userDefaults.setObject(NGSPValue,forKey:"NGSP")
            self.NGSP = NGSPValue
        }
        if(IFFC == nil){
            userDefaults.removeObjectForKey("IFFC")
            let textFieldFront = "0"
            let textFiledBack = "58"
            let IFFCValue = NSMutableArray()
            IFFCValue.addObject(textFieldFront)
            IFFCValue.addObject(textFiledBack)
            userDefaults.setObject(IFFCValue,forKey:"IFFC")
            self.IFFC = IFFCValue
        }
        userDefaults.synchronize()
    }

}
