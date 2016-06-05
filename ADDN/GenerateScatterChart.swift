//
//  GenerateScatterChart.swift
//  ADDN
//
//  Created by Bo Li on 22/5/16.
//

import UIKit
import PNChart

class GenerateScatterChart: NSObject {

//    static let sharedManager = GenerateScatterChart()
//    private override init(){ }
    
    func setupScatterChart(scatterChart:PNScatterChart,array:Array<CGFloat>) -> Void
    {
        
        if array.count == 3 {
            scatterChart.setAxisXWithMinimumValue(20, andMaxValue: 100, toTicks: 5)
            let diff = Int32(array[2]-array[0])
            var ticks : Int32?
            if  diff <= 10 {
                ticks = 5
            }else if diff > 10
            {
                ticks = 10
            }
            
            scatterChart.setAxisYWithMinimumValue(array[0], andMaxValue: array[2], toTicks: ticks!)
            scatterChart.duration = 0.5
            // minimum
            let  data01 = PNScatterChartData()
            data01.strokeColor = UIColor.redColor()
            data01.fillColor = UIColor.redColor()
            data01.size = 6
            data01.itemCount = 1
            data01.inflexionPointStyle = PNScatterChartPointStyle.Square
            let  XAr1 = [60]
            let YAr1 = Array([array[0]])
            
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
            let YAr2 = Array([array[1]])
            
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
            let YAr3 = Array([array[2]])
            
            data03.getData = { index  in
                let  xValue = CGFloat(XAr3[Int(index)])
                let  yValue = CGFloat(YAr3[Int(index)])
                return PNScatterChartDataItem.init(x: xValue, andWithY: yValue)
            }
            
            scatterChart.chartData = [data01,data02,data03]
            
            scatterChart.setup()
        }

    }
    
    func setupDurationScatterChart(scatterChart:PNScatterChart,array:Array<CGFloat>) -> Void
    {
        
        if array.count == 3 {
            scatterChart.setAxisXWithMinimumValue(20, andMaxValue: 100, toTicks: 5)
            scatterChart.yLabelFormat =  "%1.1f";
            //scatterChart.setAxisYWithMinimumValue(array[0], andMaxValue: array[2], toTicks: Int32((array[2]-array[0])/5))
            // minimum
            let  data01 = PNScatterChartData()
            data01.strokeColor = UIColor.redColor()
            data01.fillColor = UIColor.redColor()
            data01.size = 6
            data01.itemCount = 1
            data01.inflexionPointStyle = PNScatterChartPointStyle.Square
            let  XAr1 = [60]
            let YAr1 = Array([array[0]])
            
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
            let YAr2 = Array([array[1]])
            
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
            let YAr3 = Array([array[2]])
            
            data03.getData = { index  in
                let  xValue = CGFloat(XAr3[Int(index)])
                let  yValue = CGFloat(YAr3[Int(index)])
                return PNScatterChartDataItem.init(x: xValue, andWithY: yValue)
            }
            
            scatterChart.chartData = [data01,data02,data03]
            
            scatterChart.setup()
        }
        
    }

    
}
