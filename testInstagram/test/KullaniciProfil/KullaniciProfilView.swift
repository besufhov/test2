//
//  KullaniciProfilView.swift
//  test
//
//  Created by kaan on 26.01.2025.
//

import Foundation
import UIKit

class KullaniciProfilController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UpdatesDelegate {
    
    var cUser: User?
    var posts: [Post]?
    
    var baskaKullaniciID : String?
    var userID: String?
    var takipEdiliyorID : Int?
    
    
    func didFinishUpdates() {
        print("didFinish")
    }
    
    
    
    func fetchUser() {
        fetchUser(id: userID!) { [self] (cUser: User) in
            self.cUser = cUser
            self.navigationItem.title = cUser.name
            self.lblKullaniciAdi.text = cUser.name
            self.setupThumbnailImage()
            let kullanicistringid: String = "\(String(describing: cUser.id!))"
            
            if userID == baskaKullaniciID && self.cUser?.followed_user == nil {
                btnProfilDuzenle.setTitle("Takip Et", for: .normal)
                
            } else if kullanicistringid == userID {
                btnProfilDuzenle.setTitle("Profil Duzenle", for: .normal)
                
            } else if self.cUser?.followed_user != nil {
                btnProfilDuzenle.setTitle("Takip Ediliyor", for: .normal)
            }
        }
    }
    
    func fetchPosts() {
        fetchPosts(id: userID!) { (posts: [Post]) in
            self.posts = posts
            self.ProfileCollectionView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchPosts()
        fetchUser()
    }
    
    let header : UIView = {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    let imgProfilGoruntu : CustomImageView = {
        let img = CustomImageView()
      
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    lazy var ProfileCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(KullaniciProfilCell.self, forCellWithReuseIdentifier: "cellID")
        return cv
    }()
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! KullaniciProfilCell
       // cell.backgroundColor = .purple
        cell.post = posts?[indexPath.item]
        cell.isHidden = false
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let genislik = (view.frame.width - 5) / 3
        return CGSize(width: genislik, height: genislik)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    let lblKullaniciAdi : UILabel = {
        let lbl = UILabel()
        lbl.text = "Empty"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let lblPaylasim : UILabel = {
        let lbl = UILabel()
        let attrText = NSMutableAttributedString(string: "10\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 15)])
        attrText.append(NSAttributedString(string: "Paylasim", attributes: [.foregroundColor : UIColor.darkGray, .font : UIFont.systemFont(ofSize: 15)]))
        lbl.attributedText = attrText
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let lblTakipci : UILabel = {
        let lbl = UILabel()
        let attrText = NSMutableAttributedString(string: "25\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 15)])
        attrText.append(NSAttributedString(string: "Takipci", attributes: [.foregroundColor : UIColor.darkGray, .font : UIFont.systemFont(ofSize: 15)]))
        lbl.attributedText = attrText
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let lblTakipEdiliyor : UILabel = {
        let lbl = UILabel()
        let attrText = NSMutableAttributedString(string: "20\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 15)])
        attrText.append(NSAttributedString(string: "Takip", attributes: [.foregroundColor : UIColor.darkGray, .font : UIFont.systemFont(ofSize: 15)]))
        lbl.attributedText = attrText
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var btnProfilDuzenle : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(btnProfil_Takip_Duzenle), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func btnProfil_Takip_Duzenle() {
       if btnProfilDuzenle.currentTitle == "Takip Et" {
            //print(takipEdilecekID!)
           guard let id = currentUser?["id"] as? String else { return }
            let url = URL(string: "http://54.67.91.186/follow.php")!
           let body = "action=follow&user_id=\(id)&follow_id=\(cUser!.id!)"
            var request = URLRequest(url: url)
            request.httpBody = body.data(using: .utf8)
            request.httpMethod = "POST"
            URLSession.shared.dataTask(with: request) { (data, response, error) in DispatchQueue.main.async {
                
                if error != nil {
                    return
                }
                do {
                    guard let data = data else {
                        return
                    }
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                    
                    guard let parsedJSON = json else { return }
                    
                    if parsedJSON["status"] as? String == "200"{
                        print("Success")
                        self.btnProfilDuzenle.setTitle("Takip Ediliyor", for: .normal)
                    } else { print("Error") }
                        
                    print(json as Any)
                } catch {
                }
            }
                
            }.resume()
       } else if btnProfilDuzenle.currentTitle == "Takip Ediliyor"{
           guard let id = currentUser?["id"] as? String else { return }
           let url = URL(string: "http://54.67.91.186/follow.php")!
          let body = "action=unfollow&user_id=\(id)&follow_id=\(cUser!.id!)"
           var request = URLRequest(url: url)
           request.httpBody = body.data(using: .utf8)
           request.httpMethod = "POST"
           URLSession.shared.dataTask(with: request) { (data, response, error) in DispatchQueue.main.async {
               
               if error != nil {
                   return
               }
               do {
                   guard let data = data else {
                       return
                   }
                   let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                   
                   guard let parsedJSON = json else { return }
                   
                   if parsedJSON["status"] as? String == "200"{
                       print("Success")
                       self.btnProfilDuzenle.setTitle("Takip Et", for: .normal)
                   } else { print("Error") }
                       
                   print(json as Any)
               } catch {
               }
           }
               
           }.resume()
       } else if btnProfilDuzenle.currentTitle == "Profil Duzenle" {
           let profilDuzenle = ProfilDuzenle()
           profilDuzenle.txtEmail.text = cUser?.email
           profilDuzenle.txtKullaniciAdi.text = cUser?.name
           profilDuzenle.navigationItem.title = "Profil Duzenle"
           navigationController?.pushViewController(profilDuzenle, animated: true)
       }
    }
    
    let btnGrid : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "grid"), for: .normal)
        return btn
    }()
    
    let btnListe : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "list"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        return btn
    }()
    
    let btnRibbon : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "ribbon"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        return btn
    }()
    
  
    
    fileprivate func takipButonuAyarla() {
    
       // if userID == baskaKullaniciID && takipEdiliyorID == nil {
     //       btnProfilDuzenle.setTitle("Takip Et", for: .normal)
    //    } else if userID == currentUser?["id"] as? String ?? "" {
   //         btnProfilDuzenle.setTitle("Profil Duzenle", for: .normal)
   //     } else if takipEdiliyorID != nil {
       //     btnProfilDuzenle.setTitle("Takip Ediliyor", for: .normal)
   //     }
        
    }
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       // guard let id = currentUser?["id"] as? String else { return }
        let id = baskaKullaniciID ?? currentUser?["id"] as? String ?? ""
        userID = id
       takipButonuAyarla()
        
        view.backgroundColor = .white
        fetchUser()
        view.addSubview(header)
        view.addSubview(imgProfilGoruntu)
        view.addSubview(lblKullaniciAdi)
        view.addSubview(ProfileCollectionView)
        ProfileCollectionView.delegate = self
        ProfileCollectionView.dataSource = self
        
        
        header.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: view.frame.width, height: 200)
        
        let goruntuBoyut : CGFloat = 90
        imgProfilGoruntu.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: nil, paddingTop: 15, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: goruntuBoyut, height: goruntuBoyut)
        imgProfilGoruntu.layer.cornerRadius = goruntuBoyut / 2
        imgProfilGoruntu.clipsToBounds = true
        toolbarOlustur()
        lblKullaniciAdi.anchor(top: imgProfilGoruntu.bottomAnchor, bottom: btnGrid.topAnchor, leading: view.leadingAnchor, trailing: nil, paddingTop: 5, paddingBottom: 0, paddingLeft: 25, paddingRight: 0, width: 0, height: 0)
        kullaniciDurumBilgisiGoster()
        view.addSubview(btnProfilDuzenle)
        btnProfilDuzenle.anchor(top: lblTakipci.bottomAnchor, bottom: nil, leading: lblPaylasim.leadingAnchor, trailing: lblTakipEdiliyor.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 20, paddingRight: -20, width: 0, height: 35)
        ProfileCollectionView.anchor(top: btnListe.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        btnOturumKapatOlustur()
        fetchPosts()
        ProfileCollectionView.reloadData()
    }
    
    
    
    
    func btnOturumKapatOlustur() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "gear")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(oturumuKapat))
    }
    
    @objc func oturumuKapat() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionOturumuKapat = UIAlertAction(title: "Oturumu Kapat", style: .destructive) { (_) in
            do {
                self.resetDefaults()
                let oturumAcController = OturumAcController()
                let navController = UINavigationController(rootViewController: oturumAcController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
        }
        let actionIptalEt = UIAlertAction(title: "Iptal et", style: .cancel, handler: nil)
        alertController.addAction(actionOturumuKapat)
        alertController.addAction(actionIptalEt)
        present(alertController, animated: true, completion: nil)
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    func toolbarOlustur() {
        
        let ustAyracView = UIView()
        ustAyracView.backgroundColor = UIColor.lightGray
        
        let altAyracView = UIView()
        altAyracView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [btnGrid, btnListe, btnRibbon])
        view.addSubview(stackView)
        view.addSubview(ustAyracView)
        view.addSubview(altAyracView)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.anchor(top: nil, bottom: header.bottomAnchor, leading: header.leadingAnchor, trailing: header.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 60)
        ustAyracView.anchor(top: stackView.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 1)
        altAyracView.anchor(top: nil, bottom: stackView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    func kullaniciDurumBilgisiGoster() {
        let stackView = UIStackView(arrangedSubviews: [lblPaylasim, lblTakipci, lblTakipEdiliyor])
        view.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: imgProfilGoruntu.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 15, paddingBottom: 0, paddingLeft: 90, paddingRight: -15, width: 0, height: 50)
    }
   
    
    func setupThumbnailImage() {
        if let thumbnailImageUrl = cUser?.pp {
            print(thumbnailImageUrl)
            imgProfilGoruntu.loadImageUsingUrlString(urlString: thumbnailImageUrl)
        }
    }
    
    func fetchUser(id: String, completion: @escaping (User) -> ()) {
        
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
                    user.password = dictionary["password"] as? String
                    user.email = dictionary["email"] as? String
                    user.name = dictionary["name"] as? String
                    user.birthday = dictionary["birthday"] as? String
                    user.type = dictionary["type"] as? String
                    user.pp = dictionary["pp"] as? String
                    user.followed_user = dictionary["followed_user"] as? Int
                    
                    
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
    
    func fetchPosts(id: String, completion: @escaping ([Post]) -> ()) {
        
        
        let limit: Int = 10000
        let offset: Int = 0
        
        let url = URL(string: "http://54.67.91.186/loadposts.php")!
        let body = "id=\(id)&offset=\(offset)&limit=\(limit)"
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
                    post.user_id = dictionary["user_id"] as? Int
                   // post.likes = dictionary["likes"] as? Int
                    post.type = dictionary["type"] as? String
                    post.picture = dictionary["picture"] as? String
                    post.postmessage = dictionary["postmessage"] as? String
                    
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


