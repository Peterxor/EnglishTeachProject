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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = (UIApplication.shared.delegate) as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
        do{
            var users = try context!.fetch(UserData.fetchRequest()) as! [UserData]
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
        scoreLabel = UILabel(frame: CGRect(x: screenWidth/3, y: screenHeight/4, width: screenWidth/3, height: screenHeight/8))
        dateLabel = UILabel(frame: CGRect(x: 0, y: 3*screenHeight/8, width: screenWidth, height: screenHeight/8))
        delete = UIButton(frame: CGRect(x: screenWidth/3, y: screenHeight/2, width: screenWidth/3, height: screenHeight/8))
        scoreLabel?.text = "Your Score = \((user?.score)!)"
        scoreLabel?.textAlignment = .center
        dateLabel?.text = (user?.testDate!)?.description
        dateLabel?.textAlignment = .center
        delete?.setTitle("Delete", for: .normal)
        delete?.setTitleColor(.black, for: .normal)
        delete?.addTarget(self, action: #selector(self.deleteUserData), for: .touchDown)
        self.view.addSubview(scoreLabel!)
        self.view.addSubview(dateLabel!)
        self.view.addSubview(delete!)
        self.view.backgroundColor = .white
        appDelegate?.saveContext()
    }
    
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
}
