<?php

 /* 
  Name: Jiajie Li 
  Student Number: 631482
  Distributed Computing Project
  Development of a Mobile Application for Australian Diabetes Data Network
*/

// This file is used to hanlde the login signout sign up action of the users.

       


    // get the post body
    if(isset($_POST['username'])){
        $username =$_POST['username'];
    }
    if(isset($_POST['password'])){
        $password = $_POST['password'];
    }
    if(isset($_POST['type'])){
        $type = $_POST['type'];
    }
    


    

    
    // determine if user exists
    $query = "SELECT user_name
    FROM Users
    WHERE user_name='".$username."';";
    $userExists = db_select($query);

    
    if($type == "login"){
        // add a 'user' record
        if (!$userExists) {
            echo "User does not exist";
        } else{
            // determine if password match
            $sql = "SELECT password
            FROM Users
            WHERE user_name='".$username."';";
            $actualPassword = db_select($sql);
            if($actualPassword[0]['password'] == $password){
                if(isset($_POST['device_token'])){
                    $device_token = $_POST['device_token'];
                    $sql = "UPDATE Users SET device_token = '".$device_token."' WHERE user_name = '".$username."'";
                    db_query($sql);
                }
                echo "success";
            }else{
                echo "Wrong user name or password";
            }
        }
    }
    if($type == "signup") {
        $region = $_POST['region'];
        $email = $_POST['email'];
        $mobile = $_POST['mobile'];
        if (!$userExists) {
            $sql = "INSERT INTO Users(user_name, email_address,region, password,user_mobile)
            VALUES ('".$username."','".$email."','".$region."','".$password."','".$mobile."');";
            $reply = db_query($sql);
            if($reply === false) {
                $error = db_error();
                echo "error";
                // Handle error - inform administrator, log to file, show error page, etc.
            }else{
                echo "success";
            }
        }else{
            echo $username . " " . "alraedy exist";
        }
    }
    if($type == "signout"){
        $sql = "UPDATE Users SET device_token = NULL WHERE user_name = '".$username."'";
        db_query($sql);
        echo "success";
    }

    
    // close the database connection
    mysqli_close(db_connect());
    
    
    function getStatusCodeMessage($status) {
        
        $codes = Array(
                       100 => 'Continue',
                       101 => 'Switching Protocols',
                       200 => 'OK',
                       201 => 'Created',
                       202 => 'Accepted',
                       203 => 'Non-Authoritative Information',
                       204 => 'No Content',
                       205 => 'Reset Content',
                       206 => 'Partial Content',
                       300 => 'Multiple Choices',
                       301 => 'Moved Permanently',
                       302 => 'Found',
                       303 => 'See Other',
                       304 => 'Not Modified',
                       305 => 'Use Proxy',
                       306 => '(Unused)',
                       307 => 'Temporary Redirect',
                       400 => 'Bad Request',
                       401 => 'Unauthorized',
                       402 => 'Payment Required',
                       403 => 'Forbidden',
                       404 => 'Not Found',
                       405 => 'Method Not Allowed',
                       406 => 'Not Acceptable',
                       407 => 'Proxy Authentication Required',
                       408 => 'Request Timeout',
                       409 => 'Conflict',
                       410 => 'Gone',
                       411 => 'Length Required',
                       412 => 'Precondition Failed',
                       413 => 'Request Entity Too Large',
                       414 => 'Request-URI Too Long',
                       415 => 'Unsupported Media Type',
                       416 => 'Requested Range Not Satisfiable',
                       417 => 'Expectation Failed',
                       500 => 'Internal Server Error',
                       501 => 'Not Implemented',
                       502 => 'Bad Gateway',
                       503 => 'Service Unavailable',
                       504 => 'Gateway Timeout',
                       505 => 'HTTP Version Not Supported'
                       );
        
        return (isset($codes[$status])) ? $codes[$status] : '';
    }
    
    // Helper method to send a HTTP response code/message
    function sendAPIResponse($status = 200, $body = '', $content_type = 'text/html') {
        
        $status_header = 'HTTP/1.1 ' . $status . ' ' . getStatusCodeMessage($status);
        header($status_header);
        header('Content-type: ' . $content_type);
        
        
    }
    
    function db_connect() {
        
        // Define connection as a static variable, to avoid connecting more than once
        static $connection;
        // Try and connect to the database, if a connection has not been established yet
        if(!isset($connection)) {
            // Load configuration as an array. Use the actual location of your configuration file
            // Put the configuration file outside of the document root
            $config = parse_ini_file('./config.ini');
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
    
?>