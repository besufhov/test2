<?php

     // connection
require('/var/www/html/Secure/access.php');

$access =new access('database-1.cfsi04s00qx6.us-west-1.rds.amazonaws.com', 'admin', 'comckple123+', 'db1');
$access->connect(); 


// request for php
$email = htmlentities($_REQUEST['email']);
$name = htmlentities($_REQUEST['name']);
$password = htmlentities($_REQUEST['password']);
$birthday = htmlentities($_REQUEST['birthday']);

// salt
$salt = openssl_random_pseudo_bytes(20);
$encryptedPassword = sha1($password . $salt);

$user = $access->selectUser($email);

// check availability

if ($user) {
    $return['status'] = '400';
    $return['message'] = 'The Email is alreday registered';
    echo json_encode($return);
    $access->disconnect();
    return;
}

    $result = $access->insertUser($email, $name, $encryptedPassword, $salt, $birthday);
    
        if ($result) {
            
            $user = $access->selectUser($email);
            $return['status'] = '200';
            $return['message'] = 'Successfully Registered';
            $return['email'] = $email;
            $return['name'] = $name;
            $return['birthday'] = $birthday;
            $return['id'] = $user['id'];
            
           
            echo json_encode($return);
            $access->disconnect();
            return;
        
        } else {
            $return['status'] = '400';
            $return['message'] = 'Could not Insert Information';
            
            echo json_encode($return);
             $access->disconnect();
            return;
        }