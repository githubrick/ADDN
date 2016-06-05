//
//  CentreHbA1cComparisionViewController.swift
//  ADDN
//
//  Created by Bo Li on 22/5/16.
//

import UIKit
import PNChart
import SVProgressHUD
import SwiftyJSON
import Alamofire

class CentreHbA1cComparisionViewController: UIViewController {

    private let xLabels:Array<String> = ["0-5","5-10","10-15","15-20","20+"]
    
    // Line chart to show NGSP
    @IBOutlet var ngspLineChart: PNLineChart!
    // for  NGSP
    private var minArr1:Array<Float> = []
    private var myArr1:Array<Float> = []
    private var maxArr1:Array<Float> = []
    private var maxY1:Float?
    private var minY1:Float?

    
    @IBOutlet var scrollView: UIScrollView!
    // Line chart to show IFFC
    
    @IBOutlet weak var iffcLineChart: PNLineChart!
    // for IFFC
    private var minArr2:Array<Float> = []
    private var myArr2:Array<Float> = []
    private var maxArr2:Array<Float> = []
    private var maxY2:Float?
    private var minY2:Float?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width,height: self.iffcLineChart.frame.height + self.iffcLineChart.frame.origin.y + 20)
        
        self.getDataForNgspLine()
        self.getDataForIffcLine()
        //self.getDataForNgspLine()
        
//        GenerateLineChart.sharedManager.setupLineChart(self.ngspLineChart, array: [[10,20,30,25,15],[20,30,40,20,60],[50,60,50,40,80]], minY: 0, maxY: 100, xUnit: "age",yUnit:"NGSP(%)", xLabels: xLabels)
//        
//        GenerateLineChart.sharedManager.setupLineChart(self.iffcLineChart, array: [[10,20,30,25,15],[20,30,40,20,60],[50,60,50,40,80]], minY: 0, maxY: 100, xUnit: "age",yUnit:" ", xLabels: xLabels)
        
    }
    
    // fetch data from internet...
    func getDataForIffcLine(){
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userInfo  = userDefaults.valueForKey("UserInfo") as? [String:String]
        let region = (userInfo?["region"]) as String!
        
        HttpRequestManager.sharedManager.PostHttpRequest(CentreHbA1cIFFCComparisionAPI, parameters: ["centreId":region], completionHandler: { response in
            print(response.result.value)
            if let value = response.result.value {
                let json = JSON(value)
                // 解析MIN
                if let minArr = json[0].array {
                    self.minArr2.removeAll()
                    minArr.forEach({(number) in
                        self.minArr2.append(number.floatValue)
                    })
                }else {
                    self.minArr2 = [0,0,0,0,0]
                }
                
                if let myArr = json[1].array{
                    self.myArr2.removeAll()
                    myArr.forEach({(number) in
                        self.myArr2.append(number.floatValue)
                    })
                }else {
                    //self.minArr1.removeAll()
                    self.myArr2 = [0,0,0,0,0]
                }
                
                if let maxArr = json[2].array{
                    self.maxArr2.removeAll()
                    maxArr.forEach({ (number) in
                        self.maxArr2.append(number.floatValue)
                    })
                }else{
                    self.maxArr2 = [0,0,0,0,0]
                }
                
                if let maxY = json[3].string{
                    self.maxY2 = Float(maxY)
                }
                
                if let minY = json[4].float{
                    self.minY2 = Float(minY)
                }
                
                // draw the line chart
                GenerateLineChart.sharedManager.setupLineChart(self.iffcLineChart, array: [self.minArr2,self.myArr2,self.maxArr2], minY: self.minY2!, maxY: self.maxY2!, xUnit: "age",yUnit:" ", xLabels:self.xLabels)
            }
        })
        
    }
    
    func getDataForNgspLine(){
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let userInfo  = userDefaults.valueForKey("UserInfo") as? [String:String]
        let region = (userInfo?["region"]) as String!
        
        HttpRequestManager.sharedManager.PostHttpRequest(CentreHbA1cNGSPComparisionAPI, parameters: ["centreId":region], completionHandler: { response in
            print(response.result.value)
            if let value = response.result.value {
                let json = JSON(value)
                // 解析MIN
                if let minArr = json[0].array {
                    self.minArr1.removeAll()
                    minArr.forEach({(number) in
                        self.minArr1.append(number.floatValue)
                    })
                }else {
                    //self.minArr1.removeAll()
                    self.minArr1 = [0,0,0,0,0]
                }
                
                
                if let myArr = json[1].array{
                    self.myArr1.removeAll()
                    myArr.forEach({(number) in
                        self.myArr1.append(number.floatValue)
                    })
                }else{
                    self.myArr1 = [0,0,0,0,0]
                }
                
                if let maxArr = json[2].array{
                    self.maxArr1.removeAll()
                    maxArr.forEach({ (number) in
                        self.maxArr1.append(number.floatValue)
                    })
                }else{
                    self.maxArr1 = [0,0,0,0,0]
                }
                
                if let maxY = json[3].string{
                    self.maxY1 = Float(maxY)
                }
                
                if let minY = json[4].float{
                    self.minY1 = Float(minY)
                }
                
                // draw the line chart
                GenerateLineChart.sharedManager.setupLineChart(self.ngspLineChart, array: [self.minArr1,self.myArr1,self.maxArr1], minY: self.minY1!, maxY: self.maxY1!, xUnit: "age",yUnit:"NGSP(%)", xLabels:self.xLabels)
            }
        })

    }
    

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        SVProgressHUD.dismiss()
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
