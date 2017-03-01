//
//  SignInViewController.swift
//  Mega
//
//  Created by Tope Abayomi on 10/12/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

let api_endpoint:String = "http://www.yachoice.com/api/web_api.php"

class SignInViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet var titleLabel : UILabel!
    
    @IBOutlet var facebookButton : UIButton!
    @IBOutlet var twitterButton : UIButton!

    @IBOutlet var bgImageView : UIImageView!
    
    @IBOutlet var noAccountButton : UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    @IBOutlet var signInButton : UIButton!
    
    @IBOutlet var forgotPassword : UIButton!
    
    @IBOutlet var passwordContainer : UIView!
    @IBOutlet var passwordLabel : UILabel!
    @IBOutlet var passwordTextField : UITextField!
    @IBOutlet var passwordUnderline : UIView!

    @IBOutlet var userContainer : UIView!
    @IBOutlet var userLabel : UILabel!
    @IBOutlet var userTextField : UITextField!
    @IBOutlet var userUnderline : UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgImageView.image = UIImage(named: "nav-bg-2")
        bgImageView.contentMode = .scaleAspectFill
        
        titleLabel.text = "Sign In"
        titleLabel.font = UIFont(name: MegaTheme.semiBoldFontName, size: 25)
        titleLabel.textColor = UIColor.white
        
        twitterButton.setTitle("Sign in with Twitter", for: UIControlState())
        twitterButton.setTitleColor(UIColor.white, for: UIControlState())
        twitterButton.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 15)
        twitterButton.backgroundColor = UIColor(red: 0.23, green: 0.43, blue: 0.88, alpha: 1.0)
        twitterButton.addTarget(self, action: "dismiss", for: .touchUpInside)
        
        facebookButton.setTitle("Sign in with Facebook", for: UIControlState())
        facebookButton.setTitleColor(UIColor.white, for: UIControlState())
        facebookButton.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 16)
        facebookButton.backgroundColor = UIColor(red: 0.21, green: 0.30, blue: 0.55, alpha: 1.0)
        facebookButton.addTarget(self, action: "dismiss", for: .touchUpInside)
        

        let attributedText = NSMutableAttributedString(string: "Don't have an account? Sign up")
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, attributedText.length))
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.clear, range: NSMakeRange(23, 7))
        
        noAccountButton.setAttributedTitle(attributedText, for: UIControlState())
        noAccountButton.setTitleColor(UIColor.white, for: UIControlState())
        noAccountButton.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size:14)
        
        let attributedText1 = NSMutableAttributedString(string: "Sign up")
        attributedText1.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, 7))
        attributedText1.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, attributedText1.length))
        signUpButton.setAttributedTitle(attributedText1, for: UIControlState())
        signUpButton.setTitleColor(UIColor.white, for: UIControlState())
        signUpButton.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size:14)
        
        signInButton.setTitle("Sign In", for: UIControlState())
        signInButton.setTitleColor(UIColor.white, for: UIControlState())
        signInButton.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 22)
        signInButton.layer.borderWidth = 3
        signInButton.layer.borderColor = UIColor.white.cgColor
        signInButton.layer.cornerRadius = 5
        signInButton.addTarget(self, action: #selector(SignInViewController.signIn), for: .touchUpInside)
        
        forgotPassword.setTitle("Forgot Password?", for: UIControlState())
        forgotPassword.setTitleColor(UIColor.white, for: UIControlState())
        forgotPassword.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 15)
        
        passwordContainer.backgroundColor = UIColor.clear
        
        passwordLabel.text = "Password"
        passwordLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        passwordLabel.textColor = UIColor.white
        
        passwordTextField.text = ""
        passwordTextField.font = UIFont(name: MegaTheme.fontName, size: 20)
        passwordTextField.textColor = UIColor.white
        passwordTextField.isSecureTextEntry = true
        
        userContainer.backgroundColor = UIColor.clear
        
        userLabel.text = "Email"
        userLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        userLabel.textColor = UIColor.white
        
        userTextField.text = ""
        userTextField.font = UIFont(name: MegaTheme.fontName, size: 20)
        userTextField.textColor = UIColor.white
        
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
         titleLabel.isHidden = newCollection.verticalSizeClass == UIUserInterfaceSizeClass.compact    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func signIn(){
        
        if userTextField.text == "" {
            showErrorMsg("Email is required!")
            return
        }
        
        if passwordTextField.text == "" {
            showErrorMsg("Password is required!")
            return
        }
        
        let params = [
            "action": "login",
            "email":userTextField.text! as NSString,
            "password":passwordTextField.text! as NSString
        ]
        
        JHProgressHUD.sharedHUD.showInView(self.view, withHeader: nil, andFooter: "Logging in...")
        
        Alamofire.request(.POST, api_endpoint, parameters: params)
            .responseJSON { response in
                print(response)
                JHProgressHUD.sharedHUD.hide()
                if let JSON = response.result.value {
                    print("Log In Result: \(JSON)")
                    let res:NSDictionary = response.result.value as! NSDictionary
                    if( res["status"] as! String == "success") {
                        User.saveProfile(res["profile"] as! NSDictionary)
                        AppDelegate.SharedInstance.showMainNavigation()
                    } else {
                        self.showErrorMsg(res["reason"] as! String)
                    }
                    
                }
            }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
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


