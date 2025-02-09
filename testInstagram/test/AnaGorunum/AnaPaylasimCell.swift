//
//  AnaPaylasimCell.swift
//  test
//
//  Created by kaan on 30.01.2025.
//

import UIKit

protocol AnaPaylasimCellDelegate {
    func yorumaBasildi(post : Post)
    func paylasimBegenildi(cell : AnaPaylasimCell)
    func begeniCountBasildi(post : Post)
}

@objc protocol AnaPaylasimCellDelegateObjc {
   @objc func yorumGuncelle(cell : AnaPaylasimCell)
}

class AnaPaylasimCell : UICollectionViewCell {
    
    var delegate : AnaPaylasimCellDelegate?
    var delegateobjc : AnaPaylasimCellDelegateObjc?
    var fetchedID : String?
    var userid : Int?
    var post: Post? {
        didSet {
            
            verileriAl()
            if post?.liked != nil {
                let img = UIImage(named: "like_selected")
                btnBegen.setImage(img, for: .normal)
            } else {
                let img = UIImage(named: "like_unselected")
                btnBegen.setImage(img, for: .normal)
            }
            
            if let yorumCount = post?.commentscount {
                btnYorumCount.setTitle(" \(yorumCount) Yorum yapildi", for: .normal)
                if yorumCount == 0 { btnYorumCount.setTitle(" Henuz yorum yok", for: .normal) }
            }
            if let begeniCount = post?.likescount {
                btnLikeCount.setTitle(" \(begeniCount) Kisi begendi", for: .normal)
                if begeniCount == 0 { btnLikeCount.setTitle(" Henuz bir begeni yok", for: .normal)}
            }
        }
    }
    
    let lblPaylasimMesaj : UILabel = {
        let lbl = UILabel()
        
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    let btnBookmark : UIButton = {
        let btn = UIButton(type: .system)
        let image = UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal)
        btn.setImage(image, for: .normal)
        return btn
    }()
    
    lazy var btnBegen : UIButton = {
        let btn = UIButton(type: .system)
        let image = UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal)
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(btnBegenPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func btnBegenPressed() {
        delegate?.paylasimBegenildi(cell: self)
    }
    
    lazy var btnYorumYap : UIButton = {
        let btn = UIButton(type: .system)
        let image = UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal)
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(btnYorumYapPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnYorumCount : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Henuz yorum yok", for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    lazy var btnLikeCount : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Henuz begeni yok", for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(btnBegenileriGor), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func btnBegenileriGor() {
        guard let post = self.post else {return}
        delegate?.begeniCountBasildi(post: post)
    }
    
    @objc fileprivate func btnYorumYapPressed() {
        guard let post = self.post else {return}
        delegate?.yorumaBasildi(post: post)
        //delegateobjc?.yorumGuncelle(cell: self)
    }
    
    let btnMesajGonder : UIButton = {
        let btn = UIButton(type: .system)
        let image = UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal)
        btn.setImage(image, for: .normal)
        return btn
    }()
    
    let btnSecenekler : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("•••", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    let lblKullaniciAdi : UILabel = {
       let lbl = UILabel()
        lbl.text = "Kullanici Adi"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    
    let imgProfilGoruntu : CustomImageView = {
        let img = CustomImageView()
      
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.backgroundColor = .blue
        return img
    }()
    
    func verileriAl() {
        
        
        
        if let fotografUrl = post?.picture {
            print(fotografUrl)
           imgPaylasimFoto.loadImageUsingUrlString(urlString: fotografUrl)
        }
        
        if let name = post?.name {
            lblKullaniciAdi.text = name
        }
        
        if let pp = post?.pp {
            imgProfilGoruntu.loadImageUsingUrlString(urlString: pp)
        }
        
        if let mesaj = post?.postmessage, let name = post?.name, let date = post?.date {
            let attrText = NSMutableAttributedString(string: name, attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
            attrText.append(NSAttributedString(string: " \(mesaj)", attributes: [.font : UIFont.systemFont(ofSize: 14)]))
            attrText.append(NSAttributedString(string: "\n\n", attributes: [.font : UIFont.systemFont(ofSize: 4)]))
            attrText.append(NSAttributedString(string: date, attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.gray]))
            lblPaylasimMesaj.attributedText = attrText
        }
    }
    
    let imgPaylasimFoto : CustomImageView = {
        let img = CustomImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(imgProfilGoruntu)
        addSubview(imgPaylasimFoto)
        addSubview(lblKullaniciAdi)
        addSubview(btnSecenekler)
        
        guard let id = currentUser?["id"] as? String else { return }
         fetchedID = id
        guard let user_id = Int(fetchedID!) else {return}
        userid = user_id
        
        imgProfilGoruntu.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)
        imgProfilGoruntu.layer.cornerRadius = 40/2
        lblKullaniciAdi.anchor(top: topAnchor, bottom: imgPaylasimFoto.topAnchor, leading: imgProfilGoruntu.trailingAnchor, trailing: btnSecenekler.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
        btnSecenekler.anchor(top: topAnchor, bottom: imgPaylasimFoto.topAnchor, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 45, height: 0)
        imgPaylasimFoto.anchor(top: imgProfilGoruntu.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 8, paddingBottom: 8, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        _ = imgPaylasimFoto.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        addSubview(btnLikeCount)
        btnLikeCount.anchor(top: imgPaylasimFoto.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 5, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 20)
    etkilesimButonlariOlustur()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func etkilesimButonlariOlustur() {
        let stackView = UIStackView(arrangedSubviews: [btnBegen, btnYorumYap, btnMesajGonder])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: btnLikeCount.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 5, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 120, height: 20)
        addSubview(btnBookmark)
        btnBookmark.anchor(top: imgPaylasimFoto.bottomAnchor, bottom: nil, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 40, height: 50)
        addSubview(lblPaylasimMesaj)
        lblPaylasimMesaj.anchor(top: btnBegen.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 5, paddingBottom: 0, paddingLeft: 8, paddingRight: -8, width: 0, height: 0)
        
        addSubview(btnYorumCount)
        btnYorumCount.anchor(top: stackView.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 5, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 20)
    }
    
}

