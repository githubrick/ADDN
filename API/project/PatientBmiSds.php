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

//         $localid_id = "269";
         // init params
         $dateSQL = NULL;

   		 // build query Dateofbirth 
         $query_Dateofbirth = "SELECT TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) AS PBirthDate FROM patient WHERE patient.localid_id = '".$localid_id."'";
    
         // excute query Dateofbirth																																									
         $result_Dateofbirth = db_select($query_Dateofbirth);
         
         
         $judge = (int)$result_Dateofbirth[0]['PBirthDate'];
         if(0<= $judge && $judge<5) {
            $dateSQL = "TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=0 AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) <5";
         }else if(5<=$judge && $judge<10){
            $dateSQL = "TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=5 AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) <10";
         }else if(10<=$judge && $judge<15){
            $dateSQL = "TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=10 AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) <15";
         }else if(15<=$judge && $judge<20){
            $dateSQL = "TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=15 AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) <20";
         }else if(20<=$judge){
            $dateSQL = "TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=20";
         }
         
         // build query my latest bodymassindexzscore
         $query_My_bodymassindexzscore = "SELECT visit.bodymassindexzscore FROM visit WHERE visit.localid_id = '".$localid_id."'"."ORDER BY visit.dateofvisit DESC LIMIT 0,1";
    
         // excute query my latest bodymassindexzscore																																									
         $result_My_bodymassindexzscore = db_select($query_My_bodymassindexzscore);
         
         // build query MAX AND MIN bodymassindexzscore
         $query_bodymassindexzscore = "SELECT MAX(visit.bodymassindexzscore) AS MAXHBA1C,MIN(visit.bodymassindexzscore) AS MINHBA1C FROM visit JOIN patient ON patient.localid_id=visit.localid_id WHERE ".$dateSQL;
    
         // excute query XAX bodymassindexzscore																																									
         $result_bodymassindexzscore = db_select($query_bodymassindexzscore);
         
         
 		if(($result_Dateofbirth == false)||($result_My_bodymassindexzscore == false)||($result_bodymassindexzscore == false)) {
                $error = db_error();
                $arrTmp = array();
                $arrTmp[0] = "No Visit Records";
                echo json_encode($arrTmp);
                // Handle error - inform administrator, log to file, show error page, etc.
            }else{
            	$arrTmp = array();
            	$arrTmp[0] = $result_bodymassindexzscore[0]['MINHBA1C'];
        		$arrTmp[1] = $result_My_bodymassindexzscore[0]['bodymassindexzscore'];
        		$arrTmp[2] = $result_bodymassindexzscore[0]['MAXHBA1C'];
                echo json_encode($arrTmp);
            }
        
        


    
        mysqli_close(db_connect());
    

?>
