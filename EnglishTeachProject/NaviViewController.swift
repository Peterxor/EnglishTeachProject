//
//  NaviViewController.swift
//  EnglishTeachProject
//
//  Created by Peter on 2018/5/30.
//  Copyright © 2018年 Peter. All rights reserved.
//

import Foundation
import UIKit

class NaviViewController: UINavigationController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barStyle = .black
        self.pushViewController(StudentViewController(), animated: true)
    }
}
