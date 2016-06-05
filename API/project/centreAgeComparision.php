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

//         $centreId = "WA_PER_PMH"; 
         // build query MAX 
         $query_MAX_0_5 = "SELECT MAX(PersonCnt) AS MAX_0_5
												FROM (
													
													SELECT COUNT( patient.localid_id ) AS PersonCnt, localid.centre
													FROM patient
													JOIN localid ON patient.localid_id = localid.id
													WHERE TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=0 AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) )<5
                                                    AND localid.centre != '".$centreId."'
													GROUP BY localid.centre
													)a";
	      $query_MAX_5_10 = "SELECT MAX(PersonCnt) AS MAX_5_10
												FROM (
													
													SELECT COUNT( patient.localid_id ) AS PersonCnt, localid.centre
													FROM patient
													JOIN localid ON patient.localid_id = localid.id
													WHERE TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=5 AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) )<10
                                                    AND localid.centre != '".$centreId."'
													GROUP BY localid.centre
													)a";
		
	      $query_MAX_10_15 = "SELECT MAX(PersonCnt) AS MAX_10_15
												FROM (
													
													SELECT COUNT( patient.localid_id ) AS PersonCnt, localid.centre
													FROM patient
													JOIN localid ON patient.localid_id = localid.id
													WHERE TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=10 AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) )<15
                                                    AND localid.centre != '".$centreId."'
													GROUP BY localid.centre
													)a";
	      $query_MAX_15_20 = "SELECT MAX(PersonCnt) AS MAX_15_20
												FROM (
													
													SELECT COUNT( patient.localid_id ) AS PersonCnt, localid.centre
													FROM patient
													JOIN localid ON patient.localid_id = localid.id
													WHERE TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=15 AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) )<20
                                                    AND localid.centre != '".$centreId."'
													GROUP BY localid.centre
													)a";
	      $query_MAX_20_ = "SELECT MAX(PersonCnt) AS MAX_20_
												FROM (
													
													SELECT COUNT( patient.localid_id ) AS PersonCnt, localid.centre
													FROM patient
													JOIN localid ON patient.localid_id = localid.id
													WHERE TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=20
                                                    AND localid.centre != '".$centreId."'
													GROUP BY localid.centre
													)a";		
	     
	     // build query MIN 
         $query_MIN_0_5 = "SELECT MIN(PersonCnt) AS MIN_0_5
												FROM (
													
													SELECT COUNT( patient.localid_id ) AS PersonCnt, localid.centre
													FROM patient
													JOIN localid ON patient.localid_id = localid.id
													WHERE TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=0 AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) )<5
                                                    AND localid.centre != '".$centreId."'
													GROUP BY localid.centre
													)a";
	      $query_MIN_5_10 = "SELECT MIN(PersonCnt) AS MIN_5_10
												FROM (
													
													SELECT COUNT( patient.localid_id ) AS PersonCnt, localid.centre
													FROM patient
													JOIN localid ON patient.localid_id = localid.id
													WHERE TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=5 AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) )<10
                                                    AND localid.centre != '".$centreId."'
													GROUP BY localid.centre
													)a";
		
	      $query_MIN_10_15 = "SELECT MIN(PersonCnt) AS MIN_10_15
												FROM (
													
													SELECT COUNT( patient.localid_id ) AS PersonCnt, localid.centre
													FROM patient
													JOIN localid ON patient.localid_id = localid.id
													WHERE TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=10 AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) )<15
                                                    AND localid.centre != '".$centreId."'
													GROUP BY localid.centre
													)a";
	      $query_MIN_15_20 = "SELECT MIN(PersonCnt) AS MIN_15_20
												FROM (
													
													SELECT COUNT( patient.localid_id ) AS PersonCnt, localid.centre
													FROM patient
													JOIN localid ON patient.localid_id = localid.id
													WHERE TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=15 AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) )<20
                                                    AND localid.centre != '".$centreId."'
													GROUP BY localid.centre
													)a";
	      $query_MIN_20_ = "SELECT MIN(PersonCnt) AS MIN_20_
												FROM (
													
													SELECT COUNT( patient.localid_id ) AS PersonCnt, localid.centre
													FROM patient
													JOIN localid ON patient.localid_id = localid.id
													WHERE TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=20 
                                                    AND localid.centre != '".$centreId."'
													GROUP BY localid.centre
													)a";	
													
		 // build query MY 
         $query_MY_0_5 = "SELECT COUNT( patient.localid_id ) AS MY_0_5
							FROM patient
							JOIN localid ON patient.localid_id = localid.id
							WHERE TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=0
							AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) <5
							AND localid.centre ='".$centreId."'";	
         $query_MY_5_10 = "SELECT COUNT( patient.localid_id ) AS MY_5_10
							FROM patient
							JOIN localid ON patient.localid_id = localid.id
							WHERE TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=5
							AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) <10
							AND localid.centre ='".$centreId."'";	
		
         $query_MY_10_15 = "SELECT COUNT( patient.localid_id ) AS MY_10_15
							FROM patient
							JOIN localid ON patient.localid_id = localid.id
							WHERE TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=10
							AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) <15
							AND localid.centre ='".$centreId."'";	
         $query_MY_15_20 = "SELECT COUNT( patient.localid_id ) AS MY_15_20
							FROM patient
							JOIN localid ON patient.localid_id = localid.id
							WHERE TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=15
							AND TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) <20
							AND localid.centre ='".$centreId."'";	
         $query_MY_20_ = "SELECT COUNT( patient.localid_id ) AS MY_20_
							FROM patient
							JOIN localid ON patient.localid_id = localid.id
							WHERE TIMESTAMPDIFF( YEAR, patient.dateofbirth, NOW( ) ) >=20
							AND localid.centre ='".$centreId."'";	
		 		
		  	
		 
		 // excute query MAX 																																											
         $result_MAX_0_5 = db_select($query_MAX_0_5);
 		 $result_MAX_5_10 = db_select($query_MAX_5_10);
 		 $result_MAX_10_15 = db_select($query_MAX_10_15);
 		 $result_MAX_15_20 = db_select($query_MAX_15_20);
 		 $result_MAX_20_ = db_select($query_MAX_20_);
 		 
 		 // excute query MIN																																											
         $result_MIN_0_5 = db_select($query_MIN_0_5);
 		 $result_MIN_5_10 = db_select($query_MIN_5_10);
 		 $result_MIN_10_15 = db_select($query_MIN_10_15);
 		 $result_MIN_15_20 = db_select($query_MIN_15_20);
 		 $result_MIN_20_ = db_select($query_MIN_20_);
 	     
 	     // excute query MY	
 	     $result_MY_0_5 = db_select($query_MY_0_5);
 		 $result_MY_5_10 = db_select($query_MY_5_10);
 		 $result_MY_10_15 = db_select($query_MY_10_15);
 		 $result_MY_15_20 = db_select($query_MY_15_20);
 		 $result_MY_20_ = db_select($query_MY_20_);
 		 
 		 // cal MAX
 	     $result_MAX = 0;
 	     
 	     if(((int)$result_MAX_0_5[0]['MAX_0_5']) > $result_MAX)
 	     {
 	     	$result_MAX = (int)$result_MAX_0_5[0]['MAX_0_5'];
 	     }
 	     if(((int)$result_MAX_5_10[0]['MAX_5_10']) > $result_MAX)
 	     {
 	     	$result_MAX = (int)$result_MAX_5_10[0]['MAX_5_10'];
 	     }if((int)$result_MAX_10_15[0]['MAX_10_15'] > $result_MAX)
 	     {
 	     	$result_MAX = (int)$result_MAX_10_15[0]['MAX_10_15'];
 	     }if((int)$result_MAX_15_20[0]['MAX_15_20'] > $result_MAX)
 	     {
 	     	$result_MAX = (int)$result_MAX_15_20[0]['MAX_15_20'];
 	     }if((int)$result_MAX_20_[0]['MAX_20_'] > $result_MAX)
 	     {
 	     	$result_MAX = (int)$result_MAX_20_[0]['MAX_20_'];
 	     }
 	     
 	     // cal MIN
 	     $result_MIN = 0;
 	     if((int)$result_MIN_0_5[0]['MIN_0_5'] < $result_MIN)
 	     {
 	     	$result_MIN = (int)$result_MIN_0_5[0]['MIN_0_5'];
 	     }
 	     if((int)$result_MIN_5_10[0]['MIN_5_10'] < $result_MIN)
 	     {
 	     	$result_MIN = (int)$result_MIN_5_10[0]['MIN_5_10'];
 	     } if((int)$result_MIN_10_15[0]['MIN_10_15'] < $result_MIN)
 	     {
 	     	$result_MIN = (int)$result_MIN_10_15[0]['MIN_10_15'];
 	     } if((int)$result_MIN_15_20[0]['MIN_15_20'] < $result_MIN)
 	     {
 	     	$result_MIN = (int)$result_MIN_15_20[0]['MIN_15_20'];
 	     } if((int)$result_MIN_20_[0]['MIN_20_'] < $result_MIN)
 	     {
 	     	$result_MIN =(int) $result_MIN_20_[0]['MIN_20_'];
 	     }
 	     
 	  
   
        // return the query rlt
         $arrRlt = array();
        
         if(($result_MAX_0_5 == false)||($result_MAX_5_10 == false)
                                      ||($result_MAX_10_15 == false)
                                      ||($result_MAX_15_20 == false)
                                      ||($result_MAX_20_ == false)
                                      ||($result_MIN_0_5 == false)
                                      ||($result_MIN_5_10 == false)
                                      ||($result_MIN_10_15 == false)
                                      ||($result_MIN_15_20 == false)
                                      ||($result_MIN_20_ == false)
                                      ||($result_MY_0_5 == false)
                                      ||($result_MY_5_10 == false)
                                      ||($result_MY_10_15 == false)
                                      ||($result_MY_15_20 == false)
                                      ||($result_MY_20_ == false)) {
             $error = db_error();
                // Handle error - inform administrator, log to file, show error page, etc.
            }else{
            	$arrTmp = array();
            	$arrTmp[0] = $result_MIN_0_5[0]['MIN_0_5'];
            	$arrTmp[1] = $result_MIN_5_10[0]['MIN_5_10'];
            	$arrTmp[2] = $result_MIN_10_15[0]['MIN_10_15'];
            	$arrTmp[3] = $result_MIN_15_20[0]['MIN_15_20'];
            	$arrTmp[4] = $result_MIN_20_[0]['MIN_20_'];
            	
            	$arrRlt[0] = $arrTmp;
            	
            	$arrTmp = array();
            	$arrTmp[0] = $result_MY_0_5[0]['MY_0_5'];
            	$arrTmp[1] = $result_MY_5_10[0]['MY_5_10'];
            	$arrTmp[2] = $result_MY_10_15[0]['MY_10_15'];
            	$arrTmp[3] = $result_MY_15_20[0]['MY_15_20'];
            	$arrTmp[4] = $result_MY_20_[0]['MY_20_'];
            	
            	$arrRlt[1] = $arrTmp;
            	
            	$arrTmp = array();
            	$arrTmp[0] = $result_MAX_0_5[0]['MAX_0_5'];
            	$arrTmp[1] = $result_MAX_5_10[0]['MAX_5_10'];
            	$arrTmp[2] = $result_MAX_10_15[0]['MAX_10_15'];
            	$arrTmp[3] = $result_MAX_15_20[0]['MAX_15_20'];
            	$arrTmp[4] = $result_MAX_20_[0]['MAX_20_'];
            	
            	$arrRlt[2] = $arrTmp;
            	
            	$arrRlt[3] = $result_MAX;
            	$arrRlt[4] = $result_MIN;
                echo json_encode($arrRlt);
            }
        


    
        mysqli_close(db_connect());
    

?>