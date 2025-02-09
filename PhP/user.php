<?php

require('/var/www/html/Secure/access.php');

$access = new access('database-1.cfsi04s00qx6.us-west-1.rds.amazonaws.com', 'admin', 'comckple123+', 'db1');
$access->connect();

$id = htmlentities($_REQUEST['id']);

$user = $access->User($id);

if ($user) {
    $return['user'] = $user;
    echo json_encode($return);
}

$access->disconnect();