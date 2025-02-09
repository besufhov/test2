//
//  KullaniciAraController.swift
//  test
//
//  Created by kaan on 31.01.2025.
//

import UIKit


class KullaniciAraController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    let hucreID = "hucreID"
    
    var limit = 100
    var skip = 0
    
    var users: [User]?
    
    lazy var searchBar : UISearchBar = {
       let sb = UISearchBar()
        sb.placeholder = "Kullanici adini giriniz"
       // UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgbDonustur(red: 230, green: 230, blue: 230)
        sb.delegate = self
        
        return sb
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        fetchUser(limit: limit, offset: skip, name: searchText.lowercased()) { (users: [User]) in
                self.users = users
            
            self.KullaniciCollectionView.reloadData()
        }
                
    }
    
    lazy var KullaniciCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(KullaniciAraCell.self, forCellWithReuseIdentifier: hucreID)
        cv.alwaysBounceVertical = true
        cv.keyboardDismissMode = .onDrag
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(KullaniciCollectionView)
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        
        searchBar.anchor(top: navBar?.topAnchor, bottom: navBar?.bottomAnchor, leading: navBar?.leadingAnchor, trailing: navBar?.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: -10, width: 0, height: 0)
        KullaniciCollectionView.delegate = self
        KullaniciCollectionView.dataSource = self
        
        KullaniciCollectionView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        // searchText.isEmpty baslangicta calismiyor
        fetchUser(limit: limit, offset: skip, name: "") { (users: [User]) in
            self.users = users
            self.KullaniciCollectionView.reloadData()
            
        }
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: hucreID, for: indexPath) as! KullaniciAraCell
        hucre.user = users?[indexPath.item]
       
       
        return hucre
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        let kullanici = users?[indexPath.item]
        let kullaniciProfilController = KullaniciProfilController()
        let kullanicitakipid = kullanici?.followed_user
       // let kullanicitakipid : String = "\(String(describing: kullanici?.followed_user))"
        kullaniciProfilController.takipEdiliyorID = kullanicitakipid
        // do not use ? it wraps it to Optional() so sends etc. Optional(80) instead 80
        let kullanicistringid: String = "\(String(describing: kullanici!.id!))"
        kullaniciProfilController.baskaKullaniciID = kullanicistringid
        navigationController?.pushViewController(kullaniciProfilController, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        fetchUser(limit: limit, offset: skip, name: "") { (users: [User]) in
            self.users = users
            self.KullaniciCollectionView.reloadData()
        }
        
    }
    
    fileprivate func fetchUser(limit: Int, offset: Int, name: String, completion: @escaping ([User]) -> ()) {
        
        guard let id = currentUser?["id"] else { return }
        //users?.removeAll()
            
            let url = URL(string: "http://54.67.91.186/selectusers.php")!
            let body = "action=search&name=\(name)&id=\(id)&limit=\(limit)&offset=\(offset)"
            var request = URLRequest(url: url)
            request.httpBody = body.data(using: .utf8)
            request.httpMethod = ("POST")
            
            URLSession.shared.dataTask(with: request) {(data, response, error) in
                
                    if error != nil {
                        return
                    }
                    
                    do {
                        guard let data = data else {
                            return
                        }
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                     
                        var users = [User]()
                        
                        for dictionary in json!["users"] as! [[String: AnyObject]] {
                            print(json!["users"] as Any)
                            
                            let user = User()
                            user.id = dictionary["id"] as? Int
                            user.name = dictionary["name"] as? String
                            user.pp = dictionary["pp"] as? String
                            user.followed_user = dictionary["followed_user"] as? Int
                         
                            users.append(user)
                        }
                            DispatchQueue.main.async {
                                completion(users)
                            }
                            
                        } catch {
                            print("JSON Error")
                            self.users?.removeAll()
                            DispatchQueue.main.async {
                            self.KullaniciCollectionView.reloadData()
                            }
                            return
                        }
                    }.resume()
                }
    
    
    
    }
    
    
   
    
   
    
    
    
    
   

