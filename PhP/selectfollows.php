<?php

require('/var/www/html/Secure/access.php');

$access = new access('database-1.cfsi04s00qx6.us-west-1.rds.amazonaws.com', 'admin', 'comckple123+', 'db1');
$access->connect();

if (($_REQUEST['action']) == 'delve') 

    if (!isset($_REQUEST['id']) && !isset($_REQUEST['limit']) && !isset($_REQUEST['offset'])) {
        $return['status'] = '400';
        $return['message'] = 'Missing required information';
        echo json_encode($return);
        return;
    }

    $id = htmlentities($_REQUEST['id']);
    $limit = htmlentities($_REQUEST['limit']);
    $offset = htmlentities($_REQUEST['offset']);

    $follows = $access->selectFollows($id, $limit, $offset);
    
    if ($follows) {

        $return['follows'] = $follows;
        echo json_encode($return);

    } else {
        $return['status'] = '400';
        $return['message'] = 'No users found';
    }


$access->disconnect();
