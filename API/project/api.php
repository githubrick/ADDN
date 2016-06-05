<?php

 /* 
 	Name: Jiajie Li 
	Student Number: 631482
	Distributed Computing Project
	Development of a Mobile Application for Australian Diabetes Data Network
*/

// This file is used to periodically check the patient insertion of the database. 
// And genertae a record in the push table if it does. So the the push.php file can 
// push the notification to APNS. 

try
{
	// Are we running in development or production mode? You can easily switch
	// between these two in the Apache VirtualHost configuration.
	if (!defined('APPLICATION_ENV'))
		define('APPLICATION_ENV', getenv('APPLICATION_ENV') ? getenv('APPLICATION_ENV') : 'production');

	// In development mode, we show all errors because we obviously want to 
	// know about them. We don't do this in production mode because that might
	// expose critical details of our app or our database. Critical PHP errors
	// will still be logged in the PHP and Apache error logs, so it's always
	// a good idea to keep an eye on them.
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
	// You're probably running this on a fast local server but in production
	// mode people will be using it on a mobile device over a slow connection.
	if (APPLICATION_ENV == 'development')
		sleep(2);

	$api = new API($config);
	
    $maxID = $api->getLargestID();
    $i = 0;
    while (true){
        $temp = $api->getLargestID();
        if($temp > $maxID){
            $maxID = $temp;
            $theNewPatient = $api->getTheNewPatient($maxID);
            $userGroup = $api->getInterestedGroup($theNewPatient); // the userGroup is a column of ->userid
            foreach ($userGroup as $user)
            {
                $api->addToPushQueue($user,$maxID);
                
            }
        }
        sleep(2);
    }
    
	echo "OK" . PHP_EOL;
}
catch (Exception $e)
{


	if (APPLICATION_ENV == 'development')
		var_dump($e);
	else
		exitWithHttpError(500);
}

////////////////////////////////////////////////////////////////////////////////

function exitWithHttpError($error_code, $message = '')
{
	switch ($error_code)
	{
		case 400: header("HTTP/1.0 400 Bad Request"); break;
		case 403: header("HTTP/1.0 403 Forbidden"); break;
		case 404: header("HTTP/1.0 404 Not Found"); break;
		case 500: header("HTTP/1.0 500 Server Error"); break;
	}

	header('Content-Type: text/plain');

	if ($message != '')
		header('X-Error-Description: ' . $message);

	exit;
}

function isValidUtf8String($string, $maxLength, $allowNewlines = false)
{
	if (empty($string) || strlen($string) > $maxLength)
		return false;

	if (mb_check_encoding($string, 'UTF-8') === false)
		return false;

	// Don't allow control characters, except possibly newlines	
	for ($t = 0; $t < strlen($string); $t++)
	{
		$ord = ord($string{$t});

		if ($allowNewlines && ($ord == 10 || $ord == 13))
			continue;

		if ($ord < 32)
			return false;
	}

	return true;
}

function truncateUtf8($string, $maxLength)
{
	$origString = $string;
	$origLength = $maxLength;

	while (strlen($string) > $origLength)
	{
		$string = mb_substr($origString, 0, $maxLength, 'utf-8');
		$maxLength--;
	}

	return $string;
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

    function getLargestID()
    {
        $stmt = $this->pdo->prepare('SELECT MAX(addn_id) as id FROM PATIENT');
        $stmt->execute();
        $userID = $stmt->fetch(PDO::FETCH_OBJ);
        return $userID->id;
        
    }
    
    function getTheNewPatient($patientID){
        $stmt = $this->pdo->prepare('SELECT diabetes_type, gender, (DATEDIFF(CURRENT_DATE, date_of_birth)/365) as age FROM PATIENT WHERE addn_id = ?');
        $stmt->execute(array($patientID));
        $newPatient = $stmt->fetch(PDO::FETCH_OBJ);
        return $newPatient;
    }
    
    function getInterestedGroup($theNewPatient){
        
        $stmt = $this->pdo->prepare('SELECT DISTINCT userid FROM USER_INTERESTED WHERE diabetesType = ? AND gender = ? AND ? < ageMax AND ? >= ageMin');
        $stmt->execute(array($theNewPatient->diabetes_type,$theNewPatient->gender,$theNewPatient->age,$theNewPatient->age));
        $userGroup = $stmt->fetchAll(PDO::FETCH_OBJ);
        return $userGroup;
    }
    
    
    function addToPushQueue($user,$patientID){
        
        $userid = $user->userid;
        $stmt = $this->pdo->prepare('SELECT device_token FROM Users WHERE userid = ?');
        $stmt->execute(array($userid));
        
        $deviceToken = $stmt->fetch(PDO::FETCH_OBJ);
        $testSentence = 'You\'ve Got a New Patient';
        $payload = $this->makePayload($testSentence,$patientID);
        
        $stmt = $this->pdo->prepare('INSERT INTO PUSH_QUEUE (device_token, payload, time_queued) VALUES (?, ?, NOW())');
        
        $stmt->execute(array($deviceToken->device_token, $payload));
    }
    

	// Creates the JSON payload for the push notification message. 
	function makePayload($text,$patientID)
	{
        $body['aps'] = array(
        'alert' => array(
                         'title' => $patientID,
                         'body' => $text,
                        ),
        'sound' => 'default',
        //'content-available' => "1",
        );
        $payload = json_encode($body);
        echo $payload;
		return $payload;
	}

	// We don't use PHP's built-in json_encode() function because it converts
	// UTF-8 characters to \uxxxx. That eats up 6 characters in the payload for
	// no good reason, as JSON already supports UTF-8 just fine.
	function jsonEncode($text)
	{
		static $from = array("\\", "/", "\n", "\t", "\r", "\b", "\f", '"');
		static $to = array('\\\\', '\\/', '\\n', '\\t', '\\r', '\\b', '\\f', '\"');
		return str_replace($from, $to, $text);
	}

	// Adds a push notification to the push queue. The notification will not
	// be sent immediately. The server runs a separate script, push.php, which 
	// periodically checks for new entries in this database table and sends
	// them to the APNS servers.
	function addPushNotification($deviceToken, $payload)
	{
		// Payloads have a maximum size of 256 bytes. If the payload is too
		// large (which shouldn't happen), we won't send this notification.
		if (strlen($payload) <= 256)
		{
			$stmt = $this->pdo->prepare('INSERT INTO push_queue (device_token, payload, time_queued) VALUES (?, ?, NOW())');
			$stmt->execute(array($deviceToken, $payload));
		}
	}
}

?>
