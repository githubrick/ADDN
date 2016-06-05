//
//  ChooseAgeRange.swift
//  ADDN
//
//  Created by Jiajie Li on 24/03/2015.
//  Copyright (c) 2015 JackTraining. All rights reserved.
//

// This is a class for offering age range parameter setting


import UIKit

class ChooseAgeRange: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
//new
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var lessEqualLabel: UILabel!
    @IBOutlet var textField1: UITextField!
    
    @IBOutlet var lessLabel: UILabel!
    
    @IBOutlet var textField2: UITextField!
    
    var numberOfRanges = 1
    var textFieldArray: NSMutableArray = NSMutableArray()
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        textField1.delegate = self
        textField2.delegate = self
        textFieldArray.addObject(textField1)
        textFieldArray.addObject(textField2)
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let CAR = userDefaults.objectForKey("CAR") as! NSMutableArray
        textField1.text = CAR[0] as! String
        textField2.text = CAR[1] as! String
        numberOfRanges = CAR.count/2
        var value: String = ""
        var temp: UITextField = UITextField()
        let height = lessEqualLabel.frame.origin.y
        for (var i = 2; i < CAR.count; i++) {
            value = CAR[i] as! String
            if(i%2 == 0){
                addTextField(textField1,height: height + CGFloat(60 * (i/2)), text: value)
                addLabel(lessEqualLabel,height: height + CGFloat(60 * (i/2)), text: ">=")
            }else{
                addTextField(textField2,height: height + CGFloat(60 * (i/2)), text: value)
                addLabel(lessLabel,height: height + CGFloat(60 * (i/2)), text: "<")
            }
        } 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTextField(sourceTextField: UITextField, height: CGFloat, text: String){
        let newTextField = UITextField(frame: sourceTextField.frame)
        newTextField.frame.origin.y = height
        newTextField.textAlignment = NSTextAlignment.Center
        newTextField.font = sourceTextField.font
        newTextField.borderStyle = UITextBorderStyle.Bezel
        newTextField.text = text
        newTextField.delegate = self
        textFieldArray.addObject(newTextField)
        self.scrollView.addSubview(newTextField)
    }
    
    func addLabel(sourceLabel: UILabel, height:CGFloat, text: String){
        let newLabel = UILabel(frame: sourceLabel.frame)
        newLabel.frame.origin.y = height
        newLabel.text = text
        newLabel.shadowColor = UIColor.lightGrayColor()
        self.scrollView.addSubview(newLabel)
    }
    
    override func viewWillDisappear(animated: Bool) {
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.removeObjectForKey("CAR")
        var temp: UITextField = UITextField()
        let newCAR: NSMutableArray = NSMutableArray()
        for (var i = 0; i < textFieldArray.count; i += 1) {
            temp = textFieldArray[i] as! UITextField
            newCAR.addObject(temp.text!)
        }
        userDefaults.setObject(newCAR, forKey: "CAR")
        userDefaults.synchronize()
    }
    
    
    
    @IBAction func addRange(sender: AnyObject) {
        if(numberOfRanges < 5){
            let newLabel1 = UILabel(frame: lessEqualLabel.frame)
            newLabel1.frame.origin.y += CGFloat(60 * numberOfRanges)
            newLabel1.text = ">="
            newLabel1.shadowColor = UIColor.lightGrayColor()
            
            let newLabel2 = UILabel(frame: lessLabel.frame)
            newLabel2.frame.origin.y += CGFloat(60 * numberOfRanges)
            newLabel2.text = "<"
            newLabel2.shadowColor = UIColor.lightGrayColor()
            
            let newTextField1 = UITextField(frame: textField1.frame)
            newTextField1.frame.origin.y += CGFloat(60 * numberOfRanges)
            newTextField1.textAlignment = NSTextAlignment.Center
            newTextField1.font = textField1.font
            newTextField1.borderStyle = UITextBorderStyle.Bezel
            
            let newTextField2 = UITextField(frame: textField2.frame)
            newTextField2.frame.origin.y += CGFloat(60 * numberOfRanges)
            newTextField2.textAlignment = NSTextAlignment.Center
            newTextField2.font = textField2.font
            newTextField2.borderStyle = UITextBorderStyle.Bezel
            
            let firstLast = textFieldArray[textFieldArray.count - 1] as! UITextField
            let secondLast = textFieldArray[textFieldArray.count - 2] as! UITextField
            var a: Float = 0.0 ,b: Float  = 0.0
            a =  (firstLast.text! as NSString).floatValue
            b = (secondLast.text! as NSString).floatValue
            let range = a - b
            newTextField1.text = firstLast.text
            newTextField2.text = "\((newTextField1.text! as NSString).floatValue + range)"
            
            newTextField1.delegate = self
            newTextField2.delegate = self
            
            textFieldArray.addObject(newTextField1)
            textFieldArray.addObject(newTextField2)
            
            self.scrollView.addSubview(newLabel1)
            self.scrollView.addSubview(newLabel2)
            self.scrollView.addSubview(newTextField1)
            self.scrollView.addSubview(newTextField2)
            numberOfRanges += 1
        }else{
            let message:UIAlertView = UIAlertView(title: "Illegal Operation", message: "Maximum Number of Segment is 5", delegate: self,cancelButtonTitle: "OK")
            message.show()
        }
    }
    

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if(textField.text == ""){
            let warning: UIAlertView = UIAlertView(title: "Missing Value", message: "The value cannot be empty", delegate: self, cancelButtonTitle: "Ok")
            warning.show()
            for i in 0..<textFieldArray.count{
                if(textField == (textFieldArray[i] as! UITextField)){
                    textField.text = "\((((textFieldArray[i-1] as! UITextField).text! as NSString).floatValue + 1.0))"
                }
            }
            return false
        }
        return checkTextFieldArray()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(ChooseAgeRange.keyboardOnScreen(_:)), name: UIKeyboardDidShowNotification, object: nil)
        center.addObserver(self, selector: #selector(ChooseAgeRange.keyboardOffScreen(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
    }
    
    func keyboardOnScreen(notification: NSNotification){
        let info: NSDictionary  = notification.userInfo!
        let kbSize = info.valueForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue().size
        
        let contentInsets:UIEdgeInsets  = UIEdgeInsetsMake(0.0, 0.0, kbSize!.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var aRect: CGRect = self.view.frame
        aRect.size.height -= kbSize!.height
        //you may not need to scroll, see if the active field is already visible
        
        if (!CGRectContainsPoint(aRect, activeField!.frame.origin) ) {
            let scrollPoint:CGPoint = CGPointMake(0.0, activeField!.frame.origin.y - kbSize!.height)
            scrollView.setContentOffset(scrollPoint, animated: true)
        }

    }
    
    
    func keyboardOffScreen(notification: NSNotification){
        scrollView.setContentOffset(CGPoint(x: 0,y: 0),animated:true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        activeField = nil
    }
    
    func checkTextFieldArray() -> Bool{
        
        for  i in 0..<textFieldArray.count / 2{
            let temp1 = (textFieldArray[2 * i] as! UITextField).text! as NSString
            let temp2 = (textFieldArray[2 * i + 1] as! UITextField).text! as NSString
            let a:Float = temp1.floatValue
            var b: Float = temp2.floatValue
            if(a > b){
                let message = "Text Field " + "\(2 * i + 2)" + " is smaller than its former counter part"
                let msg: UIAlertView = UIAlertView(title: "Increct Data Range", message: message, delegate: self, cancelButtonTitle: "Ok")
                msg.show()
                b = a + 1.0
                (textFieldArray[2 * i + 1] as! UITextField).text = "\(b)"
                return false
            }
        }
        return true
    }
    

    
}
