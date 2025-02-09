//
//  YorumlarViewController.swift
//  test
//
//  Created by kaan on 7.02.2025.
//

import UIKit

class YorumlarController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var post : Post?
    var comments: [Comment]?
    var fetchedID : String?
    
    
    lazy var YorumlarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.alwaysBounceVertical = true
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -100, right: 0)
        cv.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -100, right: 0)
        cv.keyboardDismissMode = .interactive
        cv.register(YorumCell.self, forCellWithReuseIdentifier: "yorumCellID")
      
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let id = currentUser?["id"] as? String else { return }
        fetchedID = id
        navigationItem.title = "Yorumlar"
        view.addSubview(YorumlarCollectionView)
        YorumlarCollectionView.backgroundColor = .white
        YorumlarCollectionView.delegate = self
        YorumlarCollectionView.dataSource = self
        
        YorumlarCollectionView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        yorumlariGetir()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "yorumCellID", for: indexPath) as! YorumCell
        cell.comment = comments?[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.height, height: 60)
        let geciciCell = YorumCell(frame: frame)
        geciciCell.comment = comments![indexPath.row]
        geciciCell.layoutIfNeeded()
        
        let hedefBoyut = CGSize(width: view.frame.width, height: 9999)
        let tahminiBoyut = geciciCell.systemLayoutSizeFitting(hedefBoyut)
        
        let yukseklik = max(60, tahminiBoyut.height)
        return CGSize(width: view.frame.width, height: yukseklik)
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
    
    lazy var containerView : UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
        
        let btnYorumGonder = UIButton(type: .system)
        btnYorumGonder.setTitle("Gonder", for: .normal)
        btnYorumGonder.setTitleColor(.black, for: .normal)
        btnYorumGonder.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        btnYorumGonder.addTarget(self, action: #selector(btnYorumGonderPressed), for: .touchUpInside)
        
        containerView.addSubview(btnYorumGonder)
        btnYorumGonder.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: containerView.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: -15, width: 80, height: 0)
        
        containerView.addSubview(txtYorum)
        
        txtYorum.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, leading: containerView.safeAreaLayoutGuide.leadingAnchor, trailing: btnYorumGonder.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        let ayracView = UIView()
        ayracView.backgroundColor = UIColor.rgbDonustur(red: 230, green: 230, blue: 230)
        containerView.addSubview(ayracView)
        ayracView.anchor(top: containerView.topAnchor, bottom: nil, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.7)
        return containerView
    }()
    
    let txtYorum : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Yorumunuzu Girin..."
        return txt
    }()
    
    func yorumlariGetir() {
        yorumlariGetir { (comments: [Comment]) in
            self.comments = comments
            self.YorumlarCollectionView.reloadData()
        }
    }
    
    fileprivate func yorumlariGetir(completion: @escaping ([Comment]) -> ()) {
        comments?.removeAll()
        let limit: Int = 10000
        let offset: Int = 0
        
        let url = URL(string: "http://54.67.91.186/comments.php")!
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
                
                var comments = [Comment]()
                
                for dictionary in json!["comments"] as! [[String: AnyObject]] {
                    print(json!["comments"] as Any)
                    
                    let comment = Comment()
                    comment.id = dictionary["id"] as? Int
                    comment.post_id = dictionary["post_id"] as? Int
                    comment.user_id = dictionary["user_id"] as? Int
                    comment.comment = dictionary["comment"] as? String
                    comment.picture = dictionary["picture"] as? String
                    comment.postmessage = dictionary["postmessage"] as? String
                    comment.username = dictionary["name"] as? String
                    comment.userpp = dictionary["pp"] as? String
                    comment.date_created = dictionary["date_created"] as? String
                  
                    comments.append(comment)
                
                    print(dictionary["id"]!)
                    
                }
                
                DispatchQueue.main.async {
                    completion(comments)
                }
                
            } catch {
                print("JSON Error")
                return
            }
        }.resume()
    }
    
    
    @objc fileprivate func btnYorumGonderPressed() {
        guard let user_id = Int(fetchedID!) else {return}
        if let yorum = txtYorum.text, yorum.isEmpty {
            return
        }
        yorumGonder(post_id: post!.id!, user_id: user_id, comment: txtYorum.text ?? "")
        yorumlariGetir()
    }
    
    func yorumGonder(post_id: Int, user_id: Int, comment: String) {
        let url = URL(string: "http://54.67.91.186/comments.php")!
        let body = "action=insert&post_id=\(post_id)&user_id=\(user_id)&comment=\(comment)"
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
                    self.txtYorum.text = ""
                } else { print("Error") }
                    
                print(json as Any)
                
            } catch {
                helper.showAlert(title: "Json Error", message: error.localizedDescription, from: self)
            }
        }
            
        }.resume()
        
    }
    
    override var inputAccessoryView: UIView? {
        get {
           return containerView
        }
    }
}

extension YorumlarController : YorumCellDelegate {
    func yorumSil(comment: Comment) {
        
            let url = URL(string: "http://54.67.91.186/comments.php")!
            let body = "action=delete&post_id=\(post!.id!)&id=\(comment.id!)"
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
                        self.txtYorum.text = ""
                        self.yorumlariGetir()
                    } else { print("Error") }
                        
                    print(json as Any)
                    
                } catch {
                    helper.showAlert(title: "Json Error", message: error.localizedDescription, from: self)
                }
            }
                
            }.resume()
    }
}
