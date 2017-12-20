//
//  CustomTabBarVC.swift
//  GifApp


import UIKit


//Subclassed the Tab Bar View controller, in order to customize its appearance 
class CustomTabBarVC: UITabBarController,UITabBarControllerDelegate{

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        tabBar.itemWidth = UIScreen.main.bounds.width / 3
        tabBar.itemPositioning = .centered
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 12)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 12)!], for: .selected)
        
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.5)
    }
}
