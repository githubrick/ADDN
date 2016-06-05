//
//  PatientHbA1cViewController.swift
//  ADDN
//
//  Created by Bo Li on 22/5/16.
//

import UIKit
import PNChart
import SwiftyJSON
import SVProgressHUD

class PatientHbA1cViewController: UIViewController {
    
    var agePeriod: String?
    var localId : String?
    
    // Line chart to show NGSP
    
    @IBOutlet  var ngspScatter: PNScatterChart!
    var ngspArray : Array<CGFloat> = []
    
    // Line chart to show IFFC
    @IBOutlet var scrollView: UIScrollView!
    
    
    @IBOutlet  var iffcScatter: PNScatterChart!
    var iffcArray : Array<CGFloat> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.ageLabel.text = agePeriod
        print("patient..local......" + localId!)
        
        self.scrollView.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)
        self.scrollView.contentSize = CGSize(width: self.view.frame.width,height: 700)
        self.getDataForNgspScatter()
        //self.setupScatter("NGSP", dataArray: [-10.1,20.8,1092.0])
        self.getDataForIffcScatter()
        //self.setupScatter("IFFC", dataArray: [-10.1,20.8,692.0])
       
    }

    // fetch data from internet...
    func getDataForIffcScatter() {
        
        HttpRequestManager.sharedManager.PostHttpRequest(PatientHbA1cIFFCComparisionAPI, parameters: ["localid_id":self.localId!], completionHandler: {response in
            print(response.result.value)
            if let json = JSON(response.result.value!).array  {
                //let json = JSON(value).array
                if(json.count == 3){
                    let min = json[0].floatValue
                    let patient  = json[1].floatValue
                    let max = json[2].floatValue
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        //self.setupScatter("NGSP", dataArray: [CGFloat(min),CGFloat(patient),CGFloat(max)])
                        //GenerateScatterChart().setupScatterChart(self.ngspScatter, array:[CGFloat(min),CGFloat(patient),CGFloat(max)])
                        
                        let scatterChart = PNScatterChart.init(frame: CGRectMake(0, 340, 320, 300))
                        scatterChart.setAxisXWithMinimumValue(20, andMaxValue: 100, toTicks: 5)
                        let diff = Int32(max-min)
                        var ticks : Int32?
                        if  diff <= 10 {
                            ticks = 5
                        }else if diff > 10
                        {
                            ticks = 10
                        }
                        
                        scatterChart.setAxisYWithMinimumValue(CGFloat(min), andMaxValue:CGFloat(max), toTicks: ticks!)
                        scatterChart.duration = 0.5
                        // minimum
                        let  data01 = PNScatterChartData()
                        data01.strokeColor = UIColor.redColor()
                        data01.fillColor = UIColor.redColor()
                        data01.size = 6
                        data01.itemCount = 1
                        data01.inflexionPointStyle = PNScatterChartPointStyle.Square
                        let  XAr1 = [60]
                        let YAr1 = Array([min])
                        
                        data01.getData = { index  in
                            let  xValue = CGFloat(XAr1[Int(index)])
                            let  yValue = CGFloat(YAr1[Int(index)])
                            return PNScatterChartDataItem.init(x: xValue, andWithY: yValue)
                        }
                        
                        // your
                        let  data02 = PNScatterChartData()
                        data02.strokeColor = UIColor.greenColor()
                        data02.fillColor = UIColor.greenColor()
                        data02.size = 5
                        data02.itemCount = 1
                        data02.inflexionPointStyle = PNScatterChartPointStyle.Circle
                        let  XAr2 = [60]
                        let YAr2 = Array([patient])
                        
                        data02.getData = { index  in
                            let  xValue = CGFloat(XAr2[Int(index)])
                            let  yValue = CGFloat(YAr2[Int(index)])
                            return PNScatterChartDataItem.init(x: xValue, andWithY: yValue)
                        }
                        
                        // maximum
                        
                        let  data03 = PNScatterChartData()
                        data03.strokeColor = UIColor.orangeColor()
                        data03.fillColor = UIColor.orangeColor()
                        data03.size = 6
                        data03.itemCount = 1
                        data03.inflexionPointStyle = PNScatterChartPointStyle.Square
                        let  XAr3 = [60]
                        let YAr3 = Array([max])
                        
                        data03.getData = { index  in
                            let  xValue = CGFloat(XAr3[Int(index)])
                            let  yValue = CGFloat(YAr3[Int(index)])
                            return PNScatterChartDataItem.init(x: xValue, andWithY: yValue)
                        }
                        
                        scatterChart.chartData = [data01,data02,data03]
                        scatterChart.setup()
                        let ageLabel = UILabel.init(frame: CGRectMake(155, 610, 50, 30))
                        ageLabel.text = self.agePeriod
                        self.scrollView.addSubview(ageLabel)
                        self.scrollView.addSubview(scatterChart)
                        
                    })
                }else{
                    let warning: UIAlertView = UIAlertView(title: "No Record", message: "The patient has no visit record", delegate: nil, cancelButtonTitle: "Ok")
                    warning.show()
                    // SVProgressHUD.showErrorWithStatus("No Visit Records")
                }
            }

        })
    }
    
    // fetch data from internet...
    func getDataForNgspScatter() {
        
        HttpRequestManager.sharedManager.PostHttpRequest(PatientHbA1cNGSPComparisionAPI, parameters: ["localid_id":self.localId!], completionHandler: {response in
            //print(response.result.value)
            if let json = JSON(response.result.value!).array {
                //let json = JSON(value).array
                if(json.count == 3){
                    let min = json[0].floatValue
                    let patient  = json[1].floatValue
                    let max = json[2].floatValue
                    dispatch_async(dispatch_get_main_queue(), {
                        //self.setupScatter("NGSP", dataArray: [CGFloat(min),CGFloat(patient),CGFloat(max)])
                        //GenerateScatterChart().setupScatterChart(self.ngspScatter, array:[CGFloat(min),CGFloat(patient),CGFloat(max)])
                        
                        let scatterChart = PNScatterChart.init(frame: CGRectMake(0, 20, 320, 300))
                        scatterChart.setAxisXWithMinimumValue(20, andMaxValue: 100, toTicks: 5)
                        let diff = Int32(max-min)
                        var ticks : Int32?
                        if  diff <= 10 {
                            ticks = 5
                        }else if diff > 10
                        {
                            ticks = 10
                        }
                        
                        scatterChart.setAxisYWithMinimumValue(CGFloat(min), andMaxValue:CGFloat(max), toTicks: ticks!)
                        scatterChart.duration = 0.5
                        // minimum
                        let  data01 = PNScatterChartData()
                        data01.strokeColor = UIColor.redColor()
                        data01.fillColor = UIColor.redColor()
                        data01.size = 6
                        data01.itemCount = 1
                        data01.inflexionPointStyle = PNScatterChartPointStyle.Square
                        let  XAr1 = [60]
                        let YAr1 = Array([min])
                        
                        data01.getData = { index  in
                            let  xValue = CGFloat(XAr1[Int(index)])
                            let  yValue = CGFloat(YAr1[Int(index)])
                            return PNScatterChartDataItem.init(x: xValue, andWithY: yValue)
                        }
                        
                        // your
                        let  data02 = PNScatterChartData()
                        data02.strokeColor = UIColor.greenColor()
                        data02.fillColor = UIColor.greenColor()
                        data02.size = 5
                        data02.itemCount = 1
                        data02.inflexionPointStyle = PNScatterChartPointStyle.Circle
                        let  XAr2 = [60]
                        let YAr2 = Array([patient])
                        
                        data02.getData = { index  in
                            let  xValue = CGFloat(XAr2[Int(index)])
                            let  yValue = CGFloat(YAr2[Int(index)])
                            return PNScatterChartDataItem.init(x: xValue, andWithY: yValue)
                        }
                        
                        // maximum
                        
                        let  data03 = PNScatterChartData()
                        data03.strokeColor = UIColor.orangeColor()
                        data03.fillColor = UIColor.orangeColor()
                        data03.size = 6
                        data03.itemCount = 1
                        data03.inflexionPointStyle = PNScatterChartPointStyle.Square
                        let  XAr3 = [60]
                        let YAr3 = Array([max])
                        
                        data03.getData = { index  in
                            let  xValue = CGFloat(XAr3[Int(index)])
                            let  yValue = CGFloat(YAr3[Int(index)])
                            return PNScatterChartDataItem.init(x: xValue, andWithY: yValue)
                        }
                        
                        scatterChart.chartData = [data01,data02,data03]
                        
                        scatterChart.setup()
                        let ageLabel = UILabel.init(frame: CGRectMake(155, 290, 50, 30))
                        ageLabel.text = self.agePeriod
                        self.scrollView.addSubview(ageLabel)
                        self.scrollView.addSubview(scatterChart)
                        
                    })
                }else{
                    //let warning: UIAlertView = UIAlertView(title: "No Record", message: "The patient has no visit record", delegate: nil, cancelButtonTitle: "Ok")
                    //warning.show()
                    // SVProgressHUD.showErrorWithStatus("No Visit Records")
                }
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
