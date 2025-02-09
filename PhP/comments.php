<?php

require('/var/www/html/Secure/access.php');

$access = new access('database-1.cfsi04s00qx6.us-west-1.rds.amazonaws.com', 'admin', 'comckple123+', 'db1');
$access->connect();


if ($_REQUEST['action'] == 'insert') {

$post_id = htmlentities($_REQUEST['post_id']);
$user_id = htmlentities($_REQUEST['user_id']);
$comment = htmlentities($_REQUEST['comment']);

    $result = $access->insertComment($post_id, $user_id, $comment);

    if ($result) {
        $access->insertCommentCount($post_id);
        $return['status'] = '200';
        $return['message'] = 'Comment has been sent';
        echo json_encode($return);
    } else {
        $return['status'] = '400';
        $return['message'] = 'Could not comment';
    }

} else if ($_REQUEST['action'] == 'select') {

    $id = htmlentities($_REQUEST['id']);
    $limit = htmlentities($_REQUEST['limit']);
    $offset = htmlentities($_REQUEST['offset']);


    $comments = $access->selectComments($id, $limit, $offset);

    if ($comments) {
        $return['comments'] = $comments;
        echo json_encode($return);
    }
} else if ($_REQUEST['action'] == 'delete') {
    
    $id = htmlentities($_REQUEST['id']);
    $post_id = htmlentities($_REQUEST['post_id']);
    

    $result = $access->deleteComment($id);

    if ($result) {
        $access->deleteCommentCount($post_id);
        $return['status'] = '200';
        $return['message'] = 'Comment has been deleted';
        echo json_encode($return);
    } else {
        $return['status'] = '400';
        $return['message'] = 'Could not delete';
    }
    }

$access->disconnect();
