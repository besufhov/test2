<?php

$email = htmlentities($_REQUEST['email']);
$password = htmlentities($_REQUEST['password']);
$name = htmlentities($_REQUEST['name']);

require('/var/www/html/Secure/access.php');
$access = new access('database-1.cfsi04s00qx6.us-west-1.rds.amazonaws.com', 'admin', 'comckple123+', 'db1');
$access->connect();


$username = $access->selectUserfromName($name);
$user = $access->selectUser($email);

if ($user) {

    $encryptedPassword = $user['password'];
    $salt = $user['salt'];

    if ($encryptedPassword == sha1($password . $salt)) {

        $return['status'] = '200';
        $return['message'] = 'Logged in successfully as user(email)';
        $return['email'] = $user['email'];
        $return['name'] = $user['name'];
        $return['id'] = $user['id'];
        $return['birthday'] = $user['birthday'];
        $return['pp'] = $user['pp'];

    } else {
        $return['status'] = '201';
        $return['message'] = 'Found user as EMAIL';
    }

} else if ($username) {

    $encryptedPassword = $username['password'];
    $salt = $username['salt'];

    if ($encryptedPassword == sha1($password . $salt)) {

        $return['status'] = '300';
        $return['message'] = 'Logged in successfully as username(name)';
        $return['email'] = $username['email'];
        $return['name'] = $username['name'];
        $return['id'] = $username['id'];
        $return['birthday'] = $username['birthday'];
        $return['pp'] = $username['pp'];

    } else {
        $return['status'] = '301';
        $return['message'] = 'Found user as NAME';
    }
} else {
    $return['status'] = '301401';
    $return['message'] = 'No USER as NAME or EMAIL';
}

$access->disconnect();
// pass info as JSON for all
echo json_encode($return);