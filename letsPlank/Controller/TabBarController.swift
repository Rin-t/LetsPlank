//
//  TabBarController.swift
//  letsPlank
//
//  Created by Rin on 2021/01/10.
//

import UIKit

class TabBarController: UITabBarController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        UITabBar.appearance().tintColor = .baseColour
        
        
//        for item in (self.tabBarController?.tabBar.items)! {
//            item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
        
    }
}
