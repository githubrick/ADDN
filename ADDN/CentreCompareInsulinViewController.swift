//
//  CentreCompareInsulinViewController.swift
//  ADDN
//
//  Created by Bo Li on 22/5/16.
//

import UIKit
import PNChart
import SwiftyJSON
import SVProgressHUD

class CentreCompareInsulinViewController: UIViewController {

    private let xLabels:Array<String> = ["0-5","5-10","10-15","15-20","20+"]
    
    private var minArr:Array<Float> = []
    private var myArr:Array<Float> = []
    private var maxArr:Array<Float> = []
    private var maxY:Float?
    private var minY:Float?
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet var insulinRegimenLineChart: PNLineChart!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.segmentControl.setWidth(100, forSegmentAtIndex: 1)
        self.segmentControl.setTitle("BD Twice Daily", forSegmentAtIndex: 1)
        //GenerateLineChart().setupLineChart(self.insulinRegimenLineChart, array: [[10,20,30,25,15],[20,30,40,20,60],[50,60,50,40,80]], minY: 0, maxY: 100, xUnit: "reg", xLabels: ["CSⅡ","BD Twice Daily","MDI","Other","nil"])
        // Do any additional setup after loading the view.
        self.segmentControl.selectedSegmentIndex = 0
        self.valueChanged(self.segmentControl)
    }

    
    @IBAction func valueChanged(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        //var arr : Array<Array<Float>> = []
        var type: String?
        switch index {
        case 0:
            type = "CSII"
            break
        case 1:
            type = "BD_TWICE_DAILY"
            break
        case 2:
            type = "MDI"
            break
        case 3:
            type = "OTHER"
            break
        case 4:
            type = "NULL"
            break
        default:
            break
        }
        
        // get data from internet.
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userInfo  = userDefaults.valueForKey("UserInfo") as? [String:String]
        let region = (userInfo?["region"]) as String!
        
        HttpRequestManager.sharedManager.PostHttpRequest(CentreRegimenComparisionAPI, parameters:["centreId":region,"type":type!], completionHandler: { response in
            print(response.result.value)
                if let value = response.result.value {
                    let json = JSON(value)
                    // 解析MIN
                    if let minArr = json[0].array {
                        self.minArr.removeAll()
                        minArr.forEach({(number) in
                            self.minArr.append(number.floatValue)
                        })
                    }
                    if let myArr = json[1].array{
                        self.myArr.removeAll()
                        myArr.forEach({(number) in
                            self.myArr.append(number.floatValue)
                        })
                    }
                    
                    if let maxArr = json[2].array{
                        self.maxArr.removeAll()
                        maxArr.forEach({ (number) in
                            self.maxArr.append(number.floatValue)
                        })
                    }
                    if let maxY = json[3].float{
                        self.maxY = maxY
                    }
                    
                    if let minY = json[4].float{
                        self.minY = minY
                    }
                    
                    // draw the line chart
                    GenerateLineChart.sharedManager.setupLineChart(self.insulinRegimenLineChart, array: [self.minArr,self.myArr,self.maxArr], minY: self.minY!, maxY: self.maxY!, xUnit: "age",yUnit:"num", xLabels:self.xLabels)
                }
        })
        //GenerateLineChart.sharedManager.setupLineChart(self.insulinRegimenLineChart, array: arr, minY: 0, maxY: 100, xUnit: "age",yUnit: "num", xLabels:xLabels)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        SVProgressHUD.dismiss()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
