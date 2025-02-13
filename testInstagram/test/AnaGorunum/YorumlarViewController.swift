//
//  YorumlarViewController.swift
//  test
//
//  Created by kaan on 7.02.2025.
//

import UIKit
import CoreMIDI

class YorumlarController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var post : Post?
    var comments: [Comment]?
    var fetchedID : String?

    private var collectionViewBottomConstraint: NSLayoutConstraint!
    private var containerHeightConstraint: NSLayoutConstraint!
    private var containerBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = currentUser?["id"] as? String else { return }
        fetchedID = id
        navigationItem.title = "Yorumlar"
        view.addSubview(YorumlarCollectionView)
        YorumlarCollectionView.backgroundColor = .white
        YorumlarCollectionView.delegate = self
        YorumlarCollectionView.dataSource = self
        view.addSubview(containerView)
        containerView.addSubview(txtYorum)
        
        collectionViewBottomConstraint = YorumlarCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 60)
        containerView.addSubview(btnYorumGonder)
        
        NSLayoutConstraint.activate([
            YorumlarCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            YorumlarCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            YorumlarCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        collectionViewBottomConstraint,
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        containerBottomConstraint,
        containerHeightConstraint,
            txtYorum.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            txtYorum.trailingAnchor.constraint(equalTo: btnYorumGonder.leadingAnchor, constant: -8),
            txtYorum.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            txtYorum.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            btnYorumGonder.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            btnYorumGonder.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            btnYorumGonder.widthAnchor.constraint(equalToConstant: 60)])
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        registerKeyboardNotifications()
        yorumlariGetir()
    }
    
    @objc fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
    
    lazy var YorumlarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.alwaysBounceVertical = true
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -100, right: 0)
        cv.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -100, right: 0)
        cv.keyboardDismissMode = .interactive
        cv.register(YorumCell.self, forCellWithReuseIdentifier: "yorumCellID")
      
        return cv
    }()
    
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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "yorumCellID", for: indexPath) as? YorumCell else {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        cell.comment = comments?[indexPath.item]
        cell.delegate = self
        
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        
        let targetSize = CGSize(width: collectionView.frame.width, height: UIView.layoutFittingCompressedSize.height)
        let fittingSize = cell.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        
        return CGSize(width: collectionView.frame.width, height: fittingSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.post(name: GuncelleNotification.GuncelleNotification, object: nil)
    }
    
    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(_ nofitification: Notification) {
        if let keyboardFrame = nofitification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, let duration = nofitification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                containerBottomConstraint.constant = -keyboardFrame.height
                collectionViewBottomConstraint.constant = -keyboardFrame.height
                UIView.animate(withDuration: duration) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
        containerBottomConstraint.constant = 0
        collectionViewBottomConstraint.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    }
    
    lazy var containerView : UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .systemGray5
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    lazy var txtYorum : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isScrollEnabled = false
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        return textView
    }()
    
    lazy var btnYorumGonder: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Gonder", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        btn.addTarget(self, action: #selector(btnYorumGonderPressed), for: .touchUpInside)
        return btn
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
        let post_user_id = post!.user_id
        let url = URL(string: "http://54.67.91.186/comments.php")!
        let body = "action=insert&post_id=\(post_id)&user_id=\(user_id)&comment=\(comment)&post_user_id=\(post_user_id!)"
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
    
    
}

extension YorumlarController : YorumCellDelegate {
    func yorumSil(comment: Comment) {
        guard let user_id = Int(fetchedID!) else {return}
            let post_user_id = post!.user_id
            let url = URL(string: "http://54.67.91.186/comments.php")!
            let body = "action=delete&post_id=\(post!.id!)&id=\(comment.id!)&user_id=\(user_id)&post_user_id=\(post_user_id!)"
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

extension YorumlarController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
      
        let maxHeight: CGFloat = 150
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude))
        let newHeight = min(max(size.height + 16, 60), maxHeight)
        
        if newHeight != containerHeightConstraint.constant {
            containerHeightConstraint.constant = newHeight
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
