<?php
    
/* 
    Name: Bo Li 
    Student Number: 630713
    Distributed Computing Project
    IPhone Application of Australian Diabetes Data Network
*/
// This file is used to let user check their notification preferences
// stored in the database.

    try
    {

    
        if (!defined('APPLICATION_ENV'))
            define('APPLICATION_ENV', getenv('APPLICATION_ENV') ? getenv('APPLICATION_ENV') : 'production');
        

        if (APPLICATION_ENV == 'development')
        {
            error_reporting(E_ALL|E_STRICT);
            ini_set('display_errors', 'on');
        }
        else
        {
            error_reporting(0);
            ini_set('display_errors', 'off');
        }
        
        // Load the config file. 
        require_once 'api_config.php';
        $config = $config[APPLICATION_ENV];
        
        // In development mode, we fake a delay that makes testing more realistic.
        if (APPLICATION_ENV == 'development')
            sleep(2);
        
        // To keep the code clean, I put the API into its own class. 
        $api = new API($config);
        
        
        
        $requestParams = file_get_contents('php://input');
        $obj = json_decode($requestParams);
         
        $command = $obj->{"command"};
        $userid = $obj->{"userid"}; 
        $deviceToken = $obj->{"deviceToken"}; 
        $minAge = $obj->{"minAge"}; 
        $maxAge = $obj->{'maxAge'};
        $gender = $obj->{'gender'};
        $diabetesType = $obj->{'diabetesType'};
        $interestedId = $obj->{'interestedId'};
        
        
        if($command == 'add'){
        
            $api->updateDeviceToken($userid,$deviceToken);
            $api->insertUserInterested($userid,$minAge,$maxAge,$gender,$diabetesType);
            $target = array ('msg'=> "ok");
            echo json_encode($target);
        }
        if($command == 'view'){
            $count = $api->countNumberOfInterestWithID($userid);
            $userInterests = $api->getAllNotificationWithID($userid);
            $body = array($count,$userInterests);
            $target = array ('msg'=> $body);
            echo json_encode($target);
        }
        if($command == 'delete'){
             $api->deleteInterest($interestedId);
             $target = array ('msg'=> "ok");
             echo json_encode($target);
        }
        
       
    }
    catch (Exception $e)
    {
        // The code throws an exception when something goes horribly wrong; e.g.
        // no connection to the database could be made. In development mode, we
        // show these exception messages. In production mode, we simply return a
        // "500 Server Error" message.
        
        if (APPLICATION_ENV == 'development')
            var_dump($e);
        else
            exitWithHttpError(500);
    }
    

    
    ////////////////////////////////////////////////////////////////////////////////
    
    class API
    {
        // Because the payload only allows for 256 bytes and there is some overhead
        // we limit the message text to 190 characters.
        const MAX_MESSAGE_LENGTH = 190;
        
        private $pdo;
        
        function __construct($config)
        {
            // Create a connection to the database.
            $this->pdo = new PDO(
                                 'mysql:host=' . $config['db']['host'] . ';dbname=' . $config['db']['dbname'],
                                 $config['db']['username'],
                                 $config['db']['password'],
                                 array());
            
            // If there is an error executing database queries, we want PDO to
            // throw an exception. Our exception handler will then exit the script
            // with a "500 Server Error" message.
            $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            
            // We want the database to handle all strings as UTF-8.
            $this->pdo->query('SET NAMES utf8');
        }

        function updateDeviceToken($userid,$deviceToken)
        {
            $stmt = $this->pdo->prepare('UPDATE users SET device_token = ? WHERE userid = ?');
            $stmt->execute(array($deviceToken,$userid));
           
        }
        
        function insertUserInterested($userid,$minAge,$maxAge,$gender,$diabetesType)
        {
            $stmt = $this->pdo->prepare('INSERT INTO user_interested(userid,diabetesType,gender,ageMax,ageMin) VALUES(?, ?, ?, ?, ?)');
            $stmt->execute(array($userid,$diabetesType,$gender,$maxAge,$minAge));

 
        }
        
        function countNumberOfInterestWithID($userid)
        {
            $stmt = $this->pdo->prepare('SELECT  COUNT(*) AS NumberOfInterest FROM user_interested WHERE userid = ?');
            $stmt->execute(array($userid));
            $numberOfInterest = $stmt->fetchAll(PDO::FETCH_OBJ);
            return $numberOfInterest;
            

        }
        
        function getAllNotificationWithID($userid)
        {
            $stmt = $this->pdo->prepare('SELECT  * FROM user_interested WHERE userid = ?');
            $stmt->execute(array($userid));
            $userInterests = $stmt->fetchAll(PDO::FETCH_OBJ);
            
            return $userInterests;
            
  
            
        }
        
        function deleteInterest($interestedId)
        {
            $stmt = $this->pdo->prepare('DELETE FROM user_interested WHERE interestedId = ?');
            $stmt->execute(array($interestedId));
           
        }
    }
?>