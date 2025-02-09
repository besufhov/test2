<?php

require('/var/www/html/Secure/access.php');

$access = new access('database-1.cfsi04s00qx6.us-west-1.rds.amazonaws.com', 'admin', 'comckple123+', 'db1');
$access->connect();

if ($_REQUEST['action'] == 'follow') {

    if (!isset($_REQUEST['user_id']) && !isset($_REQUEST['follow_id'])) {
        
        $return['status'] = '400';
        $return['message'] = 'Missing required information';
        echo json_encode($return);
        return;
    }

    $user_id = htmlentities($_REQUEST['user_id']);
    $follow_id = htmlentities($_REQUEST['follow_id']);

    $result = $access->insertFollow($user_id, $follow_id);
    

    if ($result) {
        $type = 'follow';
        $access->insertFollowingCount($user_id);
        $access->insertFollowerCount($follow_id);
        $access->insertNotification($user_id, $follow_id, $type);
        $return['status'] = '200';
        $return['message'] = 'Started following successfully';
            
    } else {

        $return['status'] = '400';
        $return['message'] = 'Could not follow';

        }

    } else if ($_REQUEST['action'] == 'unfollow') {

    if (!isset($_REQUEST['user_id']) && !isset($_REQUEST['follow_id'])) {
        
        $return['status'] = '400';
        $return['message'] = 'Missing required information';
        echo json_encode($return);
        return;
    }

    $user_id = htmlentities($_REQUEST['user_id']);
    $follow_id = htmlentities($_REQUEST['follow_id']);
    

    $result = $access->deleteFollow($user_id, $follow_id);

    if ($result) {
        
        $access->deleteFollowingCount($user_id);
        $access->deleteFollowerCount($follow_id);
        $access->deleteNotification($user_id, $follow_id);
        $return['status'] = '200';
        $return['message'] = 'Unfollowed successfully';
            
    } else {

        $return['status'] = '400';
        $return['message'] = 'Could not follow';
        }

    }

echo json_encode($return);
$access->disconnect();