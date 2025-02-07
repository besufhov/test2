//
//  KullaniciProfilCell.swift
//  test
//
//  Created by kaan on 28.01.2025.
//

import UIKit

class KullaniciProfilCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            fotografYukle()
        }
    }
    
    func fotografYukle() {
        if let fotografUrl = post?.picture {
            print(fotografUrl)
           myImageView.loadImageUsingUrlString(urlString: fotografUrl)
        }
    }
    
    var myImageView: CustomImageView = {
        let img = CustomImageView()
        img.backgroundColor = .green
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
        addSubview(myImageView)
        myImageView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
       
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
