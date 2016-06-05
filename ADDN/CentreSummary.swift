//
//  CentreSummary.swift
//  ADDN
//
//  Created by Jiajie Li on 22/03/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//

// This is a class used to display the detailed information of the centre 
// summart report in three different data representations - flat table, bar chart, pie chart.
// It interacts with the sideBar.swift class to display the slide out table for switching to different 
// column

import UIKit

class CentreSummary: UIViewController {
 

    @IBOutlet var scrollview: UIScrollView!
 
    @IBOutlet var tableButton: UIButton!
    
    @IBOutlet var barChartButton: UIButton!
    
    @IBOutlet var pieChartButton: UIButton!
    
    @IBOutlet var centreName: UILabel!
    var centreNamevalue:String!
    
    @IBOutlet var activeNum: UILabel!
    var activeNumValue:String!
    
    @IBOutlet var type1Num: UILabel!
    var type1NumValue:String = ""
    
    @IBOutlet var type2Num: UILabel!
    var type2NumValue:String = ""
    
    @IBOutlet var otherTypeNum: UILabel!
    var otherTypeNumValue:String = ""
    
    @IBOutlet var inactiveNum: UILabel!
    var inactiveNumValue:String = ""
    
    @IBOutlet var totalNum: UILabel!
    var totalNumValue:String = ""
    
    @IBOutlet var date: UILabel!
    var dateValue:String = ""
    
    let defaultColor: UIColor = UIColor()
    var tableTabViews: NSMutableArray = NSMutableArray()
    var barChartTabViews: NSMutableArray = NSMutableArray()

    var tabllTabViewLength:CGFloat = 0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        centreName.text = centreNamevalue
        activeNum.text = activeNumValue
        type1Num.text = type1NumValue
        type2Num.text = type2NumValue
        otherTypeNum.text = otherTypeNumValue
        inactiveNum.text = inactiveNumValue
        totalNum.text = totalNumValue
        date.text = dateValue
        barChartButton.tintColor = UIColor.grayColor()
        pieChartButton.tintColor = UIColor.grayColor()
        
        
        for view in scrollview.subviews {
            tableTabViews.addObject(view)
        }
        
        tabllTabViewLength = scrollview.contentSize.height
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pressTableButton(sender: AnyObject) {
        tableButton.tintColor = self.view.tintColor
        barChartButton.tintColor = UIColor.grayColor()
        pieChartButton.tintColor = UIColor.grayColor()
        
        for view in scrollview.subviews {
            view.removeFromSuperview()
        }
        scrollview.contentSize.height = tabllTabViewLength
        for view in tableTabViews{
            scrollview.addSubview(view as! UIView)
        }
        
        //Resume to the original length of view

        
    }
    
    
    @IBAction func pressBarChartButton(sender: AnyObject) {
        tableButton.tintColor = UIColor.grayColor()
        barChartButton.tintColor = self.view.tintColor
        pieChartButton.tintColor = UIColor.grayColor()
        
        for view in scrollview.subviews {
            view.removeFromSuperview()
        }
        
        scrollview.contentSize.height = tabllTabViewLength
        
        var pointer: CGFloat = 70
        let chartDistance:CGFloat = 50
        let headerDistance:CGFloat = 40
        
        pointer = displayTitle("Centre: " + centreNamevalue,detail:"", pos:"center", start: pointer)
        pointer = pointer + headerDistance
        pointer = displayTitle("Total Patients",detail:totalNumValue, pos:"not center", start: pointer)
        pointer = displayTitle("Last Update Date",detail:dateValue, pos:"not center", start: pointer)
        pointer = pointer + chartDistance
        
        pointer = displayTitle("Active & Inactive Patient",detail:"", pos:"center", start: pointer)
        
        //generate the first bar chart active/inactive
        let array1:Dictionary<String, CGFloat> = ["Active":CGFloat((activeNumValue as NSString).floatValue),"Inactive": CGFloat((inactiveNumValue as NSString).floatValue)]
        
        pointer = displayBarChart(array1, start: pointer)
        
        pointer = pointer + chartDistance
        
        pointer = displayTitle("Diabetes Type", detail:"", pos:"center", start: pointer)
        
        //generate the second pie chart diabetes Type
        let array2 = ["Type 1":CGFloat((type1NumValue as NSString).floatValue),"Type 2": CGFloat((type2NumValue as NSString).floatValue),"Other":CGFloat((otherTypeNumValue as NSString).floatValue)]
        
        pointer = displayBarChart(array2, start: pointer)
        
    }

    @IBAction func pressPieChartButton(sender: AnyObject) {
        tableButton.tintColor = UIColor.grayColor()
        barChartButton.tintColor = UIColor.grayColor()
        pieChartButton.tintColor = self.view.tintColor
        
        for view in scrollview.subviews {
            view.removeFromSuperview()
        }
        
        scrollview.contentSize.height = tabllTabViewLength
        
        var pointer: CGFloat = 70
        let chartDistance:CGFloat = 50
        let headerDistance:CGFloat = 40
        
        pointer = displayTitle("Centre: " + centreNamevalue,detail:"", pos:"center", start: pointer)
        pointer = pointer + headerDistance
        pointer = displayTitle("Total Patients",detail:totalNumValue, pos:"not center", start: pointer)
        pointer = displayTitle("Last Update Date",detail:dateValue, pos:"not center", start: pointer)
        pointer = pointer + chartDistance
        
        pointer = displayTitle("Active & Inactive Partition",detail:"", pos:"center", start: pointer)
        
        //generate the first pie chart active/inactive
        let array1:Dictionary<String, CGFloat> = ["Active":CGFloat((activeNumValue as NSString).floatValue),"Inactive": CGFloat((inactiveNumValue as NSString).floatValue)]
        pointer = displayPieChart(array1,start:pointer)

        pointer = pointer + chartDistance
        pointer = displayTitle("Diabetes Type Partition", detail:"", pos:"center", start: pointer)
        //generate the second pie chart diabetes Type
        let array2 = ["Type 1":CGFloat((type1NumValue as NSString).floatValue),"Type 2": CGFloat((type2NumValue as NSString).floatValue),"Other":CGFloat((otherTypeNumValue as NSString).floatValue)]
        
        pointer = displayPieChart(array2,start:pointer)

    }
    
    func displayBarChart(content:Dictionary<String,CGFloat>,start:CGFloat)->CGFloat{
        var pointer = start
        let barChartGenerator = GenerateBarChart()
        let barChart = barChartGenerator.drawBarChart(content)
        
        let chartHeight = barChart.frame.height
        barChart.frame.origin.y = start
        
        pointer = pointer + barChart.frame.height
        if(pointer > scrollview.contentSize.height){
            scrollview.contentSize.height =  scrollview.contentSize.height + chartHeight
        }
        scrollview.addSubview(barChart)
        return pointer
        
    }
    
    
    func displayPieChart(content:Dictionary<String,CGFloat>,start:CGFloat)->CGFloat{
        
        var pointer = start
        let pieChartGenerator = GeneratePieChart()
        let pieChart:UIView =  pieChartGenerator.drawPieChart(content)
        
        let chartHeight = pieChart.frame.height
        
        pieChart.frame.origin.y = start

        pointer = pointer + pieChart.frame.height
        if(pointer > scrollview.contentSize.height){
            scrollview.contentSize.height =  scrollview.contentSize.height + chartHeight
        }
        scrollview.addSubview(pieChart)
        return pointer
    }
    
    
    func displayTitle(title:String, detail: String, pos:String, start:CGFloat)->CGFloat{
        var pointer = start
        let titleHight:CGFloat = 30
        let label1 = UILabel(frame: CGRectMake(10, pointer, UIScreen.mainScreen().bounds.width, titleHight))
        label1.text = title
        if(pos == "center"){
            label1.textAlignment = NSTextAlignment.Center
        }else{
            label1.textAlignment = NSTextAlignment.Left
        }
        if(detail != ""){
            let label2 = UILabel(frame: CGRectMake(10, pointer, UIScreen.mainScreen().bounds.width - 30, titleHight))
            label2.text = detail
            label2.textAlignment = NSTextAlignment.Right
            label2.textColor = UIColor.grayColor()
            scrollview.addSubview(label2)
        }
        
        scrollview.addSubview(label1)
        pointer = pointer + titleHight
        if(pointer >= scrollview.contentSize.height){
            scrollview.contentSize.height =  scrollview.contentSize.height + titleHight
        }
        return pointer
    }
    

}
