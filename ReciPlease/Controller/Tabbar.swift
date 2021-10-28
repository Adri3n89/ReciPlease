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
        searchNav.title = Constante.reciPlease
        searchNav.tabBarItem.title = Constante.search
        searchNav.tabBarItem.image = UIImage(systemName: Constante.searchIcon)
        
        let favorite = FavoriteViewController()
        let favoriteNav = UINavigationController(rootViewController: favorite)
        favoriteNav.title = Constante.reciPlease
        favorite.tabBarItem.title = Constante.favorite
        favorite.tabBarItem.image = UIImage(systemName: Constante.favoriteIcon)
        
        viewControllers = [searchNav, favoriteNav]
        tabBar.clipsToBounds = true
        tabBar.tintColor = Constante.blueColor
        tabBar.backgroundColor = Constante.greenColor
        tabBar.unselectedItemTintColor = .darkGray
    }
    
}
    
