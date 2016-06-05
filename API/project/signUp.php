<?php
    
 /* 
  Name: Jiajie Li 
  Student Number: 631482
  Distributed Computing Project
  Development of a Mobile Application for Australian Diabetes Data Network
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
         
         $region = $obj->{"region"};
         $email = $obj->{"email"}; 
         $mobile = $obj->{"mobile"}; 
         $username = $obj->{"username"};
         $password = $obj->{"password"}; 
         
        // determine if user exists
	    $query = "SELECT user_name
	    FROM users
	    WHERE user_name='".$username."';";
	    $userExists = db_select($query);
	
	    

	        // add a 'user' record
	     if (!$userExists) 
	     {
            $sql = "INSERT INTO Users(user_name, email_address,region, password,user_mobile)
            VALUES ('".$username."','".$email."','".$region."','".$password."','".$mobile."');";
            $reply = db_query($sql);
            if($reply === false) {
                $target = array ('signUp'=> "error");
                echo json_encode($target);
                // Handle error - inform administrator, log to file, show error page, etc.
            }else{
            		$query1 = "SELECT *
				    FROM users
				    WHERE user_name='".$username."';";
				    $userRlt = db_select($query1);
	                echo  json_encode($userRlt);
            }
	     }
        else
        {

               $target = array ('signUp'=> $username . " " . "alraedy exist");
          echo json_encode($target);
        }

        mysqli_close(db_connect());
    

?>