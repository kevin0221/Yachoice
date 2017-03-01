//
//  SignUpViewController.swift
//  yachoice
//
//  Created by Admin on 2/20/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var fullnameContainer: UIView!
    @IBOutlet weak var fullnameUnderline: UIView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var fullnameTextField: UITextField!
    
    @IBOutlet weak var emailContainer: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailUnderline: UIView!
    
    @IBOutlet weak var usernameContainer: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameUnderline: UIView!
    
    @IBOutlet weak var passwordContainer: UIView!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordUnderline: UIView!
    
    @IBOutlet weak var passwordConfirmContainer: UIView!
    @IBOutlet weak var passwordConfirmLabel: UILabel!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var passwordConfirmUnderline: UIView!
    
    @IBOutlet weak var imgAgreeCheckBox: UIImageView!
    
    @IBOutlet weak var agreeLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var agreed:Int8!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Sign Up"
        titleLabel.font = UIFont(name: MegaTheme.semiBoldFontName, size: 25)
        titleLabel.textColor = UIColor.white
        
        fullnameContainer.backgroundColor = UIColor.clear
        
        fullnameLabel.text = "Name"
        fullnameLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        fullnameLabel.textColor = UIColor.white
        
        fullnameTextField.text = ""
        fullnameTextField.font = UIFont(name: MegaTheme.fontName, size: 20)
        fullnameTextField.textColor = UIColor.white
        
        emailContainer.backgroundColor = UIColor.clear
        
        emailLabel.text = "Email"
        emailLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        emailLabel.textColor = UIColor.white
        
        emailTextField.text = ""
        emailTextField.font = UIFont(name: MegaTheme.fontName, size: 20)
        emailTextField.textColor = UIColor.white
        
        usernameContainer.backgroundColor = UIColor.clear
        
        usernameLabel.text = "Username"
        usernameLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        usernameLabel.textColor = UIColor.white
        
        usernameTextField.text = ""
        usernameTextField.font = UIFont(name: MegaTheme.fontName, size: 20)
        usernameTextField.textColor = UIColor.white
        
        passwordContainer.backgroundColor = UIColor.clear
        
        passwordLabel.text = "Password"
        passwordLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        passwordLabel.textColor = UIColor.white
        
        passwordTextField.text = ""
        passwordTextField.font = UIFont(name: MegaTheme.fontName, size: 20)
        passwordTextField.textColor = UIColor.white
        
        
        passwordConfirmContainer.backgroundColor = UIColor.clear
        
        passwordConfirmLabel.text = "Confirm Password"
        passwordConfirmLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        passwordConfirmLabel.textColor = UIColor.white
        
        passwordConfirmTextField.text = ""
        passwordConfirmTextField.font = UIFont(name: MegaTheme.fontName, size: 20)
        passwordConfirmTextField.textColor = UIColor.white
        
        signUpButton.setTitle("Sign Up", for: UIControlState())
        signUpButton.setTitleColor(UIColor.white, for: UIControlState())
        signUpButton.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 22)
        signUpButton.layer.borderWidth = 3
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.layer.cornerRadius = 5
        signUpButton.addTarget(self, action: #selector(SignUpViewController.signup), for: .touchUpInside)
        
        loginButton.setTitle("Log in", for: UIControlState())
        loginButton.setTitleColor(UIColor.white, for: UIControlState())
        loginButton.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 15)
        loginButton.addTarget(self, action: #selector(SignUpViewController.tappedLoginBtn), for: .touchUpInside)
        
        agreeLabel.text = "18+ years old? Agree to terms?"
        agreeLabel.font = UIFont(name: MegaTheme.fontName, size: 15)
        agreeLabel.textColor = UIColor.white
        
        let tapCheckBox = UITapGestureRecognizer.init(target: self, action: #selector(SignUpViewController.tappedCheckbox(_:)))
        imgAgreeCheckBox.addGestureRecognizer(tapCheckBox)
        imgAgreeCheckBox.isUserInteractionEnabled = true
        
        let tapAgreeLabel = UITapGestureRecognizer.init(target: self, action: #selector(SignUpViewController.tappedTerms(_:)))
        agreeLabel.addGestureRecognizer(tapAgreeLabel)
        agreeLabel.isUserInteractionEnabled = true
        
        agreed = 0
        self.updateCheckBoxStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillDisappear(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func tappedCheckbox(_ sender:UITapGestureRecognizer) {
        if (agreed == 0) {
            agreed = 1
        } else {
            agreed = 0
        }
        self.updateCheckBoxStatus()
    }
    
    func tappedTerms(_ sender:UITapGestureRecognizer) {
        UIApplication.shared.openURL(URL(string: "http://yachoice.com/terms.php")!)
    }
    
    func updateCheckBoxStatus() {
        if (agreed == 1) {
            imgAgreeCheckBox.image = UIImage(named: "icon-checked")
        } else {
            imgAgreeCheckBox.image = UIImage(named: "icon-unchecked")
        }
    }
    
    func signup(){
        if emailTextField.text == "" {
            showErrorMsg("Email is required!")
            return
        }
        
        if usernameTextField.text == "" {
            showErrorMsg("Username is required!")
            return
        }
        
        if passwordTextField.text == "" {
            showErrorMsg("Password is required!")
            return
        }
        
        if passwordConfirmTextField.text == "" {
            showErrorMsg("Password confirm is required!")
            return
        }
        
        if passwordConfirmTextField.text != passwordTextField.text {
            showErrorMsg("Password doesn't match!")
            return
        }
        
        if (agreed == 0) {
            showErrorMsg("Are you 18+ years old? Do you agree terms?")
            return
        }
        
        let params = [
            "action": "register_user",
            "username":usernameTextField.text! as NSString,
            "email":emailTextField.text! as NSString,
            "password":passwordTextField.text! as NSString
        ]
        
        JHProgressHUD.sharedHUD.showInView(self.view, withHeader: nil, andFooter: "Registering...")
        
        Alamofire.request(.POST, api_endpoint, parameters: params)
            .responseJSON { response in
                JHProgressHUD.sharedHUD.hide()
                if let JSON = response.result.value {
                    print("Sign Up Result: \(JSON)")
                    let res:NSDictionary = response.result.value as! NSDictionary
                    if( res["status"] as! String == "success") {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.showErrorMsg(res["reason"] as! String)
                    }
                    
                }
        }

        dismiss(animated: true, completion: nil)
    }

    @IBAction func tappedBackBtn(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tappedLoginBtn() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillAppear(_ notification: Notification) {
        var info = (notification as NSNotification).userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.bottomConstraint.constant = -keyboardFrame.size.height + 121
            self.titleLabel.layer.opacity = 0;
            self.view.layoutIfNeeded()
            }, completion: { (finished) -> Void in
        })
    }
    
    func keyboardWillDisappear(_ notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.bottomConstraint.constant = -50
            self.titleLabel.layer.opacity = 1;
            self.view.layoutIfNeeded()
            }, completion: { (finished) -> Void in
        })
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
