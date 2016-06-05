//
//  CentreCompareAgeViewController.swift
//  ADDN
//
//  Created by Bo Li on 22/5/16.
//

import UIKit
import PNChart
import SwiftyJSON
import SVProgressHUD
class CentreCompareAgeViewController: UIViewController {

    @IBOutlet var ageLineChart: PNLineChart!
    
    private var minArr:Array<Float> = []
    private var myArr:Array<Float> = []
    private var maxArr:Array<Float> = []
    private var maxY:Float?
    private var minY:Float?
    
    private let xLabels:Array<String> = ["0-5","5-10","10-15","15-20","20+"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // get data from internet.
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userInfo  = userDefaults.valueForKey("UserInfo") as? [String:String]
        let region = (userInfo?["region"]) as String!
        //print(region)
        HttpRequestManager.sharedManager.PostHttpRequest(CentreAgeComparisionAPI, parameters: ["centreId":region], completionHandler: { response in
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
                    GenerateLineChart.sharedManager.setupLineChart(self.ageLineChart, array: [self.minArr,self.myArr,self.maxArr], minY: self.minY!, maxY: self.maxY!, xUnit: "age",yUnit:"num", xLabels:self.xLabels)
                }
            })
        
        // Do any additional setup after loading the view.
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
