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
        $localid_id = $obj->{"localid_id"};

         //$localid_id = "6";
         // init params
         $dateSQL = NULL;

   		 // build query Dateofbirth 
         $query_Dateofbirth = "SELECT TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) AS PBirthDate FROM patient WHERE patient.localid_id = '".$localid_id."'";
    
         // excute query Dateofbirth																																									
         $result_Dateofbirth = db_select($query_Dateofbirth);
         

         if(((int)$result_Dateofbirth[0]['PBirthDate'])>=0 
            && ((int)$result_Dateofbirth[0]['PBirthDate'])<5)
         {
         	$dateSQL = "TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=0 AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) <5";
         }
         if(((int)$result_Dateofbirth[0]['PBirthDate'])>=5
            &&((int)$result_Dateofbirth[0]['PBirthDate'])<10)
         {
         	$dateSQL = "TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=5 AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) <10";
         }
         if(((int)$result_Dateofbirth[0]['PBirthDate'])>=10
            && ((int)$result_Dateofbirth[0]['PBirthDate'])<15)
         {
         	$dateSQL = "TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=10 AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) <15";
         }
         if(((int)$result_Dateofbirth[0]['PBirthDate'])>=15
            && ((int)$result_Dateofbirth[0]['PBirthDate'])<20)
         {
         	$dateSQL = "TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=15 AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) <20";
         }
         if(((int)$result_Dateofbirth[0]['PBirthDate'])>=20)
         {
         	$dateSQL = "TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=20";
         }
         
         // build query time from dateofdiagnosis
         $query_My_time_diagnosis = "SELECT TIMESTAMPDIFF( YEAR, patient.dateofdiagnosis, NOW( ) ) AS timeDiagnosis FROM patient WHERE patient.localid_id = '".$localid_id."'";
 
    
         // excute query my time from dateofdiagnosis																																								
         $result_My_time_diagnosis = db_select($query_My_time_diagnosis);
         
         // build query MAX AND MIN time from dateofdiagnosis
         $query_dateofdiagnosis = "SELECT MAX(TIMESTAMPDIFF( YEAR, patient.dateofdiagnosis, NOW() )) AS MAXDiagnosis,
                                   MIN(TIMESTAMPDIFF( YEAR, patient.dateofdiagnosis, NOW() )) AS MINDiagnosis FROM patient WHERE ".$dateSQL;


         // excute query XAX hba1c_iffc																																									
         $result_dateofdiagnosis = db_select($query_dateofdiagnosis);
         
 		if(($result_My_time_diagnosis == false)||($result_dateofdiagnosis==false)) {
             $error = db_error();
                // Handle error - inform administrator, log to file, show error page, etc.
            }else{
            	$arrTmp = array();
            	$arrTmp[0] = $result_dateofdiagnosis[0]['MINDiagnosis'];
            	$arrTmp[1] = $result_My_time_diagnosis[0]['timeDiagnosis'];
            	$arrTmp[2] = $result_dateofdiagnosis[0]['MAXDiagnosis'];
                echo json_encode($arrTmp);
            }
        
        


    
        mysqli_close(db_connect());
    

?>
