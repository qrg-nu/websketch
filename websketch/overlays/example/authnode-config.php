<?php
/**
 * ---------------------------------------------------------------------------
 *   System: WebSketch, LTI Front End
 *   Author: Madeline Usher, QRG, Northwestern University
 *  Created: March 16, 2018
 *  Purpose: Configuration settings for the LTI front end.
 *
 * Almost all of this code was used from Rating: an example LTI tool provider
 *  @author  Stephen P Vickers <svickers@imsglobal.org>
 *  @copyright  IMS Global Learning Consortium Inc
 *  @date  2016
 *  @version 2.0.0
 *  @license http://www.gnu.org/licenses/gpl.html GNU General Public License, 
 *           Version 3.0
 * ---------------------------------------------------------------------------
 *  $LastChangedDate: 2019-05-07 18:07:23 -0500 (Tue, 07 May 2019) $
 *  $LastChangedBy: usher $
 * ---------------------------------------------------------------------------
 */

/*
 * This page contains the configuration settings for the LTI front end.
 */

###
###  Application settings
###
  define('APP_NAME', 'WebSketch');
  define('SESSION_NAME', 'php-lti-websketch');
  define('VERSION', '1.0.00');
  define('HOST', getenv('AUTHNODE_HOST'));
  define('WEBSKETCH_HOST', 'websketch.example.com');
  define('WEBSKETCH_PORT', '443');
  define('COOKIE_DOMAIN', 'example.com');

###
###  Database connection settings
###
  
  $auth_db_host = gethostbyname('lti-db');
  $auth_db_name = 'db_lti_websketch_auth';
  $dsn = 'mysql:dbname=' . $auth_db_name . ';host=' . $auth_db_host;
    
  // DB_NAME examples:
  // - 'mysql:dbname=MyDb;host=localhost' 
  // - 'sqlite:php-rating.sqlitedb'
  define('DB_NAME', $dsn);  
  define('DB_USERNAME', 'lti-qrg');
  define('DB_PASSWORD', 'BONGAb00m');
  define('DB_TABLENAME_PREFIX', 'LTIWS_');
  define('DBTABLE_SESSION_INFO', 'lti_session');

?>
