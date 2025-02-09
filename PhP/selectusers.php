<?php

require('/var/www/html/Secure/access.php');

$access = new access('database-1.cfsi04s00qx6.us-west-1.rds.amazonaws.com', 'admin', 'comckple123+', 'db1');
$access->connect();

if (($_REQUEST['action']) == 'search') 

    if (!isset($_REQUEST['name']) && !isset($_REQUEST['id']) && !isset($_REQUEST['limit']) && !isset($_REQUEST['offset'])) {
        $return['status'] = '400';
        $return['message'] = 'Missing required information';
        echo json_encode($return);
        return;
    }

    $name = htmlentities($_REQUEST['name']);
    $id = htmlentities($_REQUEST['id']);
    $limit = htmlentities($_REQUEST['limit']);
    $offset = htmlentities($_REQUEST['offset']);

    $users = $access->selectUsers($name, $id, $limit, $offset);
    
    if ($users) {

        $return['users'] = $users;
        echo json_encode($return);

    } else {
        $return['status'] = '400';
        $return['message'] = 'No users found';
    }

   
    

$access->disconnect();