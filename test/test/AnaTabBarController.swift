//
//  AnaTabBarController.swift
//  test
//
//  Created by kaan on 27.01.2025.
//

import Foundation
import UIKit

class AnaTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        currentUser = DEFAULTS.object(forKey: keyCURRENT_USER) as? Dictionary<String, Any>
        
        if currentUser?["id"] == nil {
            DispatchQueue.main.async {
                let oturumAcController = OturumAcController()
                let navController = UINavigationController(rootViewController: oturumAcController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
                return
            }
        } else if currentUser?["id"] != nil {
                gorunumuOlustur()
            }
    }
    
    
    func gorunumuOlustur() {
        
        let anaNavController = navControllerOlustur(rootViewController: AnaController(), seciliOlanIkon: "home_selected", seciliOlmayanIkon: "home_unselected")
        let araNavController = navControllerOlustur(rootViewController: KullaniciAraController(), seciliOlanIkon: "search_selected", seciliOlmayanIkon: "search_unselected")
        let ekleNavController = navControllerOlustur(seciliOlanIkon: "plus_unselected", seciliOlmayanIkon: "plus_unselected")
        let begeniNavController = navControllerOlustur(seciliOlanIkon: "like_selected", seciliOlmayanIkon: "like_unselected")
      //  let kullaniciProfilNavController = navControllerOlustur(seciliOlanIkon: "profile_selected", seciliOlmayanIkon: "profile_unselected")
       
        
      // let layout = UICollectionViewLayout()
       //let kullaniciProfilController = KullaniciView(collectionViewLayout: layout)
         let kullaniciProfilController = KullaniciProfilController()
      let kullaniciProfilNavController = UINavigationController(rootViewController: kullaniciProfilController)
      kullaniciProfilNavController.tabBarItem.image = UIImage.init(named: "profile_unselected")
      kullaniciProfilNavController.tabBarItem.selectedImage = UIImage.init(named: "profile_selected")
         tabBar.tintColor = .black
        tabBar.backgroundColor = .opaqueSeparator
        
         viewControllers = [anaNavController, araNavController, ekleNavController, begeniNavController, kullaniciProfilNavController]
        
        guard let itemlar = tabBar.items else { return }
        
        for item in itemlar {
            item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        }
    }
    
    fileprivate func navControllerOlustur(rootViewController: UIViewController = UIViewController(), seciliOlanIkon: String, seciliOlmayanIkon: String) -> UINavigationController {
        let rootController = rootViewController
        let navController = UINavigationController(rootViewController: rootController)
        navController.tabBarItem.image = UIImage.init(named: seciliOlmayanIkon)
        navController.tabBarItem.selectedImage = UIImage.init(named: seciliOlanIkon)
        return navController
    }
    
}

extension AnaTabBarController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let index = viewControllers?.firstIndex(of: viewController) else { return true }
        print("\(index). Bastin")
        
        if index == 2 {
            
            let layout = UICollectionViewFlowLayout()
            
            let fotografSeciciController = FotografSeciciController(collectionViewLayout: layout)
            
            let navController = UINavigationController(rootViewController: fotografSeciciController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
            
            return false
            
        }
        return true
    }
}
