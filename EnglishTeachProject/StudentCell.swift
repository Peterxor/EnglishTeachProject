//
//  StudentCell.swift
//  EnglishTeachProject
//
//  Created by Peter on 2018/5/30.
//  Copyright © 2018年 Peter. All rights reserved.
//

import Foundation
import UIKit

class StudentCell: UICollectionViewCell{
    var leftBtn: UIButton?
    var rightBtn: UIButton?
    
    func setCell(left: String, right: String){
        let leftImage = UIImage(named: left)
        let rightImage = UIImage(named: right)
        
        let width = self.contentView.frame.width
        let height = self.contentView.frame.height
        
        leftBtn = UIButton(frame: CGRect(x: width/5, y: height/3, width: width/5, height: width/5))
        rightBtn = UIButton(frame: CGRect(x: 3*width/5, y: height/3, width: width/5, height: width/5))
        
        leftBtn?.setBackgroundImage(leftImage, for: .normal)
        rightBtn?.setBackgroundImage(rightImage, for: .normal)
        
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(leftBtn!)
        self.contentView.addSubview(rightBtn!)
    }
}
