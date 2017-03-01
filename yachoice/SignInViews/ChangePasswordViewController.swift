//
//  ChangePasswordViewController.swift
//  yachoice
//
//  Created by Admin on 3/2/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import Alamofire

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var codeContainer: UIView!
    @IBOutlet weak var codeUnderline: UIView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var codeTextField: UITextField!
    
    @IBOutlet weak var passwordContainer: UIView!
    @IBOutlet weak var passwordUnderline: UIView!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordConfirmContainer: UIView!
    @IBOutlet weak var passwordConfirmUnderline: UIView!
    @IBOutlet weak var passwordConfirmLabel: UILabel!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Change Password"
        titleLabel.font = UIFont(name: MegaTheme.semiBoldFontName, size: 25)
        titleLabel.textColor = UIColor.white
        
        
        codeContainer.backgroundColor = UIColor.clear
        
        codeLabel.text = "Code"
        codeLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        codeLabel.textColor = UIColor.white
        
        codeTextField.text = ""
        codeTextField.font = UIFont(name: MegaTheme.fontName, size: 20)
        codeTextField.textColor = UIColor.white
        
        passwordContainer.backgroundColor = UIColor.clear
        
        passwordLabel.text = "New Password"
        passwordLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        passwordLabel.textColor = UIColor.white
        
        passwordTextField.text = ""
        passwordTextField.font = UIFont(name: MegaTheme.fontName, size: 20)
        passwordTextField.textColor = UIColor.white
        
        
        passwordConfirmContainer.backgroundColor = UIColor.clear
        
        passwordConfirmLabel.text = "Confirmation"
        passwordConfirmLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        passwordConfirmLabel.textColor = UIColor.white
        
        passwordConfirmTextField.text = ""
        passwordConfirmTextField.font = UIFont(name: MegaTheme.fontName, size: 20)
        passwordConfirmTextField.textColor = UIColor.white
        
        submitButton.setTitle("Submit", for: UIControlState())
        submitButton.setTitleColor(UIColor.white, for: UIControlState())
        submitButton.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 22)
        submitButton.layer.borderWidth = 3
        submitButton.layer.borderColor = UIColor.white.cgColor
        submitButton.layer.cornerRadius = 5
        submitButton.addTarget(self, action: #selector(ChangePasswordViewController.submit), for: .touchUpInside)
        
        loginButton.setTitle("Log in", for: UIControlState())
        loginButton.setTitleColor(UIColor.white, for: UIControlState())
        loginButton.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 15)
        loginButton.addTarget(self, action: #selector(ChangePasswordViewController.tappedLoginBtn), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    func submit() {
        if codeTextField.text == "" {
            showErrorMsg("Code is required!")
            return
        }
        
        if passwordTextField.text == "" {
            showErrorMsg("New password is required!")
            return
        }
        
        if passwordTextField.text != passwordConfirmTextField.text {
            showErrorMsg("Password doesn't match!")
            return
        }
        
        let params = [
            "action": "change_password",
            "code":codeTextField.text! as NSString,
            "password":passwordTextField.text! as NSString
        ]
        
        JHProgressHUD.sharedHUD.showInView(self.view, withHeader: nil, andFooter: nil)
        
        Alamofire.request(.POST, api_endpoint, parameters: params)
            .responseJSON { response in
                JHProgressHUD.sharedHUD.hide()
                if let JSON = response.result.value {
                    print("Result: \(JSON)")
                    let res:NSDictionary = response.result.value as! NSDictionary
                    if( res["status"] as! String == "success") {
                        self.codeTextField.text = ""
                        self.passwordTextField.text = ""
                        self.passwordConfirmTextField.text = ""
                        
                        let alertController:UIAlertController = UIAlertController(title: nil, message: "Password has been changed successfully!", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) -> Void in
                            
                        })
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: { () -> Void in
                        })
                        
                    } else {
                        self.showErrorMsg(res["reason"] as! String)
                    }
                    
                }
        }
    }
    
    func tappedLoginBtn() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func showErrorMsg(_ msg:String) {
        let alertController:UIAlertController = UIAlertController(title: nil, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) -> Void in
            
        })
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: { () -> Void in
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
