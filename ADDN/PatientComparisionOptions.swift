//
//  PatientComparisionOptions.swift
//  ADDN
//
//  Created by Bo Li on 22/5/16.
//

import UIKit

class PatientComparisionOptions: UITableViewController {

    var patientAgePeriod : String?
    var patientLocalId : String?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("patient........" + patientLocalId!)
        self.title = patientLocalId
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var segueIdentifier: String?
        switch indexPath.row {
        case 0:
            segueIdentifier = "patientHbA1c"
            break
        case 1:
            segueIdentifier = "patientBmi"
            break
        case 2:
            segueIdentifier = "patientDiabetes"
            break
        default:
            break
        }
        self.performSegueWithIdentifier(segueIdentifier!, sender: indexPath)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        switch segue.identifier! {
        case "patientHbA1c":
            if let viewController: PatientHbA1cViewController = segue.destinationViewController as? PatientHbA1cViewController
            {
                viewController.agePeriod = self.patientAgePeriod
                viewController.localId = self.patientLocalId
            }
            break
        case "patientBmi":
            if let viewController: PatientBmiSdsViewController = segue.destinationViewController as? PatientBmiSdsViewController
            {
                viewController.agePeriod = self.patientAgePeriod
                viewController.localId = self.patientLocalId
            }
            break
        case "patientDiabetes":
            if let viewController: PatientDiabetesDurationViewController = segue.destinationViewController as? PatientDiabetesDurationViewController
            {
                viewController.agePeriod = self.patientAgePeriod
                viewController.localId = self.patientLocalId
            }
            break
        default:
            break
        }
        
    }
    
}
