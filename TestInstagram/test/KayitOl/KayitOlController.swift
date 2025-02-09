//
//  ViewController.swift
//  test
//
//  Created by kaan on 26.01.2025.
//

import UIKit

class KayitOlController: UIViewController {
    

    
    let btnFotografEkle : UIButton = {
        let btn = UIButton(type: .system)
        //btn.setImage(#imageLiteral(resourceName: "Fotograf_Sec").withRenderingMode(.alwaysOriginal), for: normal
        btn.setImage(UIImage(named: "plus_photo"), for: .normal)
        btn.currentImage?.withRenderingMode(.alwaysOriginal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(btnFotografEklePressed), for: .touchUpInside)
        return btn
    }()
    
    @objc func btnFotografEklePressed() {
        let imgPickerController = UIImagePickerController()
        imgPickerController.delegate = self
        
        present(imgPickerController, animated: true, completion: nil)
    }
    
    let txtEmail : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Email adresinizi giriniz..."
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.backgroundColor = .lightGray
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.text = txt.text?.lowercased()
        
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        
        return txt
    }()
    
    @objc func veriDegisimi() {
    
        let helper = Validation()
        
        if helper.isValidemail(emailtext: txtEmail.text!) && helper.isValidname(nametext: txtKullaniciAdi.text!) && txtParola.text == txtParola2.text && (txtParola.text?.count ?? 0) > 6 && (txtParola2.text?.count ?? 0) > 6 {
           
            btnKayitOl.isEnabled = true
            btnKayitOl.backgroundColor = UIColor.rgbDonustur(red: 20, green: 155, blue: 235)
            
        } else if txtParola.text != txtParola2.text {
            
            print("Password do not match")
            btnKayitOl.isEnabled = false
            
        } else {
            
            btnKayitOl.isEnabled = false
            btnKayitOl.backgroundColor = UIColor.rgbDonustur(red: 145, green: 205, blue: 245)
        }
        
        
    }
    
    let txtKullaniciAdi : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Kullanici Adinizi Giriniz..."
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.backgroundColor = .lightGray
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.text = txt.text?.lowercased()
        
        
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        
        return txt
    }()
    
    let txtParola : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Parola Giriniz"
        txt.isSecureTextEntry = true
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.backgroundColor = .lightGray
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        
        return txt
    }()
    
    let txtParola2 : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Parola Giriniz"
        txt.isSecureTextEntry = true
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.backgroundColor = .lightGray
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        
        return txt
    }()
    
    let btnOturumAc : UIButton = {
        let btn = UIButton(type: .system)
        let attrBaslik = NSMutableAttributedString(string: "Zaten bir hesabiniz var mi?", attributes: [.font : UIFont.systemFont(ofSize: 16), .foregroundColor : UIColor.lightGray])
        attrBaslik.append(NSAttributedString(string: " Oturum Ac", attributes: [.font : UIFont.boldSystemFont(ofSize: 16), .foregroundColor : UIColor.rgbDonustur(red: 20, green: 155, blue: 235)]))
        btn.setAttributedTitle(attrBaslik, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(oturumAcPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func oturumAcPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func uploadPP(from id: String) {
        
        let params = ["id": Int(id)!, "type": "portrait"] as [String : Any]
        let url = URL(string: "http://54.67.91.186/createbucket.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = self.btnFotografEkle.imageView!.image!.jpegData(compressionQuality: 0.9)!
        
        request.httpBody = Validation().body(with: params, filename: "\("portrait").jpg", filePathKey: "file", imageDataKey: imageData, boundary: boundary) as Data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    print("server error")
                return }
                
                do {
                    guard let data = data else { return }
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                    print(json!)
                    
                    guard let parsedJSON = json else { return }
                    
                    if parsedJSON["status"] as? String == "200"{
                        print("Success")
                        let keyWindow = UIApplication.shared.connectedScenes
                            .filter({$0.activationState == .foregroundActive})
                            .map({$0 as? UIWindowScene})
                            .compactMap({$0})
                            .first?.windows
                            .filter({$0.isKeyWindow}).first
                        guard let anaTabBarController = keyWindow?.rootViewController as? AnaTabBarController else { return }
                        anaTabBarController.gorunumuOlustur()
                        self.dismiss(animated: true, completion: nil)
                        
                    } else {
                        print("Error")
                    }
                } catch {
                    print("JSON Error")
                }
            }
        }.resume()
        
    }
    
    let btnKayitOl : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Kayit Ol", for: .normal)
        btn.backgroundColor = UIColor.rgbDonustur(red: 145, green: 205, blue: 245)
        btn.layer.cornerRadius = 6
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(btnKayitolPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc func btnKayitolPressed() {
        let url = URL(string: "http://54.67.91.186/register.php")!
        let body = "email=\(txtEmail.text!)&password=\(txtParola.text!)&name=\(txtKullaniciAdi.text!)&birthday=\(String("5325"))"
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
                let id = json!["id"] as! String
                
                currentUser = parsedJSON.mutableCopy() as? Dictionary<String, Any>
                DEFAULTS.set(currentUser, forKey: keyCURRENT_USER)
                DEFAULTS.synchronize()
                print(id as Any)
                self.uploadPP(from: id)
                
                
            } catch {
                helper.showAlert(title: "Json Error", message: error.localizedDescription, from: self)
            }
        }
            
        }.resume()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        view.addSubview(btnFotografEkle)
        view.addSubview(btnOturumAc)
        btnFotografEkle.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: nil, paddingTop: 40, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 150, height: 150)
        btnFotografEkle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        girisAlanlariniOlustur()
        btnOturumAc.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
        
    }
    func girisAlanlariniOlustur(){
        
        
        let stackView = UIStackView(arrangedSubviews: [txtEmail, txtKullaniciAdi, txtParola, txtParola2, btnKayitOl])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
       
        
        stackView.anchor(top: btnFotografEkle.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 20, paddingBottom: 20, paddingLeft: 40, paddingRight: -40, width: 0, height: 230)
    }
    }

extension UIView {
    func anchor(top : NSLayoutYAxisAnchor?,
                bottom : NSLayoutYAxisAnchor?,
                leading : NSLayoutXAxisAnchor?,
                trailing : NSLayoutXAxisAnchor?,
                paddingTop : CGFloat,
                paddingBottom : CGFloat,
                paddingLeft : CGFloat,
                paddingRight : CGFloat,
                width : CGFloat,
                height : CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading, constant: paddingLeft).isActive = true
        }
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: trailing, constant: paddingRight).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        

    
}
}

extension KayitOlController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //didcancel
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imgSecilen = info[.originalImage] as? UIImage
        self.btnFotografEkle.setImage(imgSecilen?.withRenderingMode(.alwaysOriginal), for: .normal)
        btnFotografEkle.layer.cornerRadius = btnFotografEkle.frame.width / 2
        btnFotografEkle.layer.masksToBounds = true
        btnFotografEkle.layer.borderColor = UIColor.darkGray.cgColor
        btnFotografEkle.layer.borderWidth = 3
        dismiss(animated: true, completion: nil)
        
    }
}


