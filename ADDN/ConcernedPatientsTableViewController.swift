//
//  ConcernedPatientsTableViewController.swift
//  ADDN
//
//  Created by Jiajie Li on 27/04/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//


// This class is the UITableViewController for the patient tab, which is used to 
// display the information of what kinds of paitens the user is interested.



import UIKit

class ConcernedPatientsTableViewController: UITableViewController {

    var selectedCellIndexPath: NSIndexPath?
    let SelectedCellHeight: CGFloat = 170.0
    let UnselectedCellHeight: CGFloat = 44.0
    
    var data:NSMutableArray = NSMutableArray()
    var container:UIView = UIView()
    var numberOfrow = 1
    var cellTitle = "No conerned patient yet"
    var openIndicator = (0,false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
     }
    
    override func viewDidAppear(animated: Bool) {
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let arrayOfConcernedPatients = userDefaults.objectForKey("ConcernedPatients") as? NSArray
        if(arrayOfConcernedPatients != nil){
            data = arrayOfConcernedPatients as! NSMutableArray
            numberOfrow = data.count
            tableView.reloadData()
            print(data)
        }
        
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
        return numberOfrow
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        
        if (data.count != 0){
            cellTitle = "Concerned Patient Number " + String(indexPath.row + 1)
        }else{
            cellTitle = "No conerned patient yet"
        }
        
         
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if(cell.viewWithTag(1) == nil){
            let oneLabel:UILabel = UILabel(frame: CGRectMake(10, 0, cell.frame.size.width, cell.frame.size.height))
            oneLabel.font = cell.textLabel!.font
            oneLabel.textAlignment = NSTextAlignment.Left
            oneLabel.text = cellTitle
            oneLabel.tag = 1
            cell!.contentView.addSubview(oneLabel)
        }else{
            let label:UILabel = cell.viewWithTag(1) as! UILabel 
             label.text = cellTitle
        }
        return cell
    }
    
     override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        if let selectedCellIndexPath = selectedCellIndexPath {
            if selectedCellIndexPath == indexPath {
                return SelectedCellHeight
            }
        }
        return UnselectedCellHeight
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        if (data.count == 0){
            return
        }
        
        for view in container.subviews {
            view.removeFromSuperview()
        }
        container.removeFromSuperview()
        
        createDetailView(indexPath.row)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if(openIndicator.0 == indexPath.row && openIndicator.1 == true){
            openIndicator.1 = false
            self.selectedCellIndexPath = nil
            tableView.beginUpdates()
            tableView.endUpdates()
        }else{
            selectedCellIndexPath = indexPath
            openIndicator.0 = indexPath.row
            openIndicator.1 = true
            tableView.beginUpdates()
            cell!.addSubview(container)
            tableView.endUpdates()
        }
    }
    
    
    func createDetailView(selectRow:Int){
        
        let dataForCell = data.objectAtIndex(selectRow) as! NSDictionary
        
        let patientid = dataForCell["addn_id"] as! String
        let diabetes_type = dataForCell["diabetes_type"] as! String
        let gender = dataForCell["gender"] as! String
        let age = dataForCell["age"] as! String
        let user_name = dataForCell["user_name"] as! String
        let email_address = dataForCell["email_address"] as! String
        let user_mobile = dataForCell["user_mobile"] as! String
        let patientCentre = dataForCell["centre_code"] as! String
        
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userInfo = userDefaults.objectForKey("UserInfo") as! NSDictionary
        let region = userInfo.objectForKey("region") as? String
        let dic:[String: String] = ["1":"NSW_SYD_CHW", "2": "QLD_BNE_LCH","3":"SA_ADL_WCH","4":"VIC_MEL_RCH","5":"WA_PER_PMH","6":"All"]
        
        var auth:Bool = false
        if(dic[patientCentre] == region || region == "All" ){
            auth = true
        }
        
        let width = UIScreen.mainScreen().bounds.size.width
        var hightOfLabel = (SelectedCellHeight - 44 ) / 5
        if(auth == true){
            hightOfLabel = (SelectedCellHeight - 44 ) / 6
        }
        container.frame = CGRectMake(0, 44, width, SelectedCellHeight - 44)
        container.backgroundColor = UIColor.clearColor()
        let blue = self.view.tintColor
        let orange = UIColor.orangeColor()

        let patientLabel = UILabel()
        let idLabel = UILabel()
        
        var doctorLabelStartPoint:CGFloat = 2
        
        patientLabel.frame = CGRectMake(10, 0, width/2, hightOfLabel)
        patientLabel.text = "Patient Info"
        patientLabel.textColor = orange
        idLabel.frame = CGRectMake(10, hightOfLabel, width/2, hightOfLabel)
        idLabel.text = "Patient ID :" + patientid
        idLabel.textColor = orange
        container.addSubview(idLabel)
        container.addSubview(patientLabel)
        
        if(auth == true){
            let genderLabel = UILabel()
            let diabeteTypeLabel = UILabel()
            let ageLabel = UILabel()
            genderLabel.frame = CGRectMake(width/2, hightOfLabel, width/2, hightOfLabel)
            genderLabel.text = "Gender: " + gender
            genderLabel.textColor = orange
            diabeteTypeLabel.frame = CGRectMake(10, 2 * hightOfLabel, width/2, hightOfLabel)
            diabeteTypeLabel.text = "Diabetes: " + diabetes_type
            diabeteTypeLabel.textColor = orange
            ageLabel.frame = CGRectMake(width/2, 2 * hightOfLabel, width/2, hightOfLabel)
            ageLabel.text = "Age: " + age
            ageLabel.textColor = orange
            container.addSubview(genderLabel)
            container.addSubview(diabeteTypeLabel)
            container.addSubview(ageLabel)
            doctorLabelStartPoint = 3
        }
        
        let doctorLabel = UILabel()
        let nameLabel = UILabel()
        let mobelLabel = UILabel()
        let emailLabel = UILabel()
        doctorLabel.frame = CGRectMake(10, doctorLabelStartPoint * hightOfLabel, width/2, hightOfLabel)
        doctorLabel.text = "Doctor Info"
        doctorLabel.textColor = blue
        nameLabel.frame = CGRectMake(10, (1 + doctorLabelStartPoint) * hightOfLabel, width/2, hightOfLabel)
        nameLabel.text = "Doctor : " + user_name
        nameLabel.textColor = blue
        mobelLabel.frame = CGRectMake(width/2, (1 + doctorLabelStartPoint) * hightOfLabel, width/2, hightOfLabel)
        mobelLabel.text = "Mobile: " + user_mobile
        mobelLabel.textColor = blue
        emailLabel.frame = CGRectMake(10, (2 + doctorLabelStartPoint) * hightOfLabel, width, hightOfLabel)
        emailLabel.text = "Email: " + email_address
        emailLabel.textColor = blue
        container.addSubview(doctorLabel)
        container.addSubview(nameLabel)
        container.addSubview(mobelLabel)
        container.addSubview(emailLabel)
        
    }
    
    
    @IBAction func deletePatient(sender: AnyObject) {
        
        let selectRow = tableView.indexPathForSelectedRow?.row
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let arrayOfConcernedPatients = userDefaults.objectForKey("ConcernedPatients") as? NSArray
        if(arrayOfConcernedPatients != nil){
            let oldArray = arrayOfConcernedPatients as! NSMutableArray
            let newArray = NSMutableArray()
            for i in 0 ..< oldArray.count{
                if(i != selectRow){
                    newArray.addObject(oldArray.objectAtIndex(i))
                }
            }
            userDefaults.removeObjectForKey("ConcernedPatients")
            userDefaults.setObject(newArray, forKey: "ConcernedPatients")
            data = newArray
            numberOfrow = data.count
            tableView.reloadData()
        }
        
    }
    
    

}
