//
//  CustomTabbarController.swift
//  Events-List
//
//  Created by Rama Milaneh on 1/28/17.
//  Copyright © 2017 Rama Milaneh. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 1
//        
//        let layout2 = UICollectionViewFlowLayout()
//        layout2.minimumLineSpacing = 1

        let eventsController = EventsViewController()
        let eventsNavController = UINavigationController(rootViewController: eventsController)
        eventsNavController.tabBarItem.image = UIImage(named: "calendar")?.tint(color: UIColor.red)
       self.tabBar.tintColor = UIColor.red
        
        let favoriteViewController = FavoriteEventsViewController()
        let favoriteNavController = UINavigationController(rootViewController: favoriteViewController)
        favoriteNavController.tabBarItem.image = UIImage(named: "star")?.tint(color: UIColor.red)
        
        viewControllers = [eventsNavController,favoriteNavController]
    }
}
