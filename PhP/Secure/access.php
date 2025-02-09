<?php

class access
{

    var $host = "database-1.cfsi04s00qx6.us-west-1.rds.amazonaws.com";
    var $user = "admin";
    var $pass = "comckple123+";
    var $dbname = "db1";

    var $conn = null;
    var $result = null;

    function __construct($host, $user, $pass, $dbname)
    {

        $this->host = $host;
        $this->user = $user;
        $this->pass = $pass;
        $this->dbname = $dbname;

        $this->conn = new mysqli($this->host, $this->user, $this->pass, $this->dbname);
        if (mysqli_connect_errno()) {
            echo 'Could not construct';
            return;
        }

        $this->conn->set_charset('utf8');

    }

    public function connect()
    {

        $this->conn = new mysqli($this->host, $this->user, $this->pass, $this->dbname);

        if (mysqli_connect_errno()) {
            echo 'Could not connect';
            return;
        }

        $this->conn->set_charset('utf8');

    }

    public function disconnect()
    {
        if ($this->conn != null) {
            $this->conn->close();
        }
    }

    public function selectUser($email) {
        
        // store user related info
        $returnArray = array();

        // SQL command to choose user by e-mail
        $sql = "SELECT * FROM Users WHERE email ='" . $email . "'";

        // SQL query execution
        $result = $this->conn->query($sql);

          // if result is not zero and it has at least 1 row / value / result
          if ($result != null && (mysqli_num_rows($result)) >= 1) {

            // then it executes result it will result everything in tables so fetch array will convert it to json
            $row = $result->fetch_array(MYSQLI_ASSOC);

            // assign fetched row to returnArray
            if (!empty($row)) {
                $returnArray = $row;
            }
        }
        // throw back ReturnArray information to user.
        return $returnArray;
    }

    public function User($id) {

        $sql = "SELECT Users.id,
                        Users.email,
                        Users.name,
                        Users.birthday,
                        Users.password,
                        Users.date_created,
                        Users.type,
                        Users.pp,
                        Users.postcount,
                        Users.followingcount,
                        Users.followercount,
                        follows.follow_id AS followed_user
                        FROM Users 
                        LEFT JOIN follows ON Users.id = follows.follow_id 
                        WHERE Users.id = $id";

        $statement = $this->conn->prepare($sql);

        if (!$statement) {
            throw new Exception($statement->error);
        }

        $statement->execute();

        $result = $statement->get_result();

        while ($row = $result->fetch_assoc()) {
            $return[] = $row;
        }
        return $return;

    }


    // Inserting Data in the server receiving from the user (AnarchRegister.php)
    public function insertUser($email, $name, $encryptedPassword, $salt, $birthday)
    {

        // SQL Langauge - command to insert data
        $sql = "INSERT INTO Users SET email=?, name=?, password=?, salt=?, birthday=?, postcount=0, followercount=0, followingcount=0";

        // Preparing SQL for execution by checking the validity.
        $statement = $this->conn->prepare($sql);

        // if error
        if (!$statement) {
            throw new Exception($statement->error);
        }

        // Assigning variables instead of question marks after checking the preparation and validity of the SQL Command
        $statement->bind_param('sssss', $email, $name, $encryptedPassword, $salt, $birthday);

        // result will store the status / result of the execution of SQL Command
        $result = $statement->execute();
        return $result;
    }

    public function updateUser($email, $name, $encryptedPassword, $salt, $birthday, $id)
    {

        // SQL Langauge - command to insert data
        $sql = "UPDATE Users SET email=?, name=?, password=?, salt=?, birthday=? WHERE id=?";

        // Preparing SQL for execution by checking the validity.
        $statement = $this->conn->prepare($sql);

        // if error
        if (!$statement) {
            throw new Exception($statement->error);
        }

        // Assigning variables instead of question marks after checking the preparation and validity of the SQL Command
        $statement->bind_param('sssssi', $email, $name, $encryptedPassword, $salt, $birthday, $id);

        // result will store the status / result of the execution of SQL Command
        $result = $statement->execute();
        return $result;
    }

    function updateImageURL($type, $path, $id) {

        // update users set cover/ava=? where id=?
        $sql = 'UPDATE Users SET ' . $type . '=? WHERE id=?';

        $statement = $this->conn->prepare($sql);

        // if error occured while execution
        if (!$statement) {
            throw new Exception($statement->error);

        }

        $statement->bind_param('si', $path, $id);

        $result = $statement->execute();

        return $result;

    }

    public function selectUserID($id)
    {

        // array to store full user related information with the logic: key->Value Name->john example
        $returnArray = array();

        $sql = "SELECT * FROM Users WHERE id='" . $id . "'";


        // executing query via already established connection with the server
        $result = $this->conn->query($sql);

        // if result is not zero and it has at least 1 row / value / result
        if ($result != null && (mysqli_num_rows($result)) >= 1) {

            // then it executes result it will result everything in tables so fetch array will convert it to json
            $row = $result->fetch_array(MYSQLI_ASSOC);

            // assign fetched row to returnArray
            if (!empty($row)) {
                $returnArray = $row;
            }
        }

        // throw back ReturnArray information to user.
        return $returnArray;
    }

    function insertPP($type, $pp, $id) {

        $sql = 'UPDATE Users SET type=?, pp=? WHERE id=?';

        $statement = $this->conn->prepare($sql);

        if (!$statement) {
            throw new Exception($statement->error);
        }

        $statement->bind_param('ssi', $type, $pp, $id);

        $result = $statement->execute();

        return $result;
    }
    
    public function insertPosts($type, $picture, $postmessage, $user_id) {

        $sql = 'INSERT INTO posts SET type=?, picture=?, postmessage=?, user_id=?, commentscount=0, likescount=0';

        $statement = $this->conn->prepare($sql);

        if (!$statement) {
            throw new Exception($statement->error);
        }

        $statement->bind_param('sssi', $type, $picture, $postmessage, $user_id);

        $result = $statement->execute();

        return $result;
    }

   

    public function selectPosts($id, $offset, $limit) {
        $return = array();

        $sql = "SELECT posts.id,
                        posts.user_id,
                        posts.type,
                        posts.picture,
                        posts.postmessage,
                        posts.date_created,
                        Users.name,
                        Users.pp
                        
                        FROM posts 
                        LEFT JOIN Users ON Users.id = posts.user_id
                        
                        WHERE posts.user_id = $id
                        ORDER BY posts.date_created DESC LIMIT $limit OFFSET $offset";

        $statement = $this->conn->prepare($sql);

        if(!$statement) {
            throw new Exception($statement->error);
        }

        $statement->execute();

        $result = $statement->get_result();

        while ($row = $result->fetch_assoc()) {
            $return[] = $row;
        }
        return $return;
    }

    public function selectUserfromName($name)
    {

        // array to store full user related information with the logic: key->Value Name->john example
        $returnArray = array();

        $sql = "SELECT * FROM Users WHERE name='" . $name . "'";


        // executing query via already established connection with the server
        $result = $this->conn->query($sql);

        // if result is not zero and it has at least 1 row / value / result
        if ($result != null && (mysqli_num_rows($result)) >= 1) {

            // then it executes result it will result everything in tables so fetch array will convert it to json
            $row = $result->fetch_array(MYSQLI_ASSOC);

            // assign fetched row to returnArray
            if (!empty($row)) {
                $returnArray = $row;
            }
        }

        // throw back ReturnArray information to user.
        return $returnArray;

    }

    public function selectFollows($id, $limit, $offset) {
            
        $return = array();

        $sql = "SELECT follows.id,
                        follows.user_id,
                        follows.follow_id
        
                        FROM follows
                        
                        WHERE follows.user_id = $id
                        LIMIT $limit OFFSET $offset";

        $statement = $this->conn->prepare($sql);

        if (!$statement) {
            throw new Exception($statement->error);
        }

        $statement->execute();

        $result = $statement->get_result();

        while ($row = $result->fetch_assoc()) {
            $return[] = $row;
        }
        return $return;
    }

        public function selectUsers($name, $id, $limit, $offset) {
            
            $return = array();

            $sql = "SELECT Users.id,
                            Users.email,
                            Users.name,
                            Users.birthday,
                            Users.date_created,
                            Users.type,
                            Users.pp,
                            follows.follow_id AS followed_user
            
                            FROM Users

                            LEFT JOIN follows ON Users.id = follows.follow_id
                            
                            WHERE Users.id != $id AND Users.name LIKE '%$name%'
                            LIMIT $limit OFFSET $offset";

            $statement = $this->conn->prepare($sql);

            if (!$statement) {
                throw new Exception($statement->error);
            }

            $statement->execute();

            $result = $statement->get_result();

            while ($row = $result->fetch_assoc()) {
                $return[] = $row;
            }
            return $return;
        }

        public function insertFollow($user_id, $follow_id) {

            $sql = 'INSERT INTO follows SET user_id=?, follow_id=?';

            $statement = $this->conn->prepare($sql);

            if (!$statement) {
                throw new Expection($statement->error);
            }

            $statement->bind_param('ii', $user_id, $follow_id);

            $result = $statement->execute();

            return $result;

        }

        public function deleteFollow($user_id, $follow_id) {

            $sql = 'DELETE FROM follows WHERE user_id=? AND follow_id=?';

            $statement = $this->conn->prepare($sql);

            if (!$statement) {
                throw new Exception($statement->error);
            }

            $statement->bind_param('ii', $user_id, $follow_id);

            $result = $statement->execute();

            return $result;
        }

        public function selectPostsForFeed($id, $limit, $offset) {

            $return = array();

            $sql = "SELECT posts.id,
			posts.user_id,
			posts.picture,
			posts.postmessage,
			posts.date_created,
            posts.likescount,
            posts.commentscount,
            likes.post_id AS liked,
			Users.pp,
			Users.email,
			Users.name,
			Users.birthday
            
			FROM posts 
			
            LEFT JOIN likes ON posts.id = likes.post_id
			LEFT JOIN Users ON posts.user_id = Users.id
            
			
			WHERE posts.user_id IN
			
			(SELECT Users.id FROM follows LEFT JOIN Users ON (Users.id = follows.user_id AND follows.follow_id = $id OR Users.id = 
			follows.follow_id AND follows.user_id = $id) WHERE follows.user_id = $id OR follows.follow_id = $id)
			
			OR posts.user_id = $id
			
			ORDER BY posts.date_created DESC
			
			LIMIT 40 OFFSET 0";

              $statement = $this->conn->prepare($sql);

            if (!$statement) {
                throw new Exception($statement->error);
            }

            $statement->execute();

            $result = $statement->get_result();

            while ($row = $result->fetch_assoc()) {
                $return[] = $row;
            }
            return $return;

        }
    
    public function insertComment($post_id, $user_id, $comment) {

        $sql = 'INSERT comments SET post_id=?, user_id=?, comment=?';

        $statement = $this->conn->prepare($sql);

        if (!$statement) {
            throw new Expection($statement->error);
        }

        $statement->bind_param('iis', $post_id, $user_id, $comment);

        $result = $statement->execute();

        return $result;
    }

    public function selectComments($id, $limit, $offset) {
            
            $return = array();

            $sql = "SELECT comments.id, 
            comments.post_id, 
            comments.comment, 
            comments.date_created,
            comments.user_id,
            posts.postmessage,
            posts.picture,
            Users.name,
            Users.pp

            FROM comments

            LEFT JOIN posts ON posts.id = comments.post_id
            LEFT JOIN Users ON Users.id = comments.user_id

            WHERE posts.id = $id

            ORDER BY comments.date_created ASC LIMIT $limit OFFSET $offset";

            $statement = $this->conn->prepare($sql);

            if (!$statement) {
                throw new Exception($statement->error);
            }

            $statement->execute();

            $result = $statement->get_result();

            while ($row = $result->fetch_assoc()) {
                $return[] = $row;
            }
            return $return;
        }

        public function deleteComment($id) {

            $sql = 'DELETE FROM comments WHERE id=?';

            $statement = $this->conn->prepare($sql);

            if (!$statement) {
                throw new Exception($statement->error);
            }

            $statement->bind_param('i', $id);

            $result = $statement->execute();

            return $result;
        }

        public function deleteLike($post_id, $user_id) {

            $sql = 'DELETE FROM likes WHERE post_id=? AND user_id=?';

            $statement = $this->conn->prepare($sql);

            if (!$statement) {
                throw new Exception($statement->error);
            }

            $statement->bind_param('ii', $post_id, $user_id);

            $result = $statement->execute();

            return $result;
        }

        public function insertLike($post_id, $user_id) {

            $sql = 'INSERT likes SET post_id=?, user_id=?';
    
            $statement = $this->conn->prepare($sql);
    
            if (!$statement) {
                throw new Exception($statement->error);
            }
    
            $statement->bind_param('ii', $post_id, $user_id);
    
            $result = $statement->execute();
    
            return $result;
        }

        public function insertLikeCount($post_id) {
            $sql = 'UPDATE posts SET likescount= likescount+1 WHERE id=?';
    
            $statement = $this->conn->prepare($sql);
    
            if (!$statement) {
                throw new Exception($statement->error);
            }
    
            $statement->bind_param('i', $post_id);
    
            $result = $statement->execute();
    
            return $result;
        }

        public function deleteLikeCount($post_id) {
            $sql = 'UPDATE posts SET likescount= likescount-1 WHERE id=?';
    
            $statement = $this->conn->prepare($sql);
    
            if (!$statement) {
                throw new Exception($statement->error);
            }
    
            $statement->bind_param('i', $post_id);
    
            $result = $statement->execute();
    
            return $result;
        }

        public function selectLikes($id, $limit, $offset) {
            
            $return = array();

            $sql = "SELECT likes.id,
            likes.post_id,
            likes.date_created,
            likes.user_id,
            posts.postmessage,
            posts.picture,
            Users.name,
            Users.pp

            FROM likes

            LEFT JOIN posts ON posts.id = likes.post_id
            LEFT JOIN Users ON Users.id = likes.user_id

            WHERE posts.id = $id

            ORDER BY likes.date_created ASC LIMIT $limit OFFSET $offset";

            $statement = $this->conn->prepare($sql);

            if (!$statement) {
                throw new Exception($statement->error);
            }

            $statement->execute();

            $result = $statement->get_result();

            while ($row = $result->fetch_assoc()) {
                $return[] = $row;
            }
            return $return;
        }

        public function insertCommentCount($post_id) {
            $sql = 'UPDATE posts SET commentscount= commentscount+1 WHERE id=?';
    
            $statement = $this->conn->prepare($sql);
    
            if (!$statement) {
                throw new Exception($statement->error);
            }
    
            $statement->bind_param('i', $post_id);
    
            $result = $statement->execute();
    
            return $result;
        }

        public function deleteCommentCount($post_id) {
            $sql = 'UPDATE posts SET commentscount= commentscount-1 WHERE id=?';
    
            $statement = $this->conn->prepare($sql);
    
            if (!$statement) {
                throw new Exception($statement->error);
            }
    
            $statement->bind_param('i', $post_id);
    
            $result = $statement->execute();
    
            return $result;
        }

        public function insertPostCount($id) {
            $sql = 'UPDATE Users SET postcount= postcount+1 WHERE id=?';
    
            $statement = $this->conn->prepare($sql);
    
            if (!$statement) {
                throw new Exception($statement->error);
            }
    
            $statement->bind_param('i', $id);
    
            $result = $statement->execute();
    
            return $result;
        }

        public function insertFollowingCount($id) {
            $sql = 'UPDATE Users SET followingcount= followingcount+1 WHERE id=?';
    
            $statement = $this->conn->prepare($sql);
    
            if (!$statement) {
                throw new Exception($statement->error);
            }
    
            $statement->bind_param('i', $id);
    
            $result = $statement->execute();
    
            return $result;
        }

        public function deleteFollowingCount($id) {
            $sql = 'UPDATE Users SET followingcount= followingcount-1 WHERE id=?';
    
            $statement = $this->conn->prepare($sql);
    
            if (!$statement) {
                throw new Exception($statement->error);
            }
    
            $statement->bind_param('i', $id);
    
            $result = $statement->execute();
    
            return $result;
        }

        public function insertFollowerCount($id) {
            $sql = 'UPDATE Users SET followercount= followercount+1 WHERE id=?';
    
            $statement = $this->conn->prepare($sql);
    
            if (!$statement) {
                throw new Exception($statement->error);
            }
    
            $statement->bind_param('i', $id);
    
            $result = $statement->execute();
    
            return $result;
        }

        public function deleteFollowerCount($id) {
            $sql = 'UPDATE Users SET followercount= followercount-1 WHERE id=?';
    
            $statement = $this->conn->prepare($sql);
    
            if (!$statement) {
                throw new Exception($statement->error);
            }
    
            $statement->bind_param('i', $id);
    
            $result = $statement->execute();
    
            return $result;
        }

        public function insertNotification($byUser_id, $user_id, $type) {

            $sql = 'INSERT INTO notifications SET byUser_id=?, user_id=?, type=?';

            $statement = $this->conn->prepare($sql);

            if (!$statement) {
                throw new Expection($statement->error);
            }

            $statement->bind_param('iis', $byUser_id, $user_id, $type);

            $result = $statement->execute();

            return $result;

        }

        public function deleteNotification($byUser_id, $user_id) {

            $sql = 'DELETE FROM notifications WHERE byUser_id=? AND user_id=?';

            $statement = $this->conn->prepare($sql);

            if (!$statement) {
                throw new Expection($statement->error);
            }

            $statement->bind_param('ii', $byUser_id, $user_id);

            $result = $statement->execute();

            return $result;

        }

        public function selectNotifications($user_id, $limit, $offset) {
            
            $return = array();

            $sql = "SELECT notifications.byUser_id,
                    notifications.user_id,
                    notifications.type,
                    notifications.viewed,
                    notifications.date_created,
                    Users.name,
                    Users.pp

            FROM notifications

            LEFT JOIN Users ON Users.id = notifications.byUser_id

            WHERE notifications.user_id = $user_id

            ORDER BY notifications.date_created ASC LIMIT $limit OFFSET $offset";

            $statement = $this->conn->prepare($sql);

            if (!$statement) {
                throw new Exception($statement->error);
            }

            $statement->execute();

            $result = $statement->get_result();

            while ($row = $result->fetch_assoc()) {
                $return[] = $row;
            }
            return $return;
        }

}

    ?>