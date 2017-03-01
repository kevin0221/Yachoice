//
//  CameraViewController.swift
//  yachoice
//
//  Created by Admin on 2/22/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import KMPlaceholderTextView
import CoreLocation

class UploadViewController: UIViewController, CLLocationManagerDelegate {
    
    var imageTaken:UIImage!
    @IBOutlet var photoTaken: UIImageView!
    @IBOutlet var fullImageView: UIImageView!
    @IBOutlet var noteView: UIView!
    @IBOutlet var likeBtn: UIButton!
    @IBOutlet var bothBtn: UIButton!
    @IBOutlet var dislikeBtn: UIButton!
    @IBOutlet var anonymousBtn: UIButton!
    @IBOutlet var permanentBtn: UIButton!
    @IBOutlet var postBtn: UIButton!
    @IBOutlet var commentTextView: KMPlaceholderTextView!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    var type = "0"
    var anonymous = "0"
    var permanent = "1"
    
    let locationManager = CLLocationManager()
    var currentLocation:CLLocation!
    var locality = ""
    var country = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        photoTaken.image = imageTaken
        //fullImageView.image = imageTaken
        likeBtn.setTitle("Like", for: UIControlState())
        likeBtn.setTitleColor(UIColor(red: 91/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1), for: UIControlState())
        likeBtn.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 15)
        bothBtn.setTitle("Both", for: UIControlState())
        bothBtn.setTitleColor(UIColor(red: 91/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1), for: UIControlState())
        bothBtn.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 15)
        dislikeBtn.setTitle("Dislike", for: UIControlState())
        dislikeBtn.setTitleColor(UIColor(red: 91/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1), for: UIControlState())
        dislikeBtn.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 15)
        anonymousBtn.setTitle("Anonymous", for: UIControlState())
        anonymousBtn.setTitleColor(UIColor(red: 91/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1), for: UIControlState())
        anonymousBtn.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 15)
        let permanentBtnTitle = User.myProfile.post_lifetime as String + " Hours"
        permanentBtn.setTitle(permanentBtnTitle, for: UIControlState())
        permanentBtn.setTitleColor(UIColor(red: 91/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1), for: UIControlState())
        permanentBtn.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 15)
        postBtn.setTitle("Post", for: UIControlState())
        postBtn.setTitleColor(UIColor(red: 91/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1), for: UIControlState())
        postBtn.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 15)
        self.updateUIStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[locations.count - 1];
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.deregisterFromKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications ()-> Void   {
        
        NotificationCenter.default.addObserver(self, selector: #selector(UploadViewController.keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UploadViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications () -> Void {
        let center:  NotificationCenter = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(_ notification: Notification) {
        
        let info : NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info.object(forKey: UIKeyboardFrameBeginUserInfoKey) as AnyObject).cgRectValue.size
        let height = UIScreen.main.bounds.size.height / 1334.0 * 456 * 0.6
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.topConstraint.constant = -keyboardSize.height + height
            
            self.view.layoutIfNeeded()
            }, completion: { (finished) -> Void in
        })
    }
    
    func keyboardWillBeHidden (_ notification: Notification) {
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.topConstraint.constant = 0
            
            self.view.layoutIfNeeded()
            }, completion: { (finished) -> Void in
        })
    }
    
    func updateUIStatus() {
        if (type == "0") {
            likeBtn.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
            bothBtn.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
            dislikeBtn.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        } else if (type == "1") {
            likeBtn.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
            bothBtn.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
            dislikeBtn.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        } else {
            likeBtn.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
            bothBtn.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
            dislikeBtn.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        }
        
        if (anonymous == "0") {
            anonymousBtn.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        } else {
            anonymousBtn.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        }
        
        if (permanent == "1") {
            permanentBtn.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        } else {
            permanentBtn.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        }
    }
    
    @IBAction func backBtnTapped(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func post(_ sender: AnyObject) {
        //let writePath = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("item.jpg")
        //UIImageJPEGRepresentation(image, 1)!.writeToFile(writePath, atomically: true)
        
        //let fileURL = NSURL(fileURLWithPath: writePath)
        
        JHProgressHUD.sharedHUD.showInView(self.view, withHeader: nil, andFooter: "Uploading...")
        CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                self.locality = pm.locality! as String
                self.country = pm.country! as String
                //self.locality = "Tokyo"
                //self.country = "Japan"
            } else {
                print("Problem with the data received from geocoder")
            }
            let parameters = [
                "action": "add_photo",
                "user_id": User.myProfile.id,
                "type":self.type,
                "anonymous":self.anonymous,
                "permanent":self.permanent,
                "memo":self.commentTextView.text,
                "locality":self.locality,
                "country":self.country
            ]
            
            Alamofire.upload(
                .POST,
                api_endpoint,
                multipartFormData: { multipartFormData in
                
                    if let imgData = UIImageJPEGRepresentation(self.imageTaken, 0.1) {
                        print(imgData.count)
                        multipartFormData.appendBodyPart(data: imgData, name: "files", fileName: "file.jpg", mimeType: "image/jpeg")
                    }
                
                    for (key, value) in parameters {
                        multipartFormData.appendBodyPart(data: value.data(using: String.Encoding.utf8)!, name: key)
                    }
                
                },
                encodingCompletion: { encodingResult in
                    print(encodingResult)
                    switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                JHProgressHUD.sharedHUD.hide()
                                debugPrint(response)
                            }
                        case .failure(let encodingError):
                            JHProgressHUD.sharedHUD.hide()
                            print(encodingError)
                    }
                }
            )
        })
    }
    
    @IBAction func like(_ sender: AnyObject) {
        type = "0"
        self.updateUIStatus()
    }
    
    @IBAction func both(_ sender: AnyObject) {
        type = "1"
        self.updateUIStatus()
    }
    
    @IBAction func dislike(_ sender: AnyObject) {
        type = "2"
        self.updateUIStatus()
    }
    
    @IBAction func anonymous(_ sender: AnyObject) {
        if (anonymous == "0") {
            anonymous = "1"
        } else {
            anonymous = "0"
        }
        self.updateUIStatus()
    }
    
    @IBAction func permanent(_ sender: AnyObject) {
        if (permanent == "0") {
            permanent = "1"
        } else {
            permanent = "0"
        }
        self.updateUIStatus()
    }
    
    @IBAction func endEditing(_ sender: AnyObject) {
        commentTextView.endEditing(true)
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
