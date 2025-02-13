//
//  BildirilerController.swift
//  test
//
//  Created by kaan on 9.02.2025.
//

import UIKit

class BildiriController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var bildiriler: [Bildiri]?
    var fetchedID : String?
    
    lazy var BildirilerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.alwaysBounceVertical = true
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -100, right: 0)
        cv.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -100, right: 0)
        cv.keyboardDismissMode = .interactive
        cv.register(BildiriCell.self, forCellWithReuseIdentifier: "bildiriCellID")
      
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let id = currentUser?["id"] as? String else { return }
        fetchedID = id
        navigationItem.title = "Bildiriler"
        view.addSubview(BildirilerCollectionView)
        BildirilerCollectionView.backgroundColor = .white
        BildirilerCollectionView.delegate = self
        BildirilerCollectionView.dataSource = self
        
        BildirilerCollectionView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        bildirileriGetir()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bildiriler?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bildiriCellID", for: indexPath) as! BildiriCell
        cell.bildiri = bildiriler?[indexPath.item]
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
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func bildirileriGetir() {
        bildirileriGetir { (bildiriler: [Bildiri]) in
            self.bildiriler = bildiriler
            self.BildirilerCollectionView.reloadData()
        }
    }
    
    fileprivate func bildirileriGetir(completion: @escaping ([Bildiri]) -> ()) {
        //comments?.removeAll()
        let limit: Int = 10000
        let offset: Int = 0
        
        let url = URL(string: "http://54.67.91.186/notifications.php")!
        let body = "action=select&user_id=\(fetchedID!)&offset=\(offset)&limit=\(limit)"
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
                
                var bildiriler = [Bildiri]()
                
                for dictionary in json!["notifications"] as! [[String: AnyObject]] {
                
                    let bildiri = Bildiri()
                    bildiri.id = dictionary["id"] as? Int
                    bildiri.byUser_id = dictionary["byUser_id"] as? Int
                    bildiri.user_id = dictionary["user_id"] as? Int
                    bildiri.type = dictionary["type"] as? String
                    bildiri.viewed = dictionary["viewed"] as? String
                    bildiri.userpp = dictionary["pp"] as? String
                    bildiri.username = dictionary["name"] as? String
                    bildiri.date_created = dictionary["date_created"] as? String
                  
                    bildiriler.append(bildiri)
                
                 //   print(dictionary["id"]!)
                    
                }
                
                DispatchQueue.main.async {
                    completion(bildiriler)
                }
                
                print(json!["notifications"] as Any)
                
            } catch {
                print("JSON Error")
                return
            }
        }.resume()
    }
}
