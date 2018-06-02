//
//  AchieveViewController.swift
//  EnglishTeachProject
//
//  Created by Peter on 2018/5/9.
//  Copyright © 2018年 Peter. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AchieveViewController: UIViewController{
    var scoreLabel: UILabel?
    var dateLabel: UILabel?
    var context: NSManagedObjectContext?
    var appDelegate: AppDelegate?
    var user: UserData?
    
    var delete: UIButton?
    
    var leftButton: UIBarButtonItem?
    var rightButton: UIBarButtonItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        //獲得coreData的資料
        appDelegate = (UIApplication.shared.delegate) as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
        do{
            var users = try context!.fetch(UserData.fetchRequest()) as! [UserData]
            //將資料依測驗日期排列
            users.sort { (a, b) -> Bool in
                if a.testDate! < b.testDate!{
                    return true
                }
                else{
                    return false
                }
            }
            for user in users{
                print(user)
            }
            user = users[users.count - 1]
        }catch let error as Error{
            print(error)
        }
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        //設置分數與日期label
        scoreLabel = UILabel(frame: CGRect(x: screenWidth/3, y: screenHeight/4, width: screenWidth/3, height: screenHeight/8))
        dateLabel = UILabel(frame: CGRect(x: 0, y: 3*screenHeight/8, width: screenWidth, height: screenHeight/8))
        delete = UIButton(frame: CGRect(x: screenWidth/3, y: screenHeight/2, width: screenWidth/3, height: screenHeight/8))
        scoreLabel?.text = "Your Score = \((user?.score)!)"
        scoreLabel?.textAlignment = .center
        dateLabel?.text = (user?.testDate!)?.description
        dateLabel?.textAlignment = .center
        //設置"臨時"的刪除coredata資料button
        delete?.setTitle("Delete", for: .normal)
        delete?.setTitleColor(.black, for: .normal)
        delete?.addTarget(self, action: #selector(self.deleteUserData), for: .touchDown)
        self.view.addSubview(scoreLabel!)
        self.view.addSubview(dateLabel!)
        self.view.addSubview(delete!)
        self.view.backgroundColor = .white
        appDelegate?.saveContext()
        //設置navigationItem
        self.navigationItem.title = "Test Score"
        
        //設置再次測試的按鈕在navigationItem
        leftButton = UIBarButtonItem(title: "Write Again", style: .done, target: self, action: #selector(self.writeAgain))
        self.navigationItem.setLeftBarButton(leftButton!, animated: true)
        //設置返回學生選單的按鈕
        rightButton = UIBarButtonItem(title: "Back Menu", style: .done, target: self, action: #selector(self.backToMenu))
        self.navigationItem.setRightBarButton(rightButton!, animated: true)
    }
    
    //刪除按鈕的方法
    @objc func deleteUserData(){
        do{
            let users = try context?.fetch(UserData.fetchRequest()) as! [UserData]
            for userData in users{
                context?.delete(userData)
            }
        }catch let error as Error{
            print(error)
        }
        appDelegate?.saveContext()
        print("delete")
    }
    
    //navigationItem的backbutton要返回mainviewcontroller的方法
    @objc func writeAgain(){
        self.navigationController?.pushViewController(MainViewController(), animated: true)
    }
    //navigationItem的rightBarButton返回menu的方法
    @objc func backToMenu(){
        self.navigationController?.pushViewController(StudentViewController(), animated: true)
    }
}
