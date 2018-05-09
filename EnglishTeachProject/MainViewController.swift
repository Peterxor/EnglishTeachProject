//
//  MainViewController.swift
//  EnglishTeachProject
//
//  Created by Peter on 2018/5/9.
//  Copyright © 2018年 Peter. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController{
    
    var questionLabel: UILabel?
    var choice1: UIButton?
    var choice2: UIButton?
    var choice3: UIButton?
    
    
    //this is data for test
    var testDataQuestion = ["question1", "question2"]
    var testDataChoice1 = ["choice1-1", "choice1-2"]
    var testDataChoice2 = ["choice2-1", "choice2-2"]
    var testDataChoice3 = ["choice3-1", "choice3_2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setLabelAndButton()
    }
    
    
    
    
    func setLabelAndButton(){
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        questionLabel = UILabel(frame: CGRect(x: screenWidth/5, y: screenHeight/10, width: screenWidth*3/5, height: screenHeight/3))
        questionLabel?.text = testDataQuestion[0]
        questionLabel?.textAlignment = .center
        choice1 = UIButton(frame: CGRect(x: screenWidth/5, y: screenHeight*19/30, width: screenWidth*3/5, height: screenHeight/20))
        choice2 = UIButton(frame: CGRect(x: screenWidth/5, y: screenHeight*22/30, width: screenWidth*3/5, height: screenHeight/20))
        choice3 = UIButton(frame: CGRect(x: screenWidth/5, y: screenHeight*25/30, width: screenWidth*3/5, height: screenHeight/20))
        
        choice1?.setTitle(testDataChoice1[0], for: .normal)
        choice2?.setTitle(testDataChoice2[0], for: .normal)
        choice3?.setTitle(testDataChoice3[0], for: .normal)
        
        choice1?.setTitleColor(.black, for: .normal)
        choice2?.setTitleColor(.black, for: .normal)
        choice3?.setTitleColor(.black, for: .normal)
        
        self.view.addSubview(questionLabel!)
        self.view.addSubview(choice1!)
        self.view.addSubview(choice2!)
        self.view.addSubview(choice3!)

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
