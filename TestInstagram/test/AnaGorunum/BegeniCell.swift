//
//  BegeniCell.swift
//  test
//
//  Created by kaan on 8.02.2025.
//

import UIKit

class BegeniCell: UICollectionViewCell {
    
    var like: Like? {
        didSet {
            
            if let name = like?.username {
                let attrText = NSMutableAttributedString(string: name, attributes: [.font : UIFont.boldSystemFont(ofSize: 15)])
                lblYorum.attributedText = attrText
            }
            
            if let pp = like?.userpp {
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
