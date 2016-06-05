//
//  CentreBmiSdsComparisionViewController.swift
//  ADDN
//
//  Created by Bo Li on 22/5/16.
//

import UIKit
import PNChart
import SwiftyJSON
import SVProgressHUD
import Alamofire


class CentreBmiSdsComparisionViewController: UIViewController {

    //@IBOutlet var bmiScatter: PNScatterChart!
    private let xLabels:Array<String> = ["0-5","5-10","10-15","15-20","20+"]
    
    private var minArr:Array<Float> = []
    private var myArr:Array<Float> = []
    private var maxArr:Array<Float> = []
    private var maxY:Float?
    private var minY:Float?
    
    
    @IBOutlet weak var bmiLineChart: PNLineChart!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get data from internet.
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userInfo  = userDefaults.valueForKey("UserInfo") as? [String:String]
        let region = (userInfo?["region"]) as String!
        HttpRequestManager.sharedManager.PostHttpRequest(CentreBMISDSComparisionAPI, parameters: ["centreId":region], completionHandler: { response in
            print(response.result.value)
            if let value = response.result.value {
                let json = JSON(value)
                // 解析MIN
                if let minArr = json[0].array {
                    self.minArr.removeAll()
                    minArr.forEach({(number) in
                        let value = (number.null != nil) ? 0 : number.floatValue
                        self.minArr.append(value)
                    })
                }
                if let myArr = json[1].array{
                    self.myArr.removeAll()
                    myArr.forEach({(number) in
                        let value = (number.null != nil) ? 0 : number.floatValue
                        self.myArr.append(value)
                    })
                }
                
                if let maxArr = json[2].array{
                    self.maxArr.removeAll()
                    maxArr.forEach({ (number) in
                        let value = (number.null != nil) ? 0 : number.floatValue
                        self.maxArr.append(value)
                    })
                }
                
                if let maxY = json[3].float{
                    self.maxY = Float(maxY)
                }
                
                if let minY = json[4].float{
                    self.minY = Float(minY)
                }
                
                // draw the line chart
               // GenerateLineChart.sharedManager.setupLineChart(self.bmiLineChart, array: [self.minArr,self.myArr,self.maxArr], minY: self.minY!, maxY: self.maxY!, xUnit: "age",yUnit:"BMI SDS", xLabels:self.xLabels)
                GenerateLineChart.sharedManager.setupLineChart(self.bmiLineChart, array: [self.minArr,self.myArr,self.maxArr], minY: -3, maxY:3, xUnit: "age",yUnit:"BMI SDS", xLabels:self.xLabels)
            }
        })

        
        
        
        //GenerateLineChart.sharedManager.setupLineChart(self.bmiLineChart, array: [[-1,-1,-3,-2,1],[2,1,0,1,-1],[1,2,3,2,2]], minY: -3, maxY: 3, xUnit: "age",yUnit:"BMI SDS", xLabels: xLabels)
        //let array:Array<CGFloat> = [-3,1,3]
        //GenerateScatterChart().setupScatterChart(self.bmiScatter, array: array)
        
        // Do any additional setup after loading the view.
        
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
