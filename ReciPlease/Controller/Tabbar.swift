//
//  Tabbar.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 04/10/2021.
//

import UIKit

class Tabbar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let search = SearchViewController()
        let searchNav = UINavigationController(rootViewController: search)
        searchNav.title = "Reciplease"
        searchNav.tabBarItem.title = "Search"
        searchNav.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        let favorite = FavoriteViewController()
        let favoriteNav = UINavigationController(rootViewController: favorite)
        favoriteNav.title = "Reciplease"
        favorite.tabBarItem.title = "Favorite"
        favorite.tabBarItem.image = UIImage(systemName: "star.fill")
        
        viewControllers = [searchNav, favoriteNav]
        tabBar.clipsToBounds = true
        tabBar.tintColor = UIColor(displayP3Red: 199/255, green: 229/255, blue: 233/255, alpha: 1)
        tabBar.backgroundColor = UIColor(displayP3Red: 82/255, green: 181/255, blue: 176/255, alpha: 1)
        tabBar.unselectedItemTintColor = .darkGray

    }
    
}
