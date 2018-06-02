//
//  RecordViewController.swift
//  EnglishTeachProject
//
//  Created by Peter on 2018/5/31.
//  Copyright © 2018年 Peter. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RecordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var datas: [UserData]?
    var context: NSManagedObjectContext?
    var tableview: UITableView?
    var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        do{
            datas = try context?.fetch(UserData.fetchRequest())
            datas?.sort(by: { (a, b) -> Bool in
                if a.testDate! > b.testDate!{
                    return true
                }else{
                    return false
                }
            })
        } catch let error as Error{
            print(error)
        }
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        //設置背景
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height/3))
        imageView?.image = UIImage(named: "beach")
        self.view.addSubview(imageView!)
        
        
        //設置tableview
        tableview = UITableView(frame: CGRect(x: width/7, y: height/2, width: 5*width/7, height: 5*height/12))
        tableview?.dataSource = self
        tableview?.delegate = self
        tableview?.register(RecordCell.self, forCellReuseIdentifier: "Record")
        self.view.addSubview(tableview!)
        
        self.view.backgroundColor = .white
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Record", for: indexPath) as! RecordCell
        let data = datas![indexPath.row]
        cell.setCell(score: Int(data.score), date: (data.testDate?.description)!,table: tableview!, delegate: (UIApplication.shared.delegate as! AppDelegate), text: context!, udata: data)
        return cell
    }
    
    
    
}
