<?php

 /* 
  Name: Jiajie Li 
  Student Number: 631482
  Distributed Computing Project
  Development of a Mobile Application for Australian Diabetes Data Network
*/

// This script is used for letting users check the data completness of the database. 

try
{

	require_once 'api_config.php';
    $config = $config['development'];

    $api = new API($config);
    
    $command = $_POST['command'];
    
    // IF COMMAND IS TO READ DATA
    if($command == 'RecordsLoaded')
    {
        // IF READ THE BALL POSITION
        $patient = $api->getNumPatient();
        $visit = $api->getNumVisit();
        $comorbidity = $api->getNumComorbidity();
        $family = $api->getNumFamily();
        $study = $api->getNumStudy();
        $medication = $api->getNumMedication();
        echo json_encode(array(
                          array('Patients',$patient),
                          array('Visits', $visit),
                          array('Comorbidity History',$comorbidity),
                          array('Family History', $family),
                          array('Study History', $study),
                          array('Medication History', $medication)
                          ));
    }
    if($command == 'PatientField')
    {
        //active flag, date of birth, gender, diabetes type, date of diagnosis
        $keyword1 = 'active_flag';
        $keyword2 = 'date_of_birth';
        $keyword3 = 'gender';
        $keyword4 = 'diabetes_type';
        $keyword5 = 'date_of_diagnosis';
        $keyword6 = 'data_of_consent';
        $keyword7 = 'consent_for_future_research';
        $keyword8 = 'country_of_birth';
        $keyword9 = 'ethnicity_major';
        $keyword10 = 'indigenous_status_aust';
        $keyword11= 'language_spoken';
        $keyword12 = 'birth_weight';
        $keyword13 = 'gestation_at_birth';
        $keyword14 = 'mode_of_birth';
        $keyword15 = 'dna_stored';
        $keyword16 = 'hla_a_1';
        $keyword17 = 'ambulatory_care';
        $keyword18 = 'hospitalisation_duration';
        $keyword19 = 'country_at_diagnosis	';
        $keyword20 = 'dka';
        $keyword21 = 'postcode_at_diagnosis';
        
        echo json_encode(array(
                               array('Active Flag',$api->getPercentageOfPatient($keyword1)),
                               array('Date of Birth',$api->getPercentageOfPatient($keyword2)),
                               array('Gender',$api->getPercentageOfPatient($keyword3)),
                               array('Diabetes Type',$api->getPercentageOfPatient($keyword4)),
                               array('Date of Diagnosis',$api->getPercentageOfPatient($keyword5)),
                               array('Date of ADDN Consent',$api->getPercentageOfPatient($keyword6)),
                               array('Consent to Future Research',$api->getPercentageOfPatient($keyword7)),
                               array('Country of Birth',$api->getPercentageOfPatient($keyword8)),
                               array('Ethnicity',$api->getPercentageOfPatient($keyword9)),
                               array('Indigenous Status',$api->getPercentageOfPatient($keyword10)),
                               array('Home Language',$api->getPercentageOfPatient($keyword11)),
                               array('Birth Weight',$api->getPercentageOfPatient($keyword12)),
                               array('Birth Gestation',$api->getPercentageOfPatient($keyword13)),
                               array('Birth Mode',$api->getPercentageOfPatient($keyword14)),
                               array('DNA Stored',$api->getPercentageOfPatient($keyword15)),
                               array('HLA',$api->getPercentageOfPatient($keyword16)),
                               array('Ambulatory Care',$api->getPercentageOfPatient($keyword17)),
                               array('Days Hospitalised',$api->getPercentageOfPatient($keyword18)),
                               array('Country at Diagnosis',$api->getPercentageOfPatient($keyword19)),
                               array('DKA',$api->getPercentageOfPatient($keyword20)),
                               array('Postcode at Diagnosis',$api->getPercentageOfPatient($keyword21))

                         ));
    }
    if($command == 'VisitField')
    {
        $keyword1 = 'date_of_visit';
        $keyword2 = 'diagnosis_visit';
        $keyword3 = 'height';
        $keyword4 = 'weight';
        $keyword5 = 'systolic_blood_pressure';
        $keyword6 = 'insulin_regimen';
        $keyword7 = 'injection_frequency_per_day';
        $keyword8 = 'icr';
        $keyword9 = 'isf';
        $keyword10 = 'total_daily_insulin_dose';
        $keyword11 = 'insulin_regimen';
        $keyword12 = 'insulin_daily_dose_2';
        $keyword13 = 'daily_basal_insulin_dose';
        $keyword14 = 'smbg_frequency_per_day';
        $keyword15 = 'cgm';
        $keyword16 = 'severe_hypoglycaemia_episodes';
        $keyword17 = 'moderate_hypoglycaemia_episodes';
        $keyword18 = 'dka_episodes';
        $keyword19 = 'hba1c_ngsp';
        
        echo json_encode(array(
                               array('Date of visit',$api->getPercentageOfVisit($keyword1)),
                               array('diagnosis visit flag',$api->getPercentageOfVisit($keyword2)),
                               array('Height',$api->getPercentageOfVisit($keyword3)),
                               array('Weight',$api->getPercentageOfVisit($keyword4)),
                               array('Blood Pressure',$api->getPercentageOfVisit($keyword5)),
                               array('Insulin Regimen',$api->getPercentageOfVisit($keyword6)),
                               array('Daily Injections',$api->getPercentageOfVisit($keyword7)),
                               array('ICR',$api->getPercentageOfVisit($keyword8)),
                               array('ISF',$api->getPercentageOfVisit($keyword9)),
                               array('Total Daily Insulin',$api->getPercentageOfVisit($keyword10)),
                               array('Daily Insulin Type',$api->getPercentageOfVisit($keyword11)),
                               array('Daily Insulin Dose',$api->getPercentageOfVisit($keyword12)),
                               array('Daily Basal Insulin',$api->getPercentageOfVisit($keyword13)),
                               array('SMBG Frequency',$api->getPercentageOfVisit($keyword14)),
                               array('CGM',$api->getPercentageOfVisit($keyword15)),
                               array('Severe Hypoglycemia',$api->getPercentageOfVisit($keyword16)),
                               array('Moderate Hypoglycemia',$api->getPercentageOfVisit($keyword17)),
                               array('DKA Episodes',$api->getPercentageOfVisit($keyword18)),
                               array('HbA1C',$api->getPercentageOfVisit($keyword19)),
                        ));
    }
    
}
catch (Exception $e)
{
		var_dump($e);
}

////////////////////////////////////////////////////////////////////////////////
    
////////////////////////////////////////////////////////////////////////////////

class API
{


	private $pdo;

	function __construct($config)
	{
		// Create a connection to the database.
        $this->pdo = new PDO(
                             'mysql:host=' . $config['db']['host'] . ';dbname=' . $config['db']['dbname'],
                             $config['db']['username'],
                             $config['db']['password'],
                             array());

		$this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

		// We want the database to handle all strings as UTF-8.
		$this->pdo->query('SET NAMES utf8');
	}


    function getNumPatient(){
        $stmt = $this->pdo->prepare('SELECT COUNT(*) AS patient FROM PATIENT');
        $stmt->execute();
        $patient = $stmt->fetch(PDO::FETCH_OBJ)->patient;
        return $patient;
    }
    function getNumVisit(){
        $stmt = $this->pdo->prepare('SELECT COUNT(*) AS visit FROM VISIT');
        $stmt->execute();
        $visit = $stmt->fetch(PDO::FETCH_OBJ)->visit;
        return $visit;
    }
    function getNumComorbidity(){
        $stmt = $this->pdo->prepare('SELECT COUNT(*) AS comorbidity FROM COMORBIDITIES');
        $stmt->execute();
        $comorbidity = $stmt->fetch(PDO::FETCH_OBJ)->comorbidity;
        return $comorbidity;
    }
    function getNumFamily(){
        $stmt = $this->pdo->prepare('SELECT COUNT(*) AS family FROM FAMILY_HISTORY');
        $stmt->execute();
        $family = $stmt->fetch(PDO::FETCH_OBJ)->family;
        return $family;
    }
    function getNumStudy(){
        $stmt = $this->pdo->prepare('SELECT COUNT(*) AS study FROM PATIENT_STUDIES');
        $stmt->execute();
        $study = $stmt->fetch(PDO::FETCH_OBJ)->study;
        return $study;
    }
    function getNumMedication(){
        $stmt = $this->pdo->prepare('SELECT COUNT(*) AS medication FROM OTHER_MEDICATIONS');
        $stmt->execute();
        $medication = $stmt->fetch(PDO::FETCH_OBJ)->medication;
        return $medication;
    }
    
    function getPercentageOfPatient($keyword){
        
        $stmt = $this->pdo->prepare('SELECT round (cast(COUNT(' .$keyword. ') / COUNT(addn_id) AS DECIMAL(3,2)),2) AS num FROM PATIENT');
        $stmt->execute();
        $number = $stmt->fetch(PDO::FETCH_OBJ)->num;
        return $number;
    }
    
    function getPercentageOfVisit($keyword){
        
        $stmt = $this->pdo->prepare('SELECT round (cast(COUNT(' .$keyword. ') / COUNT(addn_VISIT_id) AS DECIMAL(3,2)),2) AS num FROM VISIT');
        $stmt->execute();
        $number = $stmt->fetch(PDO::FETCH_OBJ)->num;
        return $number;
    }
    
    
    
    
}
?>