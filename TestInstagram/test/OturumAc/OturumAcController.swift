//
//  OturumAcController.swift
//  test
//
//  Created by kaan on 27.01.2025.
//

import UIKit

class OturumAcController: UIViewController {
    
    let txtEmail : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Email adresinizi giriniz"
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        return txt
    }()
    
    let txtParola : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Parolaniz"
        txt.isSecureTextEntry = true
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        return txt
    }()
    
    @objc fileprivate func veriDegisimi() {
        let helper = Validation()
        
        if helper.isValidemail(emailtext: txtEmail.text!) && (txtParola.text?.count ?? 0) > 6 {
           
            btnGirisYap.isEnabled = true
            btnGirisYap.backgroundColor = UIColor.rgbDonustur(red: 20, green: 155, blue: 235)
            
        } else if helper.isValidname(nametext: txtEmail.text!) && (txtParola.text?.count ?? 0) > 6 {
        
            btnGirisYap.isEnabled = true
            btnGirisYap.backgroundColor = UIColor.rgbDonustur(red: 20, green: 155, blue: 235)
        
            } else {
            
                btnGirisYap.isEnabled = false
                btnGirisYap.backgroundColor = UIColor.rgbDonustur(red: 145, green: 205, blue: 245)
        }
    }
    
    let btnGirisYap : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Giris Yap", for: .normal)
        btn.backgroundColor = UIColor.rgbDonustur(red: 150, green: 205, blue: 245)
        btn.layer.cornerRadius = 6
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(btnGirisYapPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc func btnGirisYapPressed() {
        
        let url = URL(string: "http://54.67.91.186/login.php")!
        let body = "email=\(txtEmail.text!)&password=\(txtParola.text!)&name=\(txtEmail.text!)"
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
                } else { print("Error") }
                    
                print(json as Any)
                
                currentUser = parsedJSON.mutableCopy() as? Dictionary<String, Any>
                DEFAULTS.set(currentUser, forKey: keyCURRENT_USER)
                DEFAULTS.synchronize()
                
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
                guard let anaTabBarController = keyWindow?.rootViewController as? AnaTabBarController else { return }
                anaTabBarController.gorunumuOlustur()
                self.dismiss(animated: true, completion: nil)
            } catch {
                helper.showAlert(title: "Json Error", message: error.localizedDescription, from: self)
            }
        }
            
        }.resume()
    }
    
    let logoView : UIView = {
        let view = UIView()
        let img = UIImage(named: "Instagram_logo_white")
        let imgLogo = UIImageView(image: img)
        view.addSubview(imgLogo)
        view.backgroundColor = UIColor.rgbDonustur(red: 0, green: 120, blue: 175)
        imgLogo.anchor(top: nil, bottom: nil, leading: nil, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 200, height: 50)
        imgLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imgLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imgLogo.contentMode = .scaleAspectFill
        return view
    }()
    
    let btnKayitOl : UIButton = {
        let btn = UIButton(type: .system)
        let attrBaslik = NSMutableAttributedString(string: "Henuz bir hesabiniz yok mu?", attributes: [.font : UIFont.systemFont(ofSize: 16), .foregroundColor : UIColor.lightGray])
        attrBaslik.append(NSAttributedString(string: " Kayit Ol", attributes: [.font : UIFont.boldSystemFont(ofSize: 16), .foregroundColor : UIColor.rgbDonustur(red: 20, green: 155, blue: 235)]))
        btn.setAttributedTitle(attrBaslik, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(btnKayitOlPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func btnKayitOlPressed() {
        let kayitOlController = KayitOlController()
        navigationController?.pushViewController(kayitOlController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(btnKayitOl)
        view.addSubview(logoView)
        
        navigationController?.isNavigationBarHidden = true
        btnKayitOl.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
        logoView.anchor(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 150)
        girisGorunumOlustur()
    }
    
    fileprivate func girisGorunumOlustur() {
        let stackView = UIStackView(arrangedSubviews: [txtEmail, txtParola, btnGirisYap])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.anchor(top: logoView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 40, paddingRight: -40, width: 0, height: 185)
    }
}
