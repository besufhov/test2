<?php

require('/var/www/html/Secure/access.php');

$access = new access('database-1.cfsi04s00qx6.us-west-1.rds.amazonaws.com', 'admin', 'comckple123+', 'db1');
$access->connect();

if (!isset($_REQUEST['id']) && !isset($_REQUEST['limit']) && !isset($_REQUEST['offset'])) {
    $return['status'] = '400';
    $return['message'] = 'Missing required informasyon';
    echo json_encode($return);
    return;
}

    $id = htmlentities($_REQUEST['id']);
    $limit = htmlentities($_REQUEST['limit']);
    $offset = htmlentities($_REQUEST['offset']);

    $posts = $access->selectPostsForFeed($id, $offset, $limit);


    if ($posts) {
        $return['posts'] = $posts;
        echo json_encode($return);
    }

    $access->disconnect();