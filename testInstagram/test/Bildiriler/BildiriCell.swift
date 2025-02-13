//
//  BildiriCell.swift
//  test
//
//  Created by kaan on 9.02.2025.
//

import UIKit

class BildiriCell: UICollectionViewCell {
    
    var bildiri: Bildiri? {
        didSet {
            
            if let name = bildiri?.username, let type = bildiri?.type {
                let attrText = NSMutableAttributedString(string: name, attributes: [.font : UIFont.boldSystemFont(ofSize: 16)])
                if type == "follow" {
                attrText.append(NSAttributedString(string: " seni takip etti" , attributes: [.font : UIFont.systemFont(ofSize: 16)]))
                lblYorum.attributedText = attrText
                } else if type == "like" {
                    attrText.append(NSAttributedString(string: " gonderini begendi" , attributes: [.font : UIFont.systemFont(ofSize: 16)]))
                    lblYorum.attributedText = attrText
                } else if type == "comment" {
                    attrText.append(NSAttributedString(string: " gonderine yorum yapti" , attributes: [.font : UIFont.systemFont(ofSize: 16)]))
                    lblYorum.attributedText = attrText
                }
            }
            
            if let pp = bildiri?.userpp {
                imgKullaniciProfil.loadImageUsingUrlString(urlString: pp)
            }
        }
    }
    
    let imgKullaniciProfil : CustomImageView = {
        let img = CustomImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .white
        img.layer.cornerRadius = 50 / 2
        return img
    }()
    
    let lblYorum : UITextView = {
        let lbl = UITextView()
        lbl.isScrollEnabled = false
        lbl.isEditable = false
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.backgroundColor = .white
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(imgKullaniciProfil)
        imgKullaniciProfil.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 10, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 50, height: 50)
        addSubview(lblYorum)
        lblYorum.anchor(top: topAnchor, bottom: bottomAnchor, leading: imgKullaniciProfil.trailingAnchor, trailing: trailingAnchor, paddingTop: 5, paddingBottom: -5, paddingLeft: 10, paddingRight: -5, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

