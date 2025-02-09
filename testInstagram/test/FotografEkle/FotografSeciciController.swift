//
//  FotografSeciciController.swift
//  test
//
//  Created by kaan on 28.01.2025.
//

import UIKit
import Photos

class FotografSeciciController : UICollectionViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        butonlariEkle()
        collectionView.register(FotografSeciciCell.self, forCellWithReuseIdentifier: "hucreID")
        collectionView.register(FotografSeciciHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        fotograflariGetir()
    }
    
    var assetler = [PHAsset]()
    var secilenFotograf : UIImage?
    var fotograflar = [UIImage]()
    
    fileprivate func fotografGetirmeSecenekOlustur() -> PHFetchOptions {
        let getirmeSecenekleri = PHFetchOptions()
        getirmeSecenekleri.fetchLimit = 40
        
        let siralamaAyari = NSSortDescriptor(key: "creationDate", ascending: false)
        
        getirmeSecenekleri.sortDescriptors = [siralamaAyari]
        return getirmeSecenekleri
    }
    fileprivate func fotograflariGetir() {
        
        let fotograflar = PHAsset.fetchAssets(with: .image, options: fotografGetirmeSecenekOlustur())
        
        DispatchQueue.global(qos: .background).async {
            fotograflar.enumerateObjects {(asset, sayi, durmaNoktasi) in
                
                print("\(sayi). Fotograf Getirildi")
                
                let imageManager = PHImageManager.default()
                let goruntuBoyutu = CGSize(width: 200, height: 200)
                let secenekler = PHImageRequestOptions()
                secenekler.isSynchronous = true
                
                imageManager.requestImage(for: asset, targetSize: goruntuBoyutu, contentMode: .aspectFit, options: secenekler) { goruntu, goruntuBilgileri in
                    
                    if let fotograf = goruntu {
                        self.assetler.append(asset)
                        self.fotograflar.append(fotograf)
                        
                        if self.secilenFotograf == nil {
                            self.secilenFotograf = goruntu
                        }
                    }
                    
                    if sayi == fotograflar.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        
                    }
                }
            }
        }
        
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        secilenFotograf = fotograflar[indexPath.row]
        collectionView.reloadData()
        collectionView.isScrollEnabled = true
        let indexUst = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexUst, at: .bottom, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let genislik = view.frame.width
        return CGSize(width: genislik, height: genislik)
    }
    
    var header : FotografSeciciHeader?
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! FotografSeciciHeader
       // header.imgHeader.image = secilenFotograf
        self.header = header
        header.imgHeader.image = secilenFotograf
        
        if let secilenFotograf = secilenFotograf {
            if let index = self.fotograflar.firstIndex(of: secilenFotograf) {
                let secilenAsset = assetler[index]
                
                let fotoManager = PHImageManager.default()
                let boyut = CGSize(width: 600, height: 600)
                fotoManager.requestImage(for: secilenAsset, targetSize: boyut, contentMode: .default, options: nil) { foto, bilgi in
                    header.imgHeader.image = foto
                }
                
            }
        }
        
        return header
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fotograflar.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: "hucreID", for: indexPath) as! FotografSeciciCell
        hucre.imgFotograf.image = fotograflar[indexPath.row]
        return hucre
    }
    
    fileprivate func butonlariEkle() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Iptal Et", style: .plain, target: self, action: #selector(btnIptalEtPressed))
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sonraki", style: .plain, target: self, action: #selector(btnSonrakiPressed))
    }
    
    @objc fileprivate func btnIptalEtPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func btnSonrakiPressed() {
        let fotoPaylasController = FotografPaylasController()
        navigationController?.pushViewController(fotoPaylasController, animated: true)
        fotoPaylasController.secilenFotograf = header?.imgHeader.image
    }
    
}

extension FotografSeciciController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let genislik = (view.frame.width - 3 ) / 4
        return CGSize(width: genislik, height: genislik)
    }
}
