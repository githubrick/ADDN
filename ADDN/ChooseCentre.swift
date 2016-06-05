//
//  ChooseCentre.swift
//  ADDN
//
//  Created by Jiajie Li on 24/03/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//

// This class provides a flat talbe that allow users to select which data centre they want.

import UIKit

class ChooseCentre: UITableViewController {

    let list:[(identifier: String, content: String)] = [("NSW","Children's Hospital at Westmead"), ("QBL", "Lady Cilento Children's Hospital"),("SAW","Woemen and Children's Hosptial"),("VMR","Royal Children's Hosptial"),("WPP","Princess Margaret Hospital"),("AllCentre","All Centre")]
    var selectedRow = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        selectedRow = userDefaults.objectForKey("centre") as! Int
        selectedRow -= 1
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
        return 6
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        selectedRow = indexPath.row
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("centre")
        //Because selectRow start from 0 and centreID start from 1
        userDefaults.setObject(selectedRow + 1, forKey: "centre")
        userDefaults.synchronize()
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
       
        if( selectedRow == indexPath.row){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    
    
}
