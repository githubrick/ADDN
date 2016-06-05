//
//  GenerateBarChart.swift
//  ADDN
//
//  Created by Jiajie Li on 26/04/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//

// This is a class used to return a bar chart view based on the input data.

import UIKit
import EChart

class GenerateBarChart: NSObject,EColumnChartDataSource,EColumnChartDelegate  {
   

    var eColumnChart:EColumnChart = EColumnChart()
    var numberOfColumn:Int!
    var numberOfPresent:Int!
    var data:NSMutableArray = NSMutableArray()
    var columnName:NSMutableArray = NSMutableArray()
    
    func drawBarChart(scores:Dictionary<String,CGFloat>)->UIView{
    
        eColumnChart.frame = CGRectMake(40, 100, 250, 200)
        eColumnChart.backgroundColor = UIColor.clearColor()
        numberOfColumn = scores.count
        numberOfPresent = scores.count
        for item in scores{
            data.addObject(item.1)
            columnName.addObject(item.0)
        }
        eColumnChart.dataSource = self
        eColumnChart.delegate = self
        
        return eColumnChart
    }

    
    
    
    
    // Following are the helper function for EChart package
    func numberOfColumnsInEColumnChart(eColumnChart: EColumnChart!) -> Int{
        return numberOfColumn
    }
    
    func numberOfColumnsPresentedEveryTime(eColumnChart: EColumnChart!) -> Int{
        return numberOfPresent
    }
    
    
    
    func highestValueEColumnChart(eColumnChart: EColumnChart!) -> EColumnDataModel!{
        let highestData = EColumnDataModel()
        var max = data.objectAtIndex(0) as! CGFloat
        var index = 0
        for i in 1 ..< data.count{
            if max < data.objectAtIndex(i) as! CGFloat {
                max = data.objectAtIndex(i) as! CGFloat
                index = i
            }
        }

        highestData.label = "highest"
        highestData.value = Float(max)
        highestData.index = index
        highestData.unit = "#"
        return highestData
    }
    
    func eColumnChart(eColumnChart: EColumnChart!, valueForIndex index: Int) -> EColumnDataModel!{
        let result = EColumnDataModel()
        result.label = columnName.objectAtIndex(index) as! String
        result.value = Float(data.objectAtIndex(index) as! CGFloat)
        result.unit = "#"
        return result
        
    }
    
    func eColumnChart(eColumnChart: EColumnChart!, didSelectColumn eColumn: EColumn!){
        
    }
    
    func eColumnChart(eColumnChart: EColumnChart!, fingerDidEnterColumn eColumn: EColumn!){
        
    }
    
    func eColumnChart(eColumnChart: EColumnChart!, fingerDidLeaveColumn eColumn: EColumn!){
        
    }
    
    func fingerDidLeaveEColumnChart(eColumnChart: EColumnChart!){
        
    }
}
