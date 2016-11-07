//
//  BaseTabBarController.swift
//  temadagar
//
//  Created by Alvar Lagerlöf on 08/09/16.
//  Copyright © 2016 Alvar Lagerlöf. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    @IBInspectable var defaultIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }
    
}