//
//  TakipIslemleri.swift
//  test
//
//  Created by kaan on 2.02.2025.
//

import UIKit

class TakipIslemleri {
    
    static let Takip : TakipIslemleri = TakipIslemleri()
    
    func takip(action: String, user_id: String, follow_id : Int) {
        let url = URL(string: "http://54.67.91.186/follow.php")!
        let body = "action=\(action)&user_id=\(user_id)&follow_id=\(follow_id))"
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
                } else { print("Error") }
                    
                print(json as Any)
            } catch {
            }
        }
            
        }.resume()
    }
    
}
