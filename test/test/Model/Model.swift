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
    var name: String?
    var birthday: String?
    var type: String?
    var pp: String?
    var followed_user: Int?
}

class Post: NSObject {
    
    var id: Int?
    var userid: Int?
    var likes: Int?
    var picture: String?
    var type: String?
    var postmessage: String?
    var pp: String?
    var name: String?
    var date: String?
    var followingid: Int?
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
