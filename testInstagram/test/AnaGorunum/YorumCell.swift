//
//  YorumCell.swift
//  test
//
//  Created by kaan on 8.02.2025.
//

import UIKit

protocol YorumCellDelegate {
    func yorumSil(comment : Comment)
}

class YorumCell: UICollectionViewCell {
    
    var delegate : YorumCellDelegate?
    
    var comment: Comment? {
        didSet {
            
            if let yorum = comment?.comment, let name = comment?.username {
                let attrText = NSMutableAttributedString(string: name, attributes: [.font : UIFont.boldSystemFont(ofSize: 15)])
                attrText.append(NSAttributedString(string: " " + (yorum), attributes: [.font : UIFont.systemFont(ofSize: 15)]))
                lblYorum.attributedText = attrText
            }
            
            if let pp = comment?.userpp {
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
    
    lazy var yorumSil : UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(yorumSilPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func yorumSilPressed() {
        guard let comment = self.comment else {return}
        delegate?.yorumSil(comment: comment)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(imgKullaniciProfil)
        
        imgKullaniciProfil.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, paddingTop: 10, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 50, height: 50)
        addSubview(yorumSil)
        yorumSil.anchor(top: topAnchor, bottom: bottomAnchor, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(lblYorum)
        lblYorum.anchor(top: topAnchor, bottom: bottomAnchor, leading: imgKullaniciProfil.trailingAnchor, trailing: yorumSil.leadingAnchor, paddingTop: 5, paddingBottom: -5, paddingLeft: 10, paddingRight: -5, width: 0, height: 0)
        
        let ayracView = UIView()
        ayracView.backgroundColor = UIColor(white: 0, alpha: 0.45)
        addSubview(ayracView)
        ayracView.anchor(top: nil, bottom: bottomAnchor, leading: lblYorum.leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.45)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
