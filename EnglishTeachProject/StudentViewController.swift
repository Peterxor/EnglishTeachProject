//
//  StudentViewController.swift
//  EnglishTeachProject
//
//  Created by Peter on 2018/5/29.
//  Copyright © 2018年 Peter. All rights reserved.
//

import Foundation
import UIKit

class StudentViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let datas1 = ["writing", "desktop", "graduate"]
    let datas2 = ["law", "learning", "notebook"]
    var collection: UICollectionView?
    var layout: UICollectionViewFlowLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        layout = UICollectionViewFlowLayout()
        layout?.scrollDirection = .vertical
        layout?.itemSize = CGSize(width: width, height: height/4)
        
        layout?.minimumInteritemSpacing = 0
        collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout!)
        collection?.backgroundColor = .white
        collection?.register(StudentCell.self, forCellWithReuseIdentifier: "StudentCell")
        collection?.dataSource = self
        collection?.delegate = self
        self.view.backgroundColor = .black
        self.view.addSubview(collection!)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudentCell", for: indexPath) as! StudentCell
        let data1 = datas1[indexPath.row]
        let data2 = datas2[indexPath.row]
        cell.setCell(left: data1, right: data2)
        if data1 == "writing" {
            cell.leftBtn?.addTarget(self, action: #selector(self.presentMainVIew), for: .touchDown)
        }
        return cell
    }
    
    @objc func presentMainVIew(){
        self.present(MainViewController(), animated: true, completion: nil)
    }
}
