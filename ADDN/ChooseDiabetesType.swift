//
//  ChooseDiabetesType.swift
//  ADDN
//
//  Created by Jiajie Li on 25/03/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//

// This is a class used to allow user to select diabete type. It will display a flat table
// to allow user to choose the parameters.

import UIKit

class ChooseDiabetesType: UITableViewController {

    
    let list:[(identifier: String, content: String)] = [("type1","TYPE_1"), ("type2", "TYPE_2"),("monogenic","MONOGENIC"),("cfrd","CFRD"),("neonatal","NEONATAL"),("other","OTHER")]
    var selectedRow = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let test = userDefaults.objectForKey("diabetesType") as? String
        for i in 0 ..< list.count  {
            if (test == list[i].content) {
                selectedRow = i
                break
            }
        }
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
        userDefaults.removeObjectForKey("diabetesType")
        userDefaults.setObject(list[selectedRow].content, forKey: "diabetesType")
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




}
