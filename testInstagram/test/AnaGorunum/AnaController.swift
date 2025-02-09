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
    var userid: Int?
    
    let hucreID = "hucreID"
    
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
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: hucreID, for: indexPath) as! AnaPaylasimCell
        hucre.post = posts?[indexPath.item]
        hucre.delegate = self
        hucre.delegateobjc = self
        hucre.isHidden = false
        return hucre
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let genislik = view.frame.width
        var yukseklik : CGFloat = 75
        yukseklik += view.frame.width
        yukseklik += 50
        yukseklik += 70
        return CGSize(width: genislik, height: yukseklik)
    }
    
    
    
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
        navigationItem.titleView?.tintColor = .black
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(AnaCollectionView)
        
        guard let id = currentUser?["id"] as? String else { return }
         fetchedID = id
        guard let user_id = Int(fetchedID!) else {return}
        userid = user_id
        
        AnaCollectionView.delegate = self
        AnaCollectionView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(paylasimlariYenile), for: .valueChanged)
        AnaCollectionView.refreshControl = refreshControl
        
        AnaCollectionView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        buttonlariOlustur()
        fetchUser()
        fetchPosts()
        AnaCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(paylasimlariYenile), name: GuncelleNotification.GuncelleNotification, object: nil )
    }
    @objc fileprivate func paylasimlariYenile() {
        fetchUser()
        fetchPosts()
        AnaCollectionView.reloadData()
        AnaCollectionView.refreshControl?.endRefreshing()
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
                print(json!["user"] as Any)
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
            
            let url = URL(string: "http://54.67.91.186/loadfeed.php")!
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
                        post.liked = dictionary["liked"] as? Int
                        post.likescount = dictionary["likescount"] as? Int
                        post.commentscount = dictionary["commentscount"] as? Int
                        
                        posts.append(post)
                    
                        print(dictionary["id"]!)
                        
                    }
                    print(json!["posts"] as Any)
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

extension AnaController : AnaPaylasimCellDelegateObjc {
    @objc func yorumGuncelle(cell: AnaPaylasimCell) {
        guard let indexPath = AnaCollectionView.indexPath(for: cell) else {return}
        //let post = self.posts![indexPath.item]
        self.AnaCollectionView.reloadItems(at: [indexPath])
    }

}

extension AnaController : AnaPaylasimCellDelegate {
    
    
    func paylasimBegenildi(cell: AnaPaylasimCell) {
        guard let user_id = Int(fetchedID!) else {return}
        guard let indexPath = AnaCollectionView.indexPath(for: cell) else {return}
        let post = self.posts![indexPath.item]
        let post_user_id = post.userid
        
        if post.liked != nil {
            let url = URL(string: "http://54.67.91.186/likes.php")!
            let body = "action=delete&post_id=\(post.id!)&user_id=\(user_id)&post_user_id=\(post_user_id!)"
            var request = URLRequest(url: url)
            request.httpBody = body.data(using: .utf8)
            request.httpMethod = "POST"
            URLSession.shared.dataTask(with: request) { (data, response, error) in DispatchQueue.main.async {
                
                let helper = Validation()
                
                if error != nil {
                    helper.showAlert(title: "Server Error", message: error!.localizedDescription, from: self)
                    return
                }
                
                do {
                    guard let data = data else {
                        helper.showAlert(title: "Data Error", message: error!.localizedDescription, from: self)
                        return
                    }
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                    
                    guard let parsedJSON = json else { return }
                    
                    if parsedJSON["status"] as? String == "200"{
                        print("Success")
                        post.liked = nil
                        post.likescount = post.likescount! - 1
                        self.AnaCollectionView.reloadItems(at: [indexPath])
                    } else { print("Error") }
                        
                    print(json as Any)
                    
                } catch {
                    helper.showAlert(title: "Json Error", message: error.localizedDescription, from: self)
                }
            }
                
            }.resume()
        } else {
            let url = URL(string: "http://54.67.91.186/likes.php")!
            let body = "action=insert&post_id=\(post.id!)&user_id=\(user_id)&post_user_id=\(post_user_id!)"
            var request = URLRequest(url: url)
            request.httpBody = body.data(using: .utf8)
            request.httpMethod = "POST"
            URLSession.shared.dataTask(with: request) { (data, response, error) in DispatchQueue.main.async {
                
                let helper = Validation()
                
                if error != nil {
                    helper.showAlert(title: "Server Error", message: error!.localizedDescription, from: self)
                    return
                }
                
                do {
                    guard let data = data else {
                        helper.showAlert(title: "Data Error", message: error!.localizedDescription, from: self)
                        return
                    }
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                    
                    guard let parsedJSON = json else { return }
                    
                    if parsedJSON["status"] as? String == "200"{
                        print("Success")
                        post.liked = self.userid
                        post.likescount = post.likescount! + 1
                        self.AnaCollectionView.reloadItems(at: [indexPath])
                    } else { print("Error") }
                        
                    print(json as Any)
                    
                } catch {
                    helper.showAlert(title: "Json Error", message: error.localizedDescription, from: self)
                }
            }
                
            }.resume()
        }
        
       
        
    }
    
    func yorumaBasildi(post: Post) {
        let yorumlarController = YorumlarController()
        yorumlarController.post = post
        navigationController?.pushViewController(yorumlarController, animated: true)
       // print(post.id)
    }
    
    func begeniCountBasildi(post: Post) {
        let begenilerController = BegenilerController()
        begenilerController.post = post
        navigationController?.pushViewController(begenilerController, animated: true)
    }
}
