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
    var deleteBtn: UIButton?
    var context: NSManagedObjectContext?
    var appDelegate: AppDelegate?
    var user: UserMO?
    var record: UserRecord?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        context = appDelegate?.persistentContainer.viewContext
        do{
            let users = try context!.fetch(UserMO.fetchRequest())
            user = users[0] as! UserMO
        }catch let error as Error{
            print(error)
        }
        
        user?.testDate = Date().description
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        scoreLabel = UILabel(frame: CGRect(x: screenWidth/3, y: screenHeight/4, width: screenWidth/3, height: screenHeight/8))
        dateLabel = UILabel(frame: CGRect(x: screenWidth/3, y: screenHeight/4, width: screenWidth/3, height: 3*screenHeight/8))
        scoreLabel?.text = "Your Score = \((user?.score)!)"
        scoreLabel?.textAlignment = .center
        dateLabel?.text = user?.testDate!
        dateLabel?.adjustsFontSizeToFitWidth
        print(user?.testDate)
        deleteBtn = UIButton(frame: CGRect(x: 2*screenWidth/3, y: screenHeight/5, width: screenWidth/3, height: screenHeight/5))
        deleteBtn?.setTitle("Delete", for: .normal)
        deleteBtn?.setTitleColor(.black, for: .normal)
        deleteBtn?.addTarget(self, action: #selector(self.deleteHistory), for: .touchDown)
        self.view.addSubview(deleteBtn!)
        self.view.addSubview(scoreLabel!)
        self.view.addSubview(dateLabel!)
        self.view.backgroundColor = .white
        
        saveTestData(user: user!, context: context!)
        appDelegate?.saveContext()
    }
    
    func saveTestData(user: UserMO, context: NSManagedObjectContext){
        var userHistory: TestHistoryMO?
        do{
            var testHistorys = try context.fetch(TestHistoryMO.fetchRequest())
            print("history num: \(testHistorys.count)")
            if testHistorys.count > 0{
                
            }else{
                userHistory = TestHistoryMO(context: context)
                let score = Int(user.score)
                let userTest = UserTest(score: score, date: user.testDate!)
                var userRecord = UserRecord(list: [])
                userRecord.list.append(userTest)
                let data = archieve(record: userRecord)
                userHistory?.history = data
                print(userHistory?.history)
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            }
        } catch let error as Error{
            print(error)
        }
    }
    
    @objc func deleteHistory(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        var userHistory: TestHistoryMO?
        do{
            var testHistorys = try context.fetch(TestHistoryMO.fetchRequest())
            if testHistorys.count > 0{
                userHistory = testHistorys[0] as! TestHistoryMO
                context.delete(userHistory!)
                delegate.saveContext()
                print("finish delete")
            }else{
                print("no testHistoryData")
            }
        }catch let error as Error{
            print(error)
        }
    }
    
    func archieve(record: UserRecord) -> Data{
        var r = record
        var data = Data(bytes: &r, count: MemoryLayout<UserRecord>.stride)
        return data
    }
    
    func deArchieve(data: Data) -> UserRecord?{
        guard data.count == MemoryLayout<UserRecord>.stride else {
            print("Error")
            return nil
        }
        var u: UserRecord?
        data.withUnsafeBytes { (pt:UnsafePointer<UserRecord>) -> Void in
            u = pt.pointee
        }
        return u
    }
}
