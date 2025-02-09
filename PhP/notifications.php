<?php

require('/var/www/html/Secure/access.php');

$access = new access('database-1.cfsi04s00qx6.us-west-1.rds.amazonaws.com', 'admin', 'comckple123+', 'db1');
$access->connect();


if ($_REQUEST['action'] == 'select') {

$user_id = htmlentities($_REQUEST['user_id']);
$limit = htmlentities($_REQUEST['limit']);
$offset = htmlentities($_REQUEST['offset']);

    $notifications = $access->selectNotifications($user_id, $limit, $offset);

    if ($notifications) {
        $return['notifications'] = $notifications;
        echo json_encode($return);
    } else {
        $return['status'] = '400';
        $return['message'] = 'Could not select';
    }
}

$access->disconnect();
