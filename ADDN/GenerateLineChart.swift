//
//  GenerateLineChart.swift
//  ADDN
//
//  Created by Bo Li on 22/5/16.
//

import UIKit
import PNChart

class GenerateLineChart: NSObject {
    
    static let sharedManager = GenerateLineChart()
    private override init(){ }
    
    func setupLineChart(lineChart:PNLineChart, array:Array<Array<Float>>, minY:Float, maxY:Float,xUnit:String,yUnit:String,xLabels:Array<String>) -> Void {
        
        lineChart.yLabelFormat = "%1.1f";
        lineChart.backgroundColor = UIColor.clearColor();
        var width : CGFloat?
        if xLabels.count<=5 {
            width = 55
            lineChart.xLabelFont = UIFont.systemFontOfSize(11)
        }else{
            width = 38
            lineChart.xLabelFont = UIFont.systemFontOfSize(9)
        }
        lineChart.setXLabels(xLabels, withWidth: width!)
        lineChart.showCoordinateAxis = true;

        //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
        //Only if you needed
        lineChart.yFixedValueMax = CGFloat(maxY);
        lineChart.yFixedValueMin = CGFloat(minY);
        lineChart.yUnit = yUnit
        lineChart.xUnit = xUnit
        //lineChart.yLabels = ["0","10","20","30","40","50","60","70","80","90","100"]

        // Line Chart #1  Minimum
        let  data01Array = array[0]
        let  data01 = PNLineChartData()
        data01.dataTitle = "Minimum"
        data01.color = UIColor.redColor()
        data01.alpha = 1.0
        data01.itemCount = UInt(data01Array.count)
        data01.inflexionPointStyle = PNLineChartPointStyle.Triangle

        data01.getData = {index in
            let yValue = data01Array[Int(index)]
            return PNLineChartDataItem.init(y: CGFloat(yValue))
        }
        
        // Line Chart #2  My
        let  data02Array = array[1]
//        if array.count == 3{
//            
//        }
        let  data02 = PNLineChartData()
        data02.dataTitle = "My"
        data02.color = UIColor.greenColor()
        data02.alpha = 1.0
        data02.itemCount = UInt(data01Array.count)
        data02.inflexionPointStyle = PNLineChartPointStyle.Circle
        
        data02.getData = {index in
            let yValue = data02Array[Int(index)]
            return PNLineChartDataItem.init(y: CGFloat(yValue))
        }

        // Line Chart #3  Maximum
        let  data03Array = array[2]
        let  data03 = PNLineChartData()
        data03.dataTitle = "Minimum"
        data03.color = UIColor.orangeColor()
        data03.alpha = 1.0
        data03.itemCount = UInt(data01Array.count)
        data03.inflexionPointStyle = PNLineChartPointStyle.Square
        
        data03.getData = {index in
            let yValue = data03Array[Int(index)]
            return PNLineChartDataItem.init(y: CGFloat(yValue))
        }

        lineChart.chartData = [data01,data02,data03]
        lineChart.strokeChart()
        
    }
}
