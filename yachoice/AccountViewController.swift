//
//  AccountViewController.swift
//  Mega
//
//  Created by Tope Abayomi on 21/11/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class AccountViewController : UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var profileImageView  : UIImageView!
   
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var editAvatarButton  : UIButton!
    
    @IBOutlet var bgImageView : UIImageView!
    @IBOutlet var profileContainer : UIView!
    @IBOutlet var doneButton : UIButton!
    
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var nameTextField : UITextField!
    @IBOutlet var emailLabel : UILabel!
    @IBOutlet var emailTextField : UITextField!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet weak var hideInWallLabel: UILabel!
    @IBOutlet weak var hideInWallSwitch: UISwitch!
    @IBOutlet weak var searchByIdLabel: UILabel!
    @IBOutlet weak var searchByIdSwitch: UISwitch!
    @IBOutlet weak var onlyPublicToFriendsLabel: UILabel!
    @IBOutlet weak var onlyPublicToFriendsSwitch: UISwitch!
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var postTimeTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = UIColor(white: 0.92, alpha: 1.0)
        
        bgImageView.image = UIImage(named: "profile-bg")
        profileImageView.image = UIImage(named: "profile-pic-1")
        profileImageView.layer.cornerRadius = 30
        profileImageView.clipsToBounds = true
        
        themeButtonWithText(editAvatarButton, text: "EDIT AVATAR")
        themeButtonWithText(saveButton, text: "SAVE CHANGES")
        
        themeLabelWithText(nameLabel, text: "Name")
        themeTextFieldWithText(nameTextField, text: User.myProfile.fullname as String)

        themeLabelWithText(emailLabel, text: "E-mail")
        themeTextFieldWithText(emailTextField, text: User.myProfile.email as String)
        
        themeLabelWithText(usernameLabel, text: "Username(ID)")
        themeTextFieldWithText(usernameTextField, text: User.myProfile.username as String)
        
        themeLabelWithText(hideInWallLabel, text: "Other can click to your profile")
        if (User.myProfile.hide_in_wall.isEqual(to: "0")) {
            hideInWallSwitch.setOn(true, animated: false)
        } else {
            hideInWallSwitch.setOn(false, animated: false)
        }
        
        themeLabelWithText(searchByIdLabel, text: "Must by found by ID")
        if (User.myProfile.search_by_id.isEqual(to: "1")) {
            searchByIdSwitch.setOn(true, animated: false)
        } else {
            searchByIdSwitch.setOn(false, animated: false)
        }
        
        themeLabelWithText(onlyPublicToFriendsLabel, text: "Need approval to view profile")
        if (User.myProfile.only_public_to_friends.isEqual(to: "1")) {
            onlyPublicToFriendsSwitch.setOn(true, animated: false)
        } else {
            onlyPublicToFriendsSwitch.setOn(false, animated: false)
        }
        
        themeLabelWithText(postTimeLabel, text: "Post time (Hours)")
        themeTextFieldWithText(postTimeTextField, text: User.myProfile.post_lifetime as String)
        
        
        let doneImage = UIImage(named: "icon-left-arrow")?.withRenderingMode(.alwaysTemplate)
        doneButton.setImage(doneImage, for: UIControlState())
        doneButton.tintColor = UIColor.white
        
        addBlurView()
    }
    
    @IBAction func saveChanges(_ sender: AnyObject) {
        var params:Dictionary<String, String> = [ : ]
        params["action"] = "update_user"
        params["userId"] = User.myProfile.id as String
        /*print(params)
        var params1 = [String:AnyObject]()
        let arr = ["a", "b", "c"]
        params1["actions"] = NSString(string: "update_user")
        params1["arr"] = arr
        print(params1)*/
        if (User.myProfile.fullname != nameTextField.text ) {
            params["fullname"] = nameTextField.text
        }
        
        if (User.myProfile.email != emailTextField.text) {
            params["email"] = emailTextField.text
        }
        
        if (User.myProfile.username != usernameTextField.text) {
            params["username"] = usernameTextField.text
        }
        
        
        if (hideInWallSwitch.isOn) {
            if (User.myProfile.hide_in_wall == "1") {
                params["hide_in_wall"] = "0"
            }
        } else {
            if (User.myProfile.hide_in_wall == "0") {
                params["hide_in_wall"] = "1"
            }
        }
        
        if (searchByIdSwitch.isOn) {
            if (User.myProfile.search_by_id == "0") {
                params["search_by_id"] = "1"
            }
        } else {
            if (User.myProfile.search_by_id == "1") {
                params["search_by_id"] = "0"
            }
        }
        
        if (onlyPublicToFriendsSwitch.isOn) {
            if (User.myProfile.only_public_to_friends == "0") {
                params["only_public_to_friends"] = "1"
            }
        } else {
            if (User.myProfile.only_public_to_friends == "1") {
                params["only_public_to_friends"] = "0"
            }
        }
        
        if (User.myProfile.post_lifetime != postTimeTextField.text) {
            params["post_lifetime"] = postTimeTextField.text
        }
        
        print("Changed Params \(params)")
        print(params.count)
        if (params.count > 2) {
            JHProgressHUD.sharedHUD.showInView(self.view, withHeader: nil, andFooter: "Saving changes...")
            
            Alamofire.request(.POST, api_endpoint, parameters: params)
                .responseJSON { response in
                    JHProgressHUD.sharedHUD.hide()
                    if let JSON = response.result.value {
                        print("Update Result: \(JSON)")
                        let res:NSDictionary = response.result.value as! NSDictionary
                        if( res["status"] as! String == "success") {
                            print(res["profile"])
                            User.saveProfile(res["profile"] as! NSDictionary)
                            User.myProfile.loadData()
                        } else {
                            self.showErrorMsg(res["reason"] as! String)
                        }
                        
                    }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath as NSIndexPath).row == 0{
            return 150
        }else{
            return 44
        }
    }

    
    func themeButtonWithText(_ button: UIButton, text:String){
        let background = UIImage(named: "border-button")?.resizableImage(withCapInsets: UIEdgeInsetsMake(10, 10, 10, 10))
        let backgroundTemplate = background!.withRenderingMode(.alwaysTemplate)
        
        button.setBackgroundImage(backgroundTemplate, for: UIControlState())
        button.setTitle(text, for: UIControlState())
        button.titleLabel?.font = UIFont(name: MegaTheme.fontName, size: 11)
        button.tintColor = UIColor.white
    }
    
    func themeTextFieldWithText(_ textField:UITextField, text: String){
        let largeFontSize : CGFloat = 17
        textField.font = UIFont(name: MegaTheme.lighterFontName, size: largeFontSize)
        textField.textColor = MegaTheme.darkColor
        textField.text = text
        textField.delegate = self
    }
    
    func themeLabelWithText(_ label: UILabel, text: String){
        let fontSize : CGFloat = 12
        label.font = UIFont(name: MegaTheme.boldFontName, size: fontSize)
        label.textColor = MegaTheme.darkColor
        label.text = text
    }
    
    func addBlurView(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRect(x: 0, y: 0, width: 600, height: 100)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        profileContainer.insertSubview(blurView, aboveSubview: bgImageView)
        
        let topConstraint = NSLayoutConstraint(item: profileContainer, attribute: .top, relatedBy: .equal, toItem: blurView, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let bottomConstraint = NSLayoutConstraint(item: profileContainer, attribute: .bottom, relatedBy: .equal, toItem: blurView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        let leftConstraint = NSLayoutConstraint(item: profileContainer, attribute: .left, relatedBy: .equal, toItem: blurView, attribute: .left, multiplier: 1.0, constant: 0.0)
        
        let rightConstraint = NSLayoutConstraint(item: profileContainer, attribute: .right, relatedBy: .equal, toItem: blurView, attribute: .right, multiplier: 1.0, constant: 0.0)
        
        self.profileContainer.addConstraints([topConstraint, rightConstraint, leftConstraint, bottomConstraint])
    }
    
    @IBAction func doneTapped(_ sender: AnyObject?){
        navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.deregisterFromKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications ()-> Void   {
        
        NotificationCenter.default.addObserver(self, selector: #selector(AccountViewController.keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AccountViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications () -> Void {
        let center:  NotificationCenter = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(_ notification: Notification) {
        
        let info : NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info.object(forKey: UIKeyboardFrameBeginUserInfoKey) as AnyObject).cgRectValue.size
        let insets: UIEdgeInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, keyboardSize.height, 0)
        
        self.tableView.contentInset = insets
        self.tableView.scrollIndicatorInsets = insets
        
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: self.tableView.contentOffset.y + keyboardSize.height)
    }
    
    func keyboardWillBeHidden (_ notification: Notification) {
        
        let info : NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info.object(forKey: UIKeyboardFrameBeginUserInfoKey) as AnyObject).cgRectValue.size
        let insets: UIEdgeInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, keyboardSize.height, 0)
        
        self.tableView.contentInset = insets
        self.tableView.scrollIndicatorInsets = insets
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = .none
    }
    
    override func viewDidLayoutSubviews() {
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
    }
    
    func showErrorMsg(_ msg:String) {
        let alertController:UIAlertController = UIAlertController(title: nil, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) -> Void in
            
        })
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: { () -> Void in
        })
    }
}
