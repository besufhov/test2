//
//  FotografPaylasController.swift
//  test
//
//  Created by kaan on 28.01.2025.
//

import UIKit


class FotografPaylasController: UIViewController {
    
    let id = currentUser?["id"]
    
    
    var secilenFotograf : UIImage? {
        didSet {
            self.imgPaylasim.image = secilenFotograf
        }
    }
    
    let txtMesaj : UITextView = {
        let txt = UITextView()
        txt.font = UIFont.systemFont(ofSize: 15)
        return txt
    }()
    
    let imgPaylasim : UIImageView = {
        
        let img = UIImageView()
        img.backgroundColor = .blue
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgbDonustur(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Paylas", style: .plain, target: self, action: #selector(btnPaylasPressed))
        fotografMesajAlanlariniOlustur()
}
    
    
    @objc fileprivate func btnPaylasPressed() {
        uploadPost(from: id as! String)
    }
    
   
    
    func uploadPost(from id: String) {
        
        let params = ["user_id": Int(id)!, "type": "portrait", "postmessage": txtMesaj.text!] as [String : Any]
        let url = URL(string: "http://54.67.91.186/uploadpost.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = self.imgPaylasim.image!.jpegData(compressionQuality: 0.9)!
        
        request.httpBody = Validation().body(with: params, filename: "\(NSUUID().uuidString).jpg", filePathKey: "file", imageDataKey: imageData, boundary: boundary) as Data
        
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
                        self.navigationItem.rightBarButtonItem?.isEnabled = false
                        self.dismiss(animated: true, completion: nil)
                        self.testkullanici()
                        
                    } else {
                        print("Error")
                    }
                } catch {
                    print("JSON Error")
                }
            }
        }.resume()
        
    }
    
    fileprivate func fotografMesajAlanlariniOlustur() {
        let paylasimView = UIView()
        paylasimView.backgroundColor = .white
        
        view.addSubview(paylasimView)
        paylasimView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 120)
        
        view.addSubview(imgPaylasim)
        imgPaylasim.anchor(top: paylasimView.topAnchor, bottom: paylasimView.bottomAnchor, leading: paylasimView.leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: -8, paddingLeft: 8, paddingRight: 0, width: 85, height: 0)
        
        view.addSubview(txtMesaj)
        
        txtMesaj.anchor(top: paylasimView.topAnchor, bottom: paylasimView.bottomAnchor, leading: imgPaylasim.trailingAnchor, trailing: paylasimView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 5, paddingRight: 0, width: 0, height: 0)
    }
    
    var delegate: UpdatesDelegate?
    func testkullanici(){
        self.delegate?.didFinishUpdates()
        print("test")
    }
    
}

protocol UpdatesDelegate {
    func didFinishUpdates()
}
