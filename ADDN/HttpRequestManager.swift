//
//  HttpRequestManager.swift
//  ADDN
//
//  Created by Bo Li on 22/5/16.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

let IP = "http://localhost/"
//let IP = "http://192.168.1.110/"
//let QueryServiceAPI = IP+"project/serviceV2.php"

//--------------getConcernedPatient API ---------------
let GetConcernedPatientAPI = IP+"project/getConcernedPatient.php"
//--------------------------Account API-------------------------
// login
let LoginAPI = IP+"project/login.php"
// sign up
let SignUpAPI = IP+"project/signUp.php"
// log out 
let LogoutAPI = IP+"project/signOut.php"
//---------------------------Notification API ------------------
let NotificationAPI = IP+"project/Notification.php"

//--------------------------centre reports-------------------------
// Centre Report  Diabetes Type
let QueryCentreDiseaseTypeReportAPI = IP+"project/centreDiseaseTypeReport.php"
// Centre Report Insulin Regimen
let QueryCentreInsulinRegimenReportAPI = IP+"project/centreInsulinRegimenReport.php"
// Centre Report HbA1c
let QueryCentreHbA1cReportAPI = IP+"project/centreHbA1cReport.php"

// Centre Report BMI SDS
let QueryCentreBmiSdsReportAPI = IP+"project/centreBmiSdsReport.php"

//-----------------Centre Dashboard --------------------------------
// API for Dashboard  center summary
let CentreSummaryAPI = IP+"project/centreSummary.php"
//-----------------------------------centre comparision------------
// API for Centre Report
let CentreReportAPI = IP+"project/centreReport.php"

// API for Centre Age Comparision
let CentreAgeComparisionAPI = IP+"project/centreAgeComparision.php"

// API for Centre Regimen Comparision
let CentreRegimenComparisionAPI = IP+"project/centreRegimen.php"

// API for Centre DiabetesType Comparision
let CentreDiabetesTypeComparisionAPI = IP+"project/centreDiabetesType.php"

// API for Centre BMI SDS Comparision
let CentreBMISDSComparisionAPI = IP+"project/centreBMISDS.php"

// API for Centre HbA1c IFFC Comparision
let CentreHbA1cIFFCComparisionAPI = IP+"project/centreHbA1cIffc.php"
// API for Centre HbA1c IFFC Comparision
let CentreHbA1cNGSPComparisionAPI = IP+"project/centreHbA1cNgsp.php"

// API for Centre Severe Hypo comparision
let CentreSevereHypoComparisionAPI = IP+"project/centreSevereHypo.php"
// API for Centre DKA comparision
let CentreDKAComparisionAPI = IP+"project/centreDKA.php"

//-----------------------------patient comparision------------

// API for Patient Search
let PatientSearchAPI = IP+"project/PatientSearch.php"
// API for Patient HbA1c IFFC Comparision
let PatientHbA1cIFFCComparisionAPI = IP+"project/PatientHbA1cIffc.php"
// API for Patient HbA1c IFFC Comparision
let PatientHbA1cNGSPComparisionAPI = IP+"project/PatientHbA1cNgsp.php"
// API for Patient  BMI SDS Comparision
let PatientBmiSdsComparisionAPI = IP+"project/PatientBmiSds.php"
// API for Patient Diabetes Duration Comparision
let PatientDiabetesDurationComparisionAPI = IP+"project/PatientDiabetesDuration.php"


class HttpRequestManager{

    static let sharedManager = HttpRequestManager()
    private init(){ }
    
    // post request...
    func PostHttpRequest(requestUrl:String, parameters:Dictionary<String,AnyObject>,completionHandler:(Response<AnyObject,NSError>) -> ()){
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 60*10 // 5 min
        
        SVProgressHUD.showWithStatus("Loading...")
                Alamofire.Manager.sharedInstance.request(.POST, requestUrl, parameters: parameters, encoding: .JSON, headers:[:])
                .responseJSON{ response in
                    print("request body......")
                    print(NSString(data: (response.request!.HTTPBody)!, encoding: NSUTF8StringEncoding))
                    switch response.result {
                    case .Success:
                        SVProgressHUD.dismiss()
                        completionHandler(response)
                    case .Failure:
                        SVProgressHUD.showErrorWithStatus(response.result.error?.localizedDescription)
                        
                    }
                    
        }

        
        }
    
}
