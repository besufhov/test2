//
//  Model.swift
//  test
//
//  Created by kaan on 27.01.2025.
//


import UIKit

class User: NSObject {
    var id: Int?
    var email: String?
    var password: String?
    var name: String?
    var birthday: String?
    var type: String?
    var pp: String?
    var followed_user: Int?
}

class Like: NSObject {
    var id: Int?
    var post_id: Int?
    var user_id: Int?
    var userpp: String?
    var username: String?
    var date_created: String?
}

class Bildiri: NSObject {
    var id: Int?
    var byUser_id: Int?
    var user_id: Int?
    var type: String?
    var viewed: String?
    var userpp: String?
    var username: String?
    var date_created: String?
}

class Comment: NSObject {
    var id: Int?
    var post_id: Int?
    var user_id: Int?
    var comment: String?
    var date_created: String?
    var postmessage: String?
    var picture: String?
    var username: String?
    var userpp: String?
}

class Post: NSObject {
    
    var id: Int?
    var user_id: Int?
    var is_liked_by_me: Int?
    var picture: String?
    var type: String?
    var postmessage: String?
    var pp: String?
    var name: String?
    var date: String?
    var followingid: Int?
    var liked: Int?
    var likescount: Int?
    var commentscount: Int?
}

class ResizableInputAccessoryView: UIView {
    var targetHeight : CGFloat = 50 {
        didSet {
            self.frame.size.height = targetHeight
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
}

struct Kullanici {
    let id: Int
    let email: String
    let name: String
    let birthday: String
    let type: String
    let pp: String
    init(dictionary: [String : Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.email = dictionary["email"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.birthday = dictionary["birthday"] as? String ?? ""
        self.type = dictionary["type"] as? String ?? ""
        self.pp = dictionary["pp"] as? String ?? ""
    }
}
