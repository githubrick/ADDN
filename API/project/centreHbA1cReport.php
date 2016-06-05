<?php
    
/* 
    Name: Bo Li 
    Student Number: 630713
    Distributed Computing Project
    IPhone Application of Australian Diabetes Data Network
*/

// This script is used for handling the database quering, e.g. information retrieval.

        function db_connect() {
            
            // Define connection as a static variable, to avoid connecting more than once
            static $connection;
            // Try and connect to the database, if a connection has not been established yet
            if(!isset($connection)) {
                // Load configuration as an array. Use the actual location of your configuration file
                // Put the configuration file outside of the document root
                $config = parse_ini_file('config.ini');
                $connection = mysqli_connect('localhost',$config['username'],$config['password'],$config['dbname']);
            }
            // If connection was not successful, handle the error
            if($connection === false) {
                // Handle error - notify administrator, log to a file, show an error screen, etc.
                return mysqli_connect_error();
            }
            return $connection;
        }
        /**
         * Query the database
         *
         * @param $query The query string
         * @return mixed The result of the mysqli::query() function
         */
        function db_query($query) {
            // Connect to the database
            $connection = db_connect();
            // Query the database
            $result = mysqli_query($connection,$query);
            return $result;
        }
        /**
         * Fetch rows from the database (SELECT query)
         *
         * @param $query The query string
         * @return bool False on failure / array Database rows on success
         */
        function db_select($query) {
            $rows = array();
            $result = db_query($query);
            // If query failed, return `false`
            if($result === false) {
                return false;
            }
            // If query was successful, retrieve all the rows into an array
            while ($row = mysqli_fetch_assoc($result)) {
                $rows[] = $row;
            }
            return $rows;
        }
        /**
         * Fetch the last error from the database
         *
         * @return string Database error message
         */
        function db_error() {
            $connection = db_connect();
            return mysqli_error($connection);
        }
        /**
         * Quote and escape value for use in a database query
         *
         * @param string $value The value to be quoted and escaped
         * @return string The quoted and escaped string
         */
        function db_quote($value) {
            $connection = db_connect();
            return "'" . mysqli_real_escape_string($connection,$value) . "'";
        }
    
        //header('Content-Type: application/json');
        //parse json parameters 
         $requestParams = file_get_contents('php://input');
         $obj = json_decode($requestParams);
         $centreId = $obj->{"centreId"};
         $consenttobecontacted = $obj->{"consenttobecontacted"}; 
         $diabetesType = $obj->{"diabetesType"};        
         $duration = $obj->{"duration"};
         $ageRange = $obj->{"ageRange"};
         $method = $obj->{"method"};
         $hba1cType = $obj->{"hba1cType"};
         $hba1cTypeRange = $obj->{"hba1cTypeRange"};
         
//     
         
         $tmp1 = NULL;
         $tmp2 = NULL;
         if($method=="COUNT")
         {
         	$tmp1 = "round(COUNT";
         	$tmp2 = "1";
         }
         else
         {
         	$tmp1 = "round(AVG";
         	$tmp2 = $hba1cType;
         }
         
         $tmpDuration = NULL;
         for($index=0;$index<count($duration);$index+=2)
         {
         	  $tmpDuration .= $tmp1."(case when (DATEDIFF(CURRENT_DATE, PATIENT.dateofdiagnosis)/365 >='".$duration[$index]."') AND (DATEDIFF(CURRENT_DATE, PATIENT.dateofdiagnosis)/365 < '".$duration[$index+1]."') then ".$tmp2." end),2) AS DD".(($index+2)/2).",";
         }
         
         
         $tmpAgeRange = NULL;
         for($index=0;$index<count($ageRange);$index+=2)
         {
         	  $tmpAgeRange .= $tmp1."(case when (DATEDIFF(CURRENT_DATE, dateofbirth)/365 >='".$ageRange[$index]."') AND (DATEDIFF(CURRENT_DATE, dateofbirth)/365 < '".$ageRange[$index+1]."') then ".$tmp2." end),2) AS CAR".(($index+2)/2).",";
         }
         
         $tmpHba1cTypeRange = NULL;

        if(count($tmpHba1cTypeRange) == 2)
        {
        	$tmpHba1cTypeRange = "AND ".$tmp2.">='".$hba1cTypeRange[$index]."'AND ".$tmp2."<'".$hba1cTypeRange[$index]."'";
        }


         

         //return;
//         $centreId="QLD_BNE_LCH";
//		 $consenttobecontacted = "1";
//		 $type = "TYPE_2";
         
         

         // build query 
         $query = "SELECT ".$tmpAgeRange.$tmpDuration.$tmp1."(".$hba1cType."),2) AS Total, " .
         		$tmp1."(case when gender='Male' then ".$tmp2." end),2) AS Male, ".$tmp1."(case when gender='Female' then ".$tmp2." end),2) AS Female,"
         		.$tmp1."(case when (insulinmanagement_regimen = 'CSII') then ".$tmp2." end),2) AS CSII, ".$tmp1."(case when (insulinmanagement_regimen = 'BD_TWICE_DAILY') then ".$tmp2." end),2) AS BD, "
         		.$tmp1."(case when (insulinmanagement_regimen = 'MDI') then ".$tmp2." end),2) AS MDI, " .
         		$tmp1."(case when (insulinmanagement_regimen = 'OTHER') then ".$tmp2." end),2) AS Other, ".$tmp1."(case when (insulinmanagement_regimen IS NULL) then ".$tmp2." end),2) AS Nil,"
                .$tmp1."(case when (type_value = 'COELIAC_DISEASE') then 1 end),2) AS Coeliac FROM PATIENT, VISIT, COMORBIDITY,localid WHERE " .
         		"PATIENT.localid_id = VISIT.localid_id AND PATIENT.localid_id = COMORBIDITY.localid_id AND PATIENT.localid_id = localid.id AND centre = '".$centreId."' AND " .
         		"consenttobecontacted = '".$consenttobecontacted."' AND diabetestype_value = '".$diabetesType."'".$tmpHba1cTypeRange;
      
          //echo json_encode($query);
          //return;

//      
         $result = db_select($query);
           
            
         if($result === false) {
             $error = db_error();
                // Handle error - inform administrator, log to file, show error page, etc.
            }else{
                echo json_encode($result);
            }
        


    
        mysqli_close(db_connect());
    

?>