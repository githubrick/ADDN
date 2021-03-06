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
         $type = $obj->{"type"};

//         $centreId="QLD_BNE_LCH";
//		 $consenttobecontacted = "1";
//		 $type = "TYPE_2";
         
         $Tmp = NULL;
         if($type!="Total")
         {
         	$Tmp = "AND diabetestype_value='".$type."'";
         }
         

         // build query 
         $query = "SELECT COUNT(case when (DATEDIFF(CURRENT_DATE, dateofbirth)/365 >=0.0) AND (DATEDIFF(CURRENT_DATE, dateofbirth)/365 < 5.0) " .
         		"then 1 end) AS CAR1, COUNT(case when (DATEDIFF(CURRENT_DATE, dateofbirth)/365 >=5.0) AND (DATEDIFF(CURRENT_DATE, dateofbirth)/365 < 10.0) " .
         		"then 1 end) AS CAR2,COUNT(case when (DATEDIFF(CURRENT_DATE, dateofbirth)/365 >=10.0) AND (DATEDIFF(CURRENT_DATE, dateofbirth)/365 < 15.0) " .
         		"then 1 end) AS CAR3,COUNT(case when (DATEDIFF(CURRENT_DATE, dateofbirth)/365 >=15.0) AND (DATEDIFF(CURRENT_DATE, dateofbirth)/365 < 20.0) " .
         		"then 1 end) AS CAR4, COUNT(case when (DATEDIFF(CURRENT_DATE, dateofbirth)/365 >=20.0)" .
         		"then 1 end) AS CAR5,COUNT(*) AS Number, COUNT(case when gender='MALE' then 1 end) AS Male, COUNT(case when gender='FEMALE' " .
         		"then 1 end) AS Female, COUNT(case when (insulinmanagement_regimen = 'CSII') then 1 end) AS CSII, COUNT(case when" .
         		" (insulinmanagement_regimen = 'BD_TWICE_DAILY') then 1 end) AS BD, COUNT(case when (insulinmanagement_regimen = 'MDI') then 1 end) AS MDI, " .
         		"COUNT(case when (insulinmanagement_regimen = 'OTHER') then 1 end) AS Other, COUNT(case when (insulinmanagement_regimen IS NULL) " .
         		"then 1 end) AS Nil, COUNT(case when (name = 'Metformin') then 1 end) AS Metformin, COUNT(case when (name = 'Thyroid hormone') then 1 end) AS " .
         		"Sulphonylureas, COUNT(case when (type_value = 'COELIAC_DISEASE') then 1 end) AS Coeliac, COUNT(case when (type_value = 'HYPOTHYROIDISM') then 1 end) AS" .
         		" Thyroid, ROUND(AVG(hba1c_ngsp),2) AS NGSP, ROUND(AVG(hba1c_iffc),2) AS IFFC, ROUND(AVG(bodymassindexzscore),2) AS BMI, " .
         		"ROUND(AVG(severehypoglycaemiaepisodes),2) AS HYPOS, ROUND(AVG(dkaepisodes),2) AS DKA FROM PATIENT, VISIT, MEDICATION, " .
         		"COMORBIDITY,LOCALID WHERE PATIENT.localid_id = VISIT.localid_id AND PATIENT.localid_id =  MEDICATION.localid_id AND" .
         		" PATIENT.localid_id = COMORBIDITY.localid_id AND LOCALID.id = PATIENT.localid_id AND centre = '".$centreId."'"." AND consenttobecontacted = '".$consenttobecontacted."'".$Tmp;
      
         $result = db_select($query);
        
         // echo json_encode($query);
         // return;

            
         if($result === false) {
             $error = db_error();
                // Handle error - inform administrator, log to file, show error page, etc.
            }else{
                echo json_encode($result);
            }
        


    
        mysqli_close(db_connect());
    

?>