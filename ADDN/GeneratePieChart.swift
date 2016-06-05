//
//  GeneratePieChart.swift
//  ADDN
//
//  Created by Jiajie Li on 21/04/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//

// This is a class used to return a pie chart view based on the input data.

import UIKit



class GeneratePieChart: NSObject {
   
    var container:UIView = UIView()
    
    let pi: CGFloat = 3.1415926535
    let screenWidth:CGFloat = UIScreen.mainScreen().bounds.width
    let radius: CGFloat = CGFloat(UIScreen.mainScreen().bounds.width * 0.43)
    
    func drawPieChart(scores:Dictionary<String,CGFloat>)->UIView{
     
        container.frame = CGRectMake(0, 0, screenWidth, screenWidth + CGFloat(20 * ((scores.count-1)/3 + 1)) - 30)
        container.backgroundColor = UIColor.clearColor()
        let numberOfPies = scores.count
        
        var totalScore:CGFloat = 0.0
        for score in scores.values{
            totalScore = totalScore + score
        }
       
        var currentAngle: CGFloat = 0
        let center: CGPoint = CGPoint(x: screenWidth / 2.0, y: radius)
        
        var i = 0; 
        for score in scores {
            
            let slice = UIView()
            slice.frame = container.frame
            let shapeLayer = CAShapeLayer()
            let scoreIndex = i
            let sliceRad = score.1 / totalScore * 2 * pi
            
            // Draw the path
            let path:UIBezierPath = UIBezierPath()
            
            path.moveToPoint(center)
            path.addLineToPoint(CGPoint(x: center.x + radius * cos(currentAngle), y: center.y + radius * sin(currentAngle)))
            path.addArcWithCenter(center, radius: radius, startAngle: currentAngle, endAngle: currentAngle + sliceRad, clockwise: true)
            path.addLineToPoint(center)
            path.closePath()
            
            // For next slice, add 2*pi Rad / n categories
            currentAngle += sliceRad
            
            // Add path to shapeLayer
            shapeLayer.path = path.CGPath
            //shapeLayer.frame = self.frame
            let filledColor = (ChartColors.colorFromHex(ChartColors.colors[scoreIndex%13])).CGColor
            shapeLayer.fillColor = filledColor
            shapeLayer.anchorPoint = center
            
            // Add shapeLayer to sliceView
            slice.layer.addSublayer(shapeLayer)
            
            let tab:UILabel = UILabel(frame: CGRectMake(CGFloat(i%3 * 110),screenWidth + CGFloat((i/3) * 20 - 30), 100 , 20))
            tab.textAlignment = NSTextAlignment.Center
            tab.text = score.0
            tab.textColor = (ChartColors.colorFromHex(ChartColors.colors[scoreIndex%13]))
            
            container.addSubview(tab)
          
            container.addSubview(slice)
            i = i + 1
        }
  
        
        return container
    }
    
    


}

