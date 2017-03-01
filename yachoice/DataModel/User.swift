//
//  User.swift
//  yachoice
//
//  Created by Admin on 2/22/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject {
    
    static let myProfile = User()
    var id:NSString!
    var email:NSString!
    var username:NSString!
    var fullname:NSString!
    var hide_in_wall:NSString!
    var search_by_id:NSString!
    var only_public_to_friends:NSString!
    var post_lifetime:NSString!
    
    override init() {
        super.init()
        self.loadData()
    }
    
    func loadData() {
        id = UserDefaults.standard.string(forKey: "id") as NSString!
        email = UserDefaults.standard.string(forKey: "email") as NSString!
        username = UserDefaults.standard.string(forKey: "username") as NSString!
        fullname = UserDefaults.standard.string(forKey: "fullname") as NSString!
        hide_in_wall = UserDefaults.standard.string(forKey: "hide_in_wall") as NSString!
        search_by_id = UserDefaults.standard.string(forKey: "search_by_id") as NSString!
        only_public_to_friends = UserDefaults.standard.string(forKey: "only_public_to_friends") as NSString!
        post_lifetime = UserDefaults.standard.string(forKey: "post_lifetime") as NSString!
    }
    
    static func saveProfile(_ userData:NSDictionary) {
        let json = JSON(userData)
        
        if let userId = json["id"].string {
            UserDefaults.standard.set(userId, forKey: "id")
        }
        
        if let userEmail = json["email"].string {
            UserDefaults.standard.set(userEmail, forKey: "email")
        }
        
        if let userName = json["username"].string {
            UserDefaults.standard.set(userName, forKey: "username")
        }
        
        if let fullname = json["fullname"].string {
            UserDefaults.standard.set(fullname, forKey: "fullname")
        }
        
        if let hide_in_wall = json["hide_in_wall"].string {
            UserDefaults.standard.set(hide_in_wall, forKey: "hide_in_wall")
        }
        
        if let search_by_id = json["search_by_id"].string {
            UserDefaults.standard.set(search_by_id, forKey: "search_by_id")
        }
        
        if let only_public_to_friends = json["only_public_to_friends"].string {
            UserDefaults.standard.set(only_public_to_friends, forKey: "only_public_to_friends")
        }
        
        if let posttime = json["post_lifetime"].string {
            UserDefaults.standard.set(posttime, forKey: "post_lifetime")
        }
        
        UserDefaults.standard.synchronize()
        
    }
    
    static func deleteProfile() {
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "fullname")
        UserDefaults.standard.removeObject(forKey: "hide_in_wall")
        UserDefaults.standard.removeObject(forKey: "search_by_id")
        UserDefaults.standard.removeObject(forKey: "only_public_to_friends")
        UserDefaults.standard.removeObject(forKey: "post_lifetime")
        
        UserDefaults.standard.synchronize()
    }
    
}
