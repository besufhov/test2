//
//  BegenilerController.swift
//  test
//
//  Created by kaan on 8.02.2025.
//

import UIKit

class BegenilerController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var post : Post?
    var likes: [Like]?
    var fetchedID : String?
    
    lazy var BegenilerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.alwaysBounceVertical = true
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -100, right: 0)
        cv.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -100, right: 0)
        cv.keyboardDismissMode = .interactive
        cv.register(BegeniCell.self, forCellWithReuseIdentifier: "yorumCellID")
      
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let id = currentUser?["id"] as? String else { return }
        fetchedID = id
        navigationItem.title = "Begeniler"
        view.addSubview(BegenilerCollectionView)
        BegenilerCollectionView.backgroundColor = .white
        BegenilerCollectionView.delegate = self
        BegenilerCollectionView.dataSource = self
        
        BegenilerCollectionView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        begenileriGetir()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "yorumCellID", for: indexPath) as! BegeniCell
        cell.like = likes?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.post(name: GuncelleNotification.GuncelleNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func begenileriGetir() {
        begenileriGetir { (likes: [Like]) in
            self.likes = likes
            self.BegenilerCollectionView.reloadData()
        }
    }
    
    fileprivate func begenileriGetir(completion: @escaping ([Like]) -> ()) {
        //comments?.removeAll()
        let limit: Int = 10000
        let offset: Int = 0
        
        let url = URL(string: "http://54.67.91.186/likes.php")!
        let body = "action=select&id=\(post!.id!)&offset=\(offset)&limit=\(limit)"
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
                
                var likes = [Like]()
                
                for dictionary in json!["likes"] as! [[String: AnyObject]] {
                
                    let like = Like()
                    like.id = dictionary["id"] as? Int
                    like.post_id = dictionary["post_id"] as? Int
                    like.user_id = dictionary["user_id"] as? Int
                    like.userpp = dictionary["pp"] as? String
                    like.username = dictionary["name"] as? String
                    like.date_created = dictionary["date_created"] as? String
                  
                    likes.append(like)
                
                    print(dictionary["id"]!)
                    
                }
                
                DispatchQueue.main.async {
                    completion(likes)
                }
                
                print(json!["likes"] as Any)
                
            } catch {
                print("JSON Error")
                return
            }
        }.resume()
    }
}
