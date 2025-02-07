//
//  AnaController.swift
//  test
//
//  Created by kaan on 30.01.2025.
//

import UIKit

class AnaController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var cUser: User?
    var posts: [Post]?
    var fetchedID: String?
    
    func fetchUser() {
        fetchUser { (cUser: User) in
            self.cUser = cUser
            //self.navigationItem.title = cUser.name
            //self.lblKullaniciAdi.text = cUser.name
          //  self.setupThumbnailImage()
        }
    }
    
   
    
    func fetchPosts() {
        fetchPosts { (posts: [Post]) in
            self.posts = posts
            self.AnaCollectionView.reloadData()
            print("OOOOOOOO")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: hucreID, for: indexPath) as! AnaPaylasimCell
        hucre.post = posts?[indexPath.item]
        hucre.isHidden = false
        return hucre
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let genislik = view.frame.width
        var yukseklik : CGFloat = 55
        yukseklik += view.frame.width
        yukseklik += 50
        yukseklik += 70
        return CGSize(width: genislik, height: yukseklik)
    }
    
    
    let hucreID = "hucreID"
    
    lazy var AnaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(AnaPaylasimCell.self, forCellWithReuseIdentifier: hucreID)
      
        return cv
    }()
    
    fileprivate func buttonlariOlustur() {
        let img = UIImage(named: "Instagram_logo_white")
        navigationItem.titleView = UIImageView(image: img)
        navigationItem.titleView?.backgroundColor = .red
        navigationItem.titleView?.tintColor = .black
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(AnaCollectionView)
        
        AnaCollectionView.delegate = self
        AnaCollectionView.dataSource = self
        
        AnaCollectionView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        buttonlariOlustur()
        fetchUser()
        fetchPosts()
        AnaCollectionView.reloadData()
    }
    
   
    
    
    
    func fetchUser(completion: @escaping (User) -> ()) {
        
       guard let id = currentUser?["id"] as? String else { return }
        fetchedID = id
        
        let url = URL(string: "http://54.67.91.186/user.php")!
        let body = "id=\(id)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
       
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if error != nil {
                print("Server Error")
                return
            }
            
            do {
                guard let data = data else {
                    print("Data Error")
                    return
                }
                
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                
                var cUser = User()
                
                for dictionary in json!["user"] as! [[String: AnyObject]] {
                    print(json!["user"] as Any)
                    
                    let user = User()
                    user.id = dictionary["id"] as? Int
                    user.email = dictionary["email"] as? String
                    user.name = dictionary["name"] as? String
                    user.birthday = dictionary["birthday"] as? String
                    user.type = dictionary["type"] as? String
                    user.pp = dictionary["pp"] as? String
                    
                    
                    cUser = user
                
                    print(dictionary["id"]!)
                    
                }
                
                DispatchQueue.main.async {
                    completion(cUser)
                }
                
            } catch {
                print("JSON Error")
                return
            }
        }.resume()
    }
    
        func fetchPosts(completion: @escaping ([Post]) -> ()) {
            
            posts?.removeAll()
            let limit: Int = 10000
            let offset: Int = 0
            
            let url = URL(string: "http://54.67.91.186/loadposts.php")!
            let body = "id=\(fetchedID!)&offset=\(offset)&limit=\(limit)"
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = body.data(using: .utf8)
           
            URLSession.shared.dataTask(with: request) {(data, response, error) in
                
                if error != nil {
                    print("Server Error")
                    return
                }
                
                do {
                    guard let data = data else {
                        print("Data Error")
                        return
                    }
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                    
                    var posts = [Post]()
                    
                    for dictionary in json!["posts"] as! [[String: AnyObject]] {
                        print(json!["posts"] as Any)
                        
                        let post = Post()
                        post.id = dictionary["id"] as? Int
                        post.userid = dictionary["user_id"] as? Int
                        post.likes = dictionary["likes"] as? Int
                        post.type = dictionary["type"] as? String
                        post.picture = dictionary["picture"] as? String
                        post.postmessage = dictionary["postmessage"] as? String
                        post.name = dictionary["name"] as? String
                        post.pp = dictionary["pp"] as? String
                        post.date = dictionary["date_created"] as? String
                        
                        posts.append(post)
                    
                        print(dictionary["id"]!)
                        
                    }
                    
                    DispatchQueue.main.async {
                        completion(posts)
                    }
                    
                } catch {
                    print("JSON Error")
                    return
                }
            }.resume()
        }    
        
    
   
}
