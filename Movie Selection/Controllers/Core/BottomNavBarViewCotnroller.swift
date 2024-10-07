//
//  ViewController.swift
//  Movie Selection
//
//  Created by Hafiz on 20/09/2024.
//

import UIKit

class BottomNavBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        
        let homeButton = UINavigationController(rootViewController: HomeViewController())
        let downloadButton = UINavigationController(rootViewController: DownloadListViewController())
        let upcomingButton = UINavigationController(rootViewController: UpcomingViewController())
        let searchButton = UINavigationController(rootViewController: SearchViewController())
        
        homeButton.tabBarItem.image = UIImage(systemName: "house")
        downloadButton.tabBarItem.image = UIImage(systemName: "arrow.down.circle")
        upcomingButton.tabBarItem.image = UIImage(systemName: "movieclapper")
        searchButton.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        homeButton.title = "Home"
        downloadButton.title = "Download"
        upcomingButton.title = "Coming Soon"
        searchButton.title = "Search"
        
        tabBar.tintColor = .label
        
        
        
        setViewControllers([homeButton, downloadButton, upcomingButton, searchButton], animated: true)
        
    }


}

