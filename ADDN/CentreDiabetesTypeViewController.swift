//
//  CentreDiabetesTypeViewController.swift
//  ADDN
//
//  Created by Bo Li on 22/5/16.
//

import UIKit
import PNChart
import SwiftyJSON
import SVProgressHUD
import Alamofire

class CentreDiabetesTypeViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    private let xLabels:Array<String> = ["0-5","5-10","10-15","15-20","20+"]
    
    private var minArr:Array<Float> = []
    private var myArr:Array<Float> = []
    private var maxArr:Array<Float> = []
    private var maxY:Float?
    private var minY:Float?
    
    @IBOutlet var diabetesTypeLineChart: PNLineChart!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //GenerateLineChart().setupLineChart(self.diabetesTypeLineChart, array: [[10,20,30,25,15,10,6],[20,30,40,20,60,20,8],[50,60,50,40,80,21,7]], minY: 0, maxY: 100, xUnit: " ", xLabels: xLabels)
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
            type = "TYPE_1"
            break
        case 1:
            type = "TYPE_2"
            break
        case 2:
            type = "MONOGENIC"
            break
        case 3:
            type = "CFRD"
            break
        case 4:
            type = "NEONATAL"
            break
        case 5:
            type = "OTHER"
            break
        default:
            break
        }
        
        // get data from internet.
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userInfo  = userDefaults.valueForKey("UserInfo") as? [String:String]
        let region = (userInfo?["region"]) as String!
        
        HttpRequestManager.sharedManager.PostHttpRequest(CentreDiabetesTypeComparisionAPI, parameters:["centreId":region,"type":type!], completionHandler: { response in
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
                GenerateLineChart.sharedManager.setupLineChart(self.diabetesTypeLineChart, array: [self.minArr,self.myArr,self.maxArr], minY: self.minY!, maxY: self.maxY!, xUnit: "age",yUnit:"num", xLabels:self.xLabels)
            }
        })

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        SVProgressHUD.dismiss()
    }
}
