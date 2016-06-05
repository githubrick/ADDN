<?php
 /* 
  Name: Jiajie Li 
  Student Number: 631482
  Distributed Computing Project
  Development of a Mobile Application for Australian Diabetes Data Network
*/


// Configuration file for push.php

$config = array(
	// These are the settings for development mode
	'development' => array(

		// The APNS server that we will use
		'server' => 'gateway.sandbox.push.apple.com:2195',

		// The SSL certificate that allows us to connect to the APNS servers
		'certificate' => 'ck.pem',
		'passphrase' => 'aB19901105',

		// Configuration of the MySQL database
		'db' => array(
			'host'     => '127.0.0.1',
			'dbname'   => 'ADDN',
			'username' => 'root',
			'password' => '',
			),

		// Name and path of our log file
		'logfile' => './log/push_development.log',
		),

	// These are the settings for production mode
	'production' => array(

		// The APNS server that we will use
		'server' => 'gateway.push.apple.com:2195',

		// The SSL certificate that allows us to connect to the APNS servers
		'certificate' => 'ck.pem',
		'passphrase' => 'aB19901105',

		// Configuration of the MySQL database
		'db' => array(
			'host'     => '127.0.0.1',
			'dbname'   => 'ADDN',
			'username' => 'root',
			'password' => '',
			),

		// Name and path of our log file
		'logfile' => './log/push_production.log',
		),
	);
?>