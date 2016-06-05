//
//  ReportViewController.swift
//  ADDN
//
//  Created by Jiajie Li on 22/03/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//

// This class is the second tab of the tab bar controller. It provides the flat table 
// that allow user to choose different centre report they that want to generate.

import UIKit

class ReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
//    let list:[(identifier: String, content: String)] = [("diseaseType","Disease Type"), ("insulinRegimen", "Insulin Regimen"),("hba1c","HbA1c"),("bmiSDS","BMI SDS"),("severeHypoDKA","Severe Hypo & DKA"),("completenessAudit","Completeness & Audit")]
    let list:[(identifier: String, content: String)] = [ ("insulinRegimen", "Insulin Regimen"),("hba1c","HbA1c"),("bmiSDS","BMI SDS"),("diseaseType","Disease Type")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 4
    }
    
    override func viewWillAppear(animated: Bool){
        tableView.reloadData()
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("centre")
        userDefaults.removeObjectForKey("IPNCFFR")
        userDefaults.removeObjectForKey("CAR")
        userDefaults.removeObjectForKey("diabetesType")
        userDefaults.removeObjectForKey("diabetesDuration")
        userDefaults.removeObjectForKey("hba1cType")
        userDefaults.removeObjectForKey("SIRBBAR")
        userDefaults.removeObjectForKey("NGSP")
        userDefaults.removeObjectForKey("IFFC")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let kCellIdentifier = list[indexPath.row].identifier
        let content = list[indexPath.row].content
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell!
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: kCellIdentifier)
        }
        cell.textLabel!.text = content
        return cell
    }
    
}

