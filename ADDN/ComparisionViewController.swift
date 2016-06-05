//
//  ComparisionViewController.swift
//  ADDN
//
//  Created by Bo Li on 22/5/16.
//

import UIKit
import SVProgressHUD
class ComparisionViewController: UITableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func segueToPatientComparision(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("PatientComparisionSegue", sender: nil)
        
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //self.performSegueWithIdentifier("ComparisionSegue", sender: indexPath)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
       // super.prepareForSegue(segue, sender:sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ComparisionSegue" {
            if let viewController: CentreCompareViewController = segue.destinationViewController as? CentreCompareViewController
            {
                viewController.comparisionIndex = sender!.row
            }
        }else if segue.identifier == "PatientComparisionSegue" {
        
            
        }
        
    }
 

}
