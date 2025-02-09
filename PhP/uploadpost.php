<?php

require('/var/www/html/Secure/access.php');

require '/var/www/html/composer/composer/vendor/autoload.php';

use Aws\S3\S3Client;


$access = new access('database-1.cfsi04s00qx6.us-west-1.rds.amazonaws.com', 'admin', 'comckple123+', 'db1');
$access->connect();

$s3 = new S3Client([
    'version' => 'latest',
    'region' => 'us-west-1',
    'credentials' => [
        'key' => 'AKIAX3DNHB2UTYI2NDZF',
        'secret' => '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'
    ]
]);

$bucketName = 'testbucketuq2';


$user_id = htmlentities($_REQUEST['user_id']);
$type = htmlentities($_REQUEST['type']);
$postmessage = htmlentities($_REQUEST['postmessage']);
$picture = '';
$return = array();


$keyName = 'posts/' . $user_id . '/' . $type . '/' . basename($_FILES["file"]['name']);
$picture = 'https://testbucketuq2.s3.amazonaws.com/posts/' . $user_id . '/' . $type . '/' . $_FILES['file']['name'];

if (isset($_FILES['file']) && $_FILES['file']['size'] > 1) {

    try {

        $file = $_FILES["file"]['tmp_name'];
        $result = $s3->putObject([

            'Bucket' => $bucketName,
            'Key' => $keyName,
            'SourceFile' => $file,
            'ACL' => 'public-read',
        ]);
        if ($result) {
            $access->insertPosts($type, $picture, $postmessage, $user_id);
            $access->insertPostCount($user_id);
            $return['picture'] = $picture;
            $return['postmessage'] = $postmessage;
            $return['status'] = '200';
            $return['message'] = 'okeyo';
            echo json_encode($return);
        } else {

            $return['message'] = 'NOTOKEYO';
            echo json_encode($return);
        }
    } catch (Aws\S3\Exception\S3Exception $e) {
        $return['message'] = 'Error';
        echo json_encode($return);
    }
} else {
    $return['message'] = 'File has no size';
    echo json_encode($return);
}
