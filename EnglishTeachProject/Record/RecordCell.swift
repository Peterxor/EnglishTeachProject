//
//  RecordCell.swift
//  EnglishTeachProject
//
//  Created by Peter on 2018/5/31.
//  Copyright © 2018年 Peter. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class RecordCell: UITableViewCell{
    var scoreLabel: UILabel?
    var dateLabel: UILabel?
    var deleteBtn: UIButton?
    
    var tableview: UITableView?
    var appDelegate: AppDelegate?
    var context: NSManagedObjectContext?
    var userdata: UserData?
    
    func setCell(score: Int, date: String, table: UITableView?, delegate: AppDelegate?, text: NSManagedObjectContext?, udata: UserData?){
        let width = self.frame.width
        let height = self.frame.height
        self.tableview = table
        self.appDelegate = delegate
        self.context = text
        self.userdata = udata
        //設置分數
        scoreLabel = UILabel(frame:CGRect(x: 0, y: 0, width: width/3, height: height))
        scoreLabel?.text = "Score: \(score)"
        self.addSubview(scoreLabel!)
        
        //設置日期
        dateLabel = UILabel(frame: CGRect(x: width/3, y: 0, width: width/3, height: height))
        let dateString = date.prefix(10)
        dateLabel?.text = String(dateString)
        self.addSubview(dateLabel!)
        
        //設置刪除鈕
        deleteBtn = UIButton(frame: CGRect(x: width-height, y: 0, width: height, height: height))
        deleteBtn?.setImage(UIImage(named: "garbage"), for: .normal)
        deleteBtn?.addTarget(self, action: #selector(self.deleteSelf), for: .touchDown)
        self.addSubview(deleteBtn!)
    }
    
    @objc func deleteSelf(){
        self.context?.delete(userdata!)
        appDelegate?.saveContext()
        tableview?.reloadData()
    }
}
