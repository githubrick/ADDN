//
//  ChooseIPNCFFR.swift
//  ADDN
//
//  Created by Jiajie Li on 24/03/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//

// This class is used for allowing user to choose the IPNCFFR parameter. It is a flat talbe.

import UIKit

class ChooseIPNCFFR: UITableViewController {

    let list:[(identifier: String, content: String)] = [("yes","1"), ("no", "0")]
    var selectedRow = -1 //means unkonwn yet 
    //this vaule is either set by the upper view default value or the user
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if((userDefaults.objectForKey("IPNCFFR") as? String) == "1"){
            selectedRow = 0
        }else{
            selectedRow = 1
        }
        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        //
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
        userDefaults.removeObjectForKey("IPNCFFR")
        userDefaults.setObject(list[selectedRow].content, forKey: "IPNCFFR")
        userDefaults.synchronize()
        self.tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let kCellIdentifier = list[indexPath.row].identifier
        let content = list[indexPath.row].identifier
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
    
    
    

}
