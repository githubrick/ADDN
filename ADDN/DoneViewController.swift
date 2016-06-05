//
//  DoneViewController.swift
//  ADDN
//
//  Created by Jiajie Li on 31/03/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//

// This class it used to display the result of centre report. After user selected all the parameters and 
// press the done button in that the centre report no matter which centre report view
// it would all segue to this view and see the detailed result for that report.
// This class also provide result
// in table representation, bar chart representation, pie chart representation. It provides 
// 3 buttons to switch to different kinds of representation.
//

import UIKit

class DoneViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SideBarDelegate {

    @IBOutlet var tableView: UITableView!
    
    var pieScrollview:UIScrollView = UIScrollView()
    var barScrollview:UIScrollView = UIScrollView()
    
    @IBOutlet var barChartButton: UIButton!
    
    @IBOutlet var tableButton: UIButton!
    
    @IBOutlet var pieChartButton: UIButton!
    
    
    var rowsOfTable: Array<(key:String, array:Array<String>)>!
    var columnsOfTable: Array<String>!
    var answers:Dictionary<String, Array<(key:String, array: Array<String>)>>!
    var columnSelected:Int = 0
    var sidebar = SideBar()
    var headerView: UIView = UIView()
    var titleOfTable:UILabel = UILabel()
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        pieScrollview.delegate = self
        pieScrollview.scrollEnabled = true
        self.tableView.reloadData()
        if(columnsOfTable != nil){
            sidebar = SideBar(sourceView: self.view, menuItems: columnsOfTable)
        }
        sidebar.delegate = self
        
        headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 50)
        headerView.backgroundColor = UIColor.clearColor()
        titleOfTable = UILabel(frame:headerView.frame)
        titleOfTable.text = columnsOfTable[columnSelected]
        titleOfTable.textAlignment = NSTextAlignment.Center
        self.tableView.tableHeaderView = headerView
        headerView.addSubview(titleOfTable)
     
        barChartButton.tintColor = UIColor.grayColor()
        pieChartButton.tintColor = UIColor.grayColor()
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return rowsOfTable.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return rowsOfTable[section].array.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        cell.textLabel!.text = rowsOfTable[indexPath.section].array[indexPath.row]
        if(cell.viewWithTag(1) == nil){
            
            let oneLabel:UILabel = UILabel(frame: CGRectMake(cell.frame.size.width - 130, 0, 100, cell.frame.size.height))
            oneLabel.font = cell.textLabel!.font
            oneLabel.textAlignment = NSTextAlignment.Right
            oneLabel.textColor = UIColor.lightGrayColor()
            oneLabel.text = (answers[columnsOfTable[columnSelected]] as Array<(key:String, array:Array<String>)>!)[indexPath.section].array[indexPath.row]
            oneLabel.tag = 1
            cell!.contentView.addSubview(oneLabel)
        }else{
            let label:UILabel = cell.viewWithTag(1) as! UILabel
            label.text = (answers[columnsOfTable[columnSelected]] as Array<(key:String, array:Array<String>)>!)[indexPath.section].array[indexPath.row]
        }
        return cell
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return rowsOfTable[section].key
    }

    func sideBarDidSelectButtonAtIndex(index: Int) {
        columnSelected = index;
        titleOfTable.text = columnsOfTable[columnSelected]
        if(barChartButton.tintColor != UIColor.grayColor()){
            pressBarChartButton(self)
        }else if(pieChartButton.tintColor != UIColor.grayColor()){
            pressPieChartButton(self)
        }else{
            self.tableView.reloadData();
        }
    }
    
    @IBAction func pressTableButton(sender: AnyObject) {
        tableButton.tintColor =  self.view.tintColor
        barChartButton.tintColor = UIColor.grayColor()
        pieChartButton.tintColor = UIColor.grayColor()
        
        pieScrollview.removeFromSuperview()
        barScrollview.removeFromSuperview()
        self.view.insertSubview(tableView, atIndex: 0)
    }

    
    @IBAction func pressBarChartButton(sender: AnyObject) {
        tableButton.tintColor =  UIColor.grayColor()
        barChartButton.tintColor = self.view.tintColor
        pieChartButton.tintColor = UIColor.grayColor()
        
        self.tableView.removeFromSuperview()
        self.pieScrollview.removeFromSuperview()
        
        // Remove a the subviews add by the previous barscrollview
        for view in barScrollview.subviews {
            view.removeFromSuperview()
        }
        
        barScrollview.frame = CGRectMake(0, 108,UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        
        barScrollview.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height + 200)
        
        //Start pixel height
        var pointer:CGFloat = 0
        
        let title = UILabel(frame: CGRectMake(0, pointer, UIScreen.mainScreen().bounds.width, 60))
        title.text =  columnsOfTable[columnSelected]
        title.textAlignment = NSTextAlignment.Center
        barScrollview.addSubview(title)
        
        pointer += 60
        
        let chartDistances:CGFloat = 60
        
        let displayInfo = answers[columnsOfTable[columnSelected]] as Array<(key:String, array:Array<String>)>!
        
        for i in 0 ..< displayInfo.count{
            if(displayInfo[i].array.count == 1){
                pointer = displayTitle(rowsOfTable[i].array[0], detail: displayInfo[i].array[0], start: pointer,theView: barScrollview)
                
            }
        } 
        
        pointer = pointer + chartDistances
        for i in 0 ..< displayInfo.count{
            if(displayInfo[i].array.count > 1){
                let dic:NSMutableDictionary =  NSMutableDictionary()
                for j in 0 ..< displayInfo[i].array.count{
                    dic.setObject(displayInfo[i].array[j], forKey: rowsOfTable[i].array[j])
                }
                var newdic:Dictionary<String, CGFloat> = Dictionary()
                for item in dic{
                    if(item.value as! String == "-" || item.value as! String == "0" || item.value as! String == "0%"){
                        continue
                    }
                    newdic[item.key as! String] = CGFloat(((item.value as! NSString).floatValue))
                }
                if(newdic.count != 0){
                    let title = "Partition of " + rowsOfTable[i].key
                    pointer = displayTitle(title, detail:"", start:pointer,theView: barScrollview)
                    pointer = displayBarChart(newdic,start:pointer)
                    pointer = pointer + chartDistances
                }
                if(pointer >= barScrollview.contentSize.height){
                    barScrollview.contentSize.height =  barScrollview.contentSize.height + chartDistances
                }
            }
        }
        barScrollview.contentSize.height =  barScrollview.contentSize.height + chartDistances * 2
        self.view.insertSubview(barScrollview, atIndex: 0)
    }
    

    @IBAction func pressPieChartButton(sender: AnyObject) {
        tableButton.tintColor =  UIColor.grayColor()
        barChartButton.tintColor = UIColor.grayColor()
        pieChartButton.tintColor = self.view.tintColor
        
        self.tableView.removeFromSuperview()
        self.barScrollview.removeFromSuperview()
       
        // Remove a the subviews add by the previous piescrollview
        for view in pieScrollview.subviews {
            view.removeFromSuperview()
        }

        pieScrollview.frame = CGRectMake(0, 108,UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        
        pieScrollview.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height + 200)
        
        
        //Start pixel height
        var pointer:CGFloat = 0
        
        let title = UILabel(frame: CGRectMake(0, pointer, UIScreen.mainScreen().bounds.width, 60))
        title.text =  columnsOfTable[columnSelected]
        title.textAlignment = NSTextAlignment.Center
        pieScrollview.addSubview(title)
        
        pointer += 60

        let chartDistances:CGFloat = 60
        
        let displayInfo = answers[columnsOfTable[columnSelected]] as Array<(key:String, array:Array<String>)>!
        
        // Remember you also got-----> rowsOfTable: Array<(key:String, array:Array<String>)>!
        
        for i in 0 ..< displayInfo.count{
            if(displayInfo[i].array.count == 1){
                pointer = displayTitle(rowsOfTable[i].array[0], detail: displayInfo[i].array[0], start: pointer,theView: pieScrollview)
                
            }
        }
        
        pointer = pointer + chartDistances
        for i in 0 ..< displayInfo.count{
            if(displayInfo[i].array.count > 1){
                let dic:NSMutableDictionary =  NSMutableDictionary()
                for j in 0 ..< displayInfo[i].array.count{
                    dic.setObject(displayInfo[i].array[j], forKey: rowsOfTable[i].array[j])
                }
                var newdic:Dictionary<String, CGFloat> = Dictionary()
                for item in dic{
                    if(item.value as! String == "-" || item.value as! String == "0" || item.value as! String == "0%"){
                        continue
                    }
                    newdic[item.key as! String] = CGFloat(((item.value as! NSString).floatValue))
                }
                if(newdic.count != 0){
                    let title = "Partition of " + rowsOfTable[i].key
                    pointer = displayTitle(title, detail:"", start:pointer,theView: pieScrollview)
                    pointer = displayPieChart(newdic,start:pointer)
                    pointer = pointer + chartDistances
                }
                if(pointer >= pieScrollview.contentSize.height){
                    pieScrollview.contentSize.height =  pieScrollview.contentSize.height + chartDistances
                }
            }
        }
        pieScrollview.contentSize.height =  pieScrollview.contentSize.height + chartDistances * 2
        self.view.insertSubview(pieScrollview, atIndex: 0)
    }
    
    
    func displayTitle(title:String, detail:String, start:CGFloat, theView: UIScrollView)->CGFloat{
       var pointer = start
       let titleHight:CGFloat = 30
        
        let label1 = UILabel(frame: CGRectMake(10, pointer, UIScreen.mainScreen().bounds.width, titleHight))
        
        // Just ask for a title for the graph not the one line data
        if(detail != "") {
            label1.text = title + ":"
            label1.textAlignment = NSTextAlignment.Left
        }else{
            label1.text = title
            label1.textAlignment = NSTextAlignment.Center
        }
        let label2 = UILabel(frame: CGRectMake(10, pointer, UIScreen.mainScreen().bounds.width - 30, titleHight))
        label2.text = detail
        label2.textAlignment = NSTextAlignment.Right
        label2.textColor = UIColor.grayColor()
        
        theView.addSubview(label1)
        theView.addSubview(label2)
        
       pointer = pointer + titleHight
        if(pointer >= theView.contentSize.height){
            theView.contentSize.height =  theView.contentSize.height + titleHight
        }
       return pointer
    }
    
    func displayPieChart(content:Dictionary<String,CGFloat>,start:CGFloat)->CGFloat{
        
        var pointer = start
        let pieChartGenerator = GeneratePieChart()
        let pieChart:UIView =  pieChartGenerator.drawPieChart(content)
        
        let chartHeight = pieChart.frame.height
        
        pieChart.frame.origin.y = start
        
        pointer = pointer + pieChart.frame.height
        if(pointer >= pieScrollview.contentSize.height){
            pieScrollview.contentSize.height =  pieScrollview.contentSize.height + chartHeight
        }
        pieScrollview.addSubview(pieChart)
        
        return pointer
    }
    
    func displayBarChart(content:Dictionary<String,CGFloat>,start:CGFloat)->CGFloat{
        var pointer = start
        let barChartGenerator = GenerateBarChart()
        let barChart = barChartGenerator.drawBarChart(content)
        
        let chartHeight = barChart.frame.height
        barChart.frame.origin.y = start
        
        pointer = pointer + barChart.frame.height
        if(pointer > barScrollview.contentSize.height){
            barScrollview.contentSize.height =  barScrollview.contentSize.height + chartHeight
        }
        barScrollview.addSubview(barChart)
        return pointer
        
    }
    
}
