//
//  LeftMenuViewController.swift
//  SSASideMenuExample
//
//  Created by Sebastian Andersen on 20/10/14.
//  Copyright (c) 2015 Sebastian Andersen. All rights reserved.
//

import Foundation
import UIKit

class LeftMenuViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.frame = CGRect(x: 20, y: (self.view.frame.size.height - 54 * 7) / 2.0, width: self.view.frame.size.width, height: 54 * 7)
        tableView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isOpaque = false
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = nil
        tableView.bounces = false
        return tableView
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        view.addSubview(tableView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}


// MARK : TableViewDataSource & Delegate Methods

extension LeftMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
   
        let titles: [String] = ["Profile", "Home", "Search", "Notification", "Shop", "Log Out"]
        
        let images: [String] = ["profile", "home", "search", "notification", "shop", "logout"]
        
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 21)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text  = titles[(indexPath as NSIndexPath).row]
        cell.selectionStyle = .none
        cell.imageView?.image = UIImage(named: images[(indexPath as NSIndexPath).row])
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
     
        switch (indexPath as NSIndexPath).row {
        case 0:
            
            sideMenuViewController?.contentViewController = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")
            sideMenuViewController?.hideMenuViewController()
            break
        case 1:
            
            sideMenuViewController?.contentViewController = storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
            sideMenuViewController?.hideMenuViewController()
            break
            
        case 2:
            
            sideMenuViewController?.contentViewController = storyboard?.instantiateViewController(withIdentifier: "SearchViewController")
            sideMenuViewController?.hideMenuViewController()
            break
            
        case 3:
            
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: SearchViewController())
            sideMenuViewController?.hideMenuViewController()
            break
            
        case 4:
            
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: SearchViewController())
            sideMenuViewController?.hideMenuViewController()
            break
            
        case 5:
            User.deleteProfile()
            AppDelegate.SharedInstance.showSignUpNavigation()
            break
        default:
            break
        }
        
        
    }
    
}
    
