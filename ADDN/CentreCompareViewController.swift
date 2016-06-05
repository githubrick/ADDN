//
//  CentreCompareViewController.swift
//  ADDN
//
//  Created by Bo Li on 22/5/16.
//

import UIKit

class CentreCompareViewController: UIViewController {

    var  comparisionIndex : NSInteger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("comparision index ......" + String(comparisionIndex))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
