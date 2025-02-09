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
$id = htmlentities($_REQUEST['id']);

// salt
$salt = openssl_random_pseudo_bytes(20);
$encryptedPassword = sha1($password . $salt);

$user = $access->selectUser($email);

// check availability

    $result = $access->updateUser($email, $name, $encryptedPassword, $salt, $birthday, $id);
    
        if ($result) {
            
            $user = $access->selectUser($email);
            $return['status'] = '200';
            $return['message'] = 'Successfully Updated';
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
