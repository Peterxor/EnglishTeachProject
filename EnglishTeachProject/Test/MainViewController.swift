//
//  MainViewController.swift
//  EnglishTeachProject
//
//  Created by Peter on 2018/5/9.
//  Copyright © 2018年 Peter. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MainViewController: UIViewController, URLSessionDelegate, URLSessionDownloadDelegate{
    
    
    //題目與選項的標籤按鈕
    var questionLabel: UILabel?
    var choice1: UIButton?
    var choice2: UIButton?
    var choice3: UIButton?
    var curQuestion:Int?
    //從EnglishWebServer抓資料需要的物件
    var sourceURL: URL?
    var localURL: URL?
    var downloadTimer: Timer?
    var downloadFinished: Bool?
    var urlSession: URLSession?
    var pDatas: [[String:Any]]?
    var pData: [String: Any]?
    //答題時的回應，可刪除
    var alertRight: UIAlertController?
    var alertWrong: UIAlertController?
    //coredata的物件與鑰儲存的使用者資料
    var context: NSManagedObjectContext?
    var user: UserData?
    var appDelegate: AppDelegate?
    var questionScore: Int16?
    //預設的題數
    var questionNum: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
        user = UserData(context: self.context!)
        user?.testDate = Date()
        
        curQuestion = 0
        questionScore = Int16(10)
        
        alertRight = UIAlertController(title: "Correct", message: "Press OK to next question", preferredStyle: .actionSheet)
        alertWrong = UIAlertController(title: "Wrong", message: "Press OK to next question", preferredStyle: .actionSheet)
        let actionright = UIAlertAction(title: "OK", style: .default)
        let actionwrong = UIAlertAction(title: "OK", style: .default)
        alertRight?.addAction(actionright)
        alertWrong?.addAction(actionwrong)
        
        self.downloadFinished = false
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        self.localURL = urls[0].appendingPathComponent("data.json")
        self.sourceURL = URL(string: "http://localhost:8080/getProblem")
        self.downloadTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkDownload), userInfo: nil, repeats: true)
        getData(source: sourceURL!)
        
        self.navigationItem.title = "Writing"
        self.navigationItem
    }
    
    @objc func checkDownload(){
        if downloadFinished!{
            downloadTimer?.invalidate()
            setLabelAndButton()
            print(curQuestion!)
        }
    }
    
    func getData(source: URL){
        let config = URLSessionConfiguration.default
        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let downloadTask = urlSession?.downloadTask(with: source)
        downloadTask?.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        var data: Data?
        do{
            data = try Data(contentsOf: location)
            try data?.write(to: localURL!, options: .atomicWrite)
        }catch let error as Error{
            print(error)
            return
        }
        print("Complete")
        parseJson(dataURL: localURL!)
        downloadFinished = true
    }
    
    func parseJson(dataURL: URL){
        var data: Data?
        do{
            data = try Data(contentsOf: dataURL)
            pDatas = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String:Any]]
        } catch let error as Error{
            print(error)
            return
        }
        for pdata in pDatas! {
            print(pdata)
        }
    }
    
    
    func setLabelAndButton(){
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        questionLabel = UILabel(frame: CGRect(x: screenWidth/5, y: screenHeight/10, width: screenWidth*3/5, height: screenHeight/3))
        questionLabel?.textAlignment = .center
        questionNum = 10
        let num = Int(arc4random()) % questionNum!
        pData = pDatas!.remove(at: num)
        questionNum = questionNum! - 1
        questionLabel?.text = pData!["problem"] as? String
        choice1 = UIButton(type: .custom)
        choice2 = UIButton(type: .custom)
        choice3 = UIButton(type: .custom)
        
        choice1?.frame = CGRect(x: screenWidth/5, y: screenHeight*19/30, width: screenWidth*3/5, height: screenHeight/20)
        choice2?.frame = CGRect(x: screenWidth/5, y: screenHeight*22/30, width: screenWidth*3/5, height: screenHeight/20)
        choice3?.frame = CGRect(x: screenWidth/5, y: screenHeight*25/30, width: screenWidth*3/5, height: screenHeight/20)
        
        
        choice1?.setTitle(pData!["choice1"] as? String, for: .normal)
        choice2?.setTitle(pData!["choice2"] as? String, for: .normal)
        choice3?.setTitle(pData!["choice3"] as? String, for: .normal)
        
        choice1?.setTitleColor(.black, for: .normal)
        choice2?.setTitleColor(.black, for: .normal)
        choice3?.setTitleColor(.black, for: .normal)
        
        choice1?.addTarget(self, action: #selector(self.chooseOne), for: .touchDown)
        choice2?.addTarget(self, action: #selector(self.chooseTwo), for: .touchDown)
        choice3?.addTarget(self, action: #selector(self.chooseThree), for: .touchDown)
        
        self.view.addSubview(questionLabel!)
        self.view.addSubview(choice1!)
        self.view.addSubview(choice2!)
        self.view.addSubview(choice3!)

    }
    
    func updateLabelAndButton(pData: [String:Any]){
        questionLabel?.text = pData["problem"] as? String
        choice1?.setTitle(pData["choice1"] as? String, for: .normal)
        choice2?.setTitle(pData["choice2"] as? String, for: .normal)
        choice3?.setTitle(pData["choice3"] as? String, for: .normal)
    }
    
    @objc func chooseOne(){
        if pData!["answer"] as? Int == 1 {
            user?.score += questionScore!
            if questionNum! > 0{
                self.present(alertRight!, animated: true)
            }else {
                print("Your score: \(String(describing: user?.score))")
                appDelegate?.saveContext()
                self.navigationController?.pushViewController(AchieveViewController(), animated: true)
            }
        }else {
            if questionNum! > 0{
                self.present(alertWrong!, animated: true)
            }else {
                print("Your score: \((user?.score)!)")
                appDelegate?.saveContext()
                self.navigationController?.pushViewController(AchieveViewController(), animated: true)
            }
        }
        if questionNum! > 0{
            let num = Int(arc4random()) % questionNum!
            pData = pDatas!.remove(at: num)
            questionNum = questionNum! - 1
            updateLabelAndButton(pData: pData!)
        }
    }
    
    @objc func chooseTwo(){
        if pData!["answer"] as? Int == 2 {
            user?.score += questionScore!
            if questionNum! > 0{
                self.present(alertRight!, animated: true)
            }else {
                print("Your score: \((user?.score)!)")
                appDelegate?.saveContext()
                self.navigationController?.pushViewController(AchieveViewController(), animated: true)
            }
        }else {
            if questionNum! > 0{
                self.present(alertWrong!, animated: true)
            }else {
                print("Your score: \((user?.score)!)")
                appDelegate?.saveContext()
                self.navigationController?.pushViewController(AchieveViewController(), animated: true)
            }
        }
        if questionNum! > 0{
            let num = Int(arc4random()) % questionNum!
            pData = pDatas!.remove(at: num)
            questionNum = questionNum! - 1
            updateLabelAndButton(pData: pData!)
        }
    }
    
    @objc func chooseThree(){
        if pData!["answer"] as? Int == 3 {
            user?.score += questionScore!
            if questionNum! > 0{
                self.present(alertRight!, animated: true)
            }else {
                print("Your score: \((user?.score)!)")
                appDelegate?.saveContext()
                self.navigationController?.pushViewController(AchieveViewController(), animated: true)
            }
        }else {
            if questionNum! > 0{
                self.present(alertWrong!, animated: true)
            }else {
                print("Your score: \((user?.score)!)")
                appDelegate?.saveContext()
                self.navigationController?.pushViewController(AchieveViewController(), animated: true)
            }
        }
        if questionNum! > 0{
            let num = Int(arc4random()) % questionNum!
            pData = pDatas!.remove(at: num)
            questionNum = questionNum! - 1
            updateLabelAndButton(pData: pData!)
        }
    }
}
