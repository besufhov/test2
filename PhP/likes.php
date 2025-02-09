<?php

require('/var/www/html/Secure/access.php');

$access = new access('database-1.cfsi04s00qx6.us-west-1.rds.amazonaws.com', 'admin', 'comckple123+', 'db1');
$access->connect();



if ($_REQUEST['action'] == "insert") {

$post_id = htmlentities($_REQUEST['post_id']);
$user_id = htmlentities($_REQUEST['user_id']);
$post_user_id = htmlentities($_REQUEST['post_user_id']);

    $result = $access->insertLike($post_id, $user_id);

    if ($result) {
        
        $type = 'like';
        $access->insertLikeCount($post_id);
        $access->insertNotification($user_id, $post_user_id, $type);
        $return['status'] = '200';
        $return['message'] = 'like has been registered successfully';
        echo json_encode($return);

    } else {
        $return['status'] = '400';
        $return['message'] = 'Could not register like';
    }

} else if ($_REQUEST['action'] == 'delete') {
    
$post_id = htmlentities($_REQUEST['post_id']);
$user_id = htmlentities($_REQUEST['user_id']);
$post_user_id = htmlentities($_REQUEST['post_user_id']);

    $result = $access->deleteLike($post_id, $user_id);

    if ($result) {
        $access->deleteLikeCount($post_id);
        $access->deleteNotification($user_id, $post_user_id);
        $return['status'] = '200';
        $return['message'] = 'like has been DELETED successfully';
        echo json_encode($return);

    } else {
        $return['status'] = '400';
        $return['message'] = 'Could not DELETE like';
    }

    } else if ($_REQUEST['action'] == 'select') {
        
    $id = htmlentities($_REQUEST['id']);
    $limit = htmlentities($_REQUEST['limit']);
    $offset = htmlentities($_REQUEST['offset']);

       $likes = $access->selectLikes($id, $limit, $offset);

    if ($likes) {
        
        $return['likes'] = $likes;
        echo json_encode($return);

    } else {
        $return['status'] = '400';
        $return['message'] = 'Could not select';
    }

    }

$access->disconnect();
