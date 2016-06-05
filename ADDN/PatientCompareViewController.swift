//
//  PatientCompareViewController.swift
//  ADDN
//
//  Created by Bo Li on 22/5/16.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class PatientCompareViewController: UITableViewController,UISearchBarDelegate {

    
    var patientArray : Array<PatientModel> = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationItem.setHidesBackButton(true, animated: false)
        self.searchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - UISearchBar Delegate
    
    func  searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let patientLocalId = searchBar.text
        
        // query the patient using name....
        print("Patient name is :" + patientLocalId!);
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userInfo  = userDefaults.valueForKey("UserInfo") as? [String:String]
        let region = (userInfo?["region"]) as String!
        //////////search the patient from database.........
        HttpRequestManager.sharedManager.PostHttpRequest(PatientSearchAPI, parameters: ["localid_id":patientLocalId!,"centreId":region])
        { (response) in
            self.patientArray.removeAll()
            if let value = response.result.value {
                let json = JSON(value).array
                if(json?.count == 1){
                    SVProgressHUD.showErrorWithStatus("Patient with localid "+patientLocalId!+" does not in your centre")
                    let warning: UIAlertView = UIAlertView(title: "No Patient", message: "Patient with localid "+patientLocalId!+" does not in your centre", delegate: self, cancelButtonTitle: "Ok")
                    warning.show()
                    
                }else if json?.count == 3{
                    let p1 = PatientModel()
                    p1.agePeriod = json![1].string
                    p1.localId = patientLocalId
                    self.patientArray = [p1]
                }
            }
            self.tableView.reloadData()
        }
        //SVProgressHUD.showWithStatus("Searching...")
        self.searchBar.resignFirstResponder()
        //SVProgressHUD.dismiss()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        //self.tableView.reloadData()
        self.searchBar.resignFirstResponder()
        SVProgressHUD.dismiss()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    //MARK: - TableView Delegate
    
    
    //MARK: - TableView Datasource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("patientCell")! as UITableViewCell
        if patientArray.count == 0
        {
            cell.textLabel!.text = "No Patient Found"
            cell.detailTextLabel!.text = " "
        }else
        {
            let patient: PatientModel = self.patientArray[indexPath.row]
            cell.textLabel!.text = "Local-id:"+patient.localId!
            cell.detailTextLabel!.text = "Age Period:"+patient.agePeriod!
        }
        return cell
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        
        if(selectedCell!.textLabel!.text != "No Patient Found")  {
            self.performSegueWithIdentifier("CompareOptionsSegue", sender:indexPath)
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "CompareOptionsSegue" {
            if let viewController: PatientComparisionOptions = segue.destinationViewController as? PatientComparisionOptions
            {
                let patient = patientArray[sender!.row]
                viewController.patientAgePeriod = patient.agePeriod
                viewController.patientLocalId = patient.localId
            }
        }
        
    }
 

}
