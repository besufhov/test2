//
//  KullaniciAraCell.swift
//  test
//
//  Created by kaan on 31.01.2025.
//

import Foundation
import UIKit


class KullaniciAraCell: UICollectionViewCell {
    
    var takipEdilecekID : Int?
    
    var user: User? {
        didSet {
            
            if let name = user?.name {
                lblKullaniciAdi.text = name
            }
            
            if let pp = user?.pp {
                imgKullaniciProfil.loadImageUsingUrlString(urlString: pp)
            }
            if let id = user?.id {
                takipEdilecekID = id
            }
            
            if (user?.id) == user?.followed_user {
                    takipButton.setTitle("Takip Ediliyor", for: .normal)
            } else {
                    takipButton.setTitle("Takip Et", for: .normal)
            }
        }
    }
    
   
    
    
    
    
    let lblKullaniciAdi : UILabel = {
        let lbl = UILabel()
        lbl.text = "Kullanici Adi"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    
    let imgKullaniciProfil : CustomImageView = {
        let img = CustomImageView()
        img.backgroundColor = .red
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let takipButton : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setTitle("Takip Et", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(btnProfil_Takip), for: .touchUpInside)
        return btn
    }()
    @objc fileprivate func btnProfil_Takip() {

        guard let id = currentUser?["id"] else { return }
        
        if takipButton.currentTitle == "Takip Et" {
            print(takipEdilecekID!)
            
            let url = URL(string: "http://54.67.91.186/follow.php")!
            let body = "action=follow&user_id=\(id)&follow_id=\(takipEdilecekID!)"
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
                        self.takipButton.setTitle("Takip Ediliyor", for: .normal)
                    } else { print("Error") }
                        
                    print(json as Any)
                } catch {
                }
            }
                
            }.resume()
        } else {
            let url = URL(string: "http://54.67.91.186/follow.php")!
            let body = "action=unfollow&user_id=\(id)&follow_id=\(takipEdilecekID!)"
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
                        self.takipButton.setTitle("Takip Et", for: .normal)
                    } else { print("Error") }
                        
                    print(json as Any)
                } catch {
                }
            }
                
            }.resume()
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(imgKullaniciProfil)
        addSubview(takipButton)
        imgKullaniciProfil.layer.cornerRadius = 55 / 2
        imgKullaniciProfil.anchor(top: nil, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 55, height: 55)
        imgKullaniciProfil.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(lblKullaniciAdi)
        lblKullaniciAdi.anchor(top: topAnchor, bottom: bottomAnchor, leading: imgKullaniciProfil.trailingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 0, height: 0)
        
        let ayracView = UIView()
        ayracView.backgroundColor = UIColor(white: 0, alpha: 0.45)
        addSubview(ayracView)
        ayracView.anchor(top: nil, bottom: bottomAnchor, leading: lblKullaniciAdi.leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.45)
        takipButton.anchor(top: nil, bottom: nil, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: -10, width: 110, height: 35)
        takipButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
      
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
