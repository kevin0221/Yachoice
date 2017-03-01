//
//  CommentsViewController.swift
//  yachoice
//
//  Created by Admin on 3/18/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import RSKGrowingTextView
import SwiftyJSON
import Alamofire

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var commentTextView: RSKGrowingTextView!
    @IBOutlet var commentsTable: UITableView!
    
    var photo = [String:AnyObject]()
    var comments:[NSDictionary]!
    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.layer.borderColor = UIColor(red: 91/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1.0).cgColor
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.cornerRadius = 5
        comments = [NSDictionary]()
        self.getComments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getComments() {
        print("Get Comments")
        JHProgressHUD.sharedHUD.showInView(self.view, withHeader: nil, andFooter: "Loading...")
        let params = ["action":"get_comments","photo_id":JSON(photo)["id"].stringValue]
        print("Params \(params)")
        Alamofire.request(.POST, api_endpoint, parameters:params).responseJSON { response in
            //print(response)
            JHProgressHUD.sharedHUD.hide()
            if let JSON = response.result.value {
                //print(JSON)
                let res:NSArray = JSON["comments"] as! NSArray
                self.comments = res as! [NSDictionary]
                self.commentsTable.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if ((indexPath as NSIndexPath).row == 0) {
            let screenWidth = UIScreen.main.bounds.size.width
            let photo = JSON(self.photo)
            let comment = NSString(string:photo["memo"].stringValue)
            var commentHeight = CGFloat(0.0)
            if (comment != "") {
                let attrs = [NSFontAttributeName: UIFont(name: MegaTheme.lighterFontName, size: 12.0) as AnyObject]
                let rect = comment.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - UIScreen.main.bounds.size.width / 750.0  * 50.0, height: CGFloat.max), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrs, context: nil)
                commentHeight = rect.size.height
            }
            //print(comment)
            //print(commentHeight)
            return screenWidth + 60 + commentHeight
        } else {
            let comment = NSString(string:JSON(self.comments[(indexPath as NSIndexPath).row - 1])["comment"].stringValue)
            var commentHeight = CGFloat(0.0)
            if (comment != "") {
                let attrs = [NSFontAttributeName: UIFont(name: MegaTheme.lighterFontName, size: 12.0) as AnyObject]
                let rect = comment.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - UIScreen.main.bounds.size.width / 750.0  * 50.0, height: CGFloat.max), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrs, context: nil)
                commentHeight = rect.size.height
            }
            if (commentHeight > 40) {
                return 20 + commentHeight
            } else {
                return 60
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ((indexPath as NSIndexPath).row == 0) {
            let cellIdentifier = "MainCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MainCell
            let photo = JSON(self.photo)
            cell.lblName.text =  photo["username"].stringValue
            cell.lblTimeAgo.text = photo["time_ago"].stringValue
            let imgURL = photo["image_url"].string
            cell.imgPhoto.sd_setImage(with: URL(string: imgURL!), placeholderImage: nil)
            cell.lblComment.text = photo["memo"].string
            cell.lblComment.sizeToFit()
            
            return cell
        } else {
            let cellIdentifier = "CommentCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CommentCell
            let comment = JSON(comments[(indexPath as NSIndexPath).row - 1])
            cell.lblName.text = comment["username"].stringValue
            cell.lblComment.text = comment["comment"].stringValue
            cell.lblTimeAgo.text = comment["time_ago"].stringValue
            return cell
        }
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentsViewController.keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentsViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications () -> Void {
        let center:  NotificationCenter = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(_ notification: Notification) {
        var info = (notification as NSNotification).userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height + 5
            self.view.layoutIfNeeded()
            }, completion: { (finished) -> Void in
        })
    }
    
    func keyboardWillBeHidden (_ notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.bottomConstraint.constant = 5
            self.view.layoutIfNeeded()
            }, completion: { (finished) -> Void in
        })
        
    }
    
    @IBAction func tappedBackButton(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedSendButton(_ sender: AnyObject) {
        if (commentTextView.text != "") {
            let params = ["action":"add_comment", "user_id":User.myProfile.id, "comment":commentTextView.text, "photo_id":JSON(photo)["id"].stringValue]
            print("Params \(params)")
            JHProgressHUD.sharedHUD.showInView(self.view, withHeader: nil, andFooter: "Posting...")
            Alamofire.request(.POST, api_endpoint, parameters:params).responseJSON { response in
                //print(response)
                JHProgressHUD.sharedHUD.hide()
                if let result = response.result.value {
                    //print(result)
                    if (JSON(result)["status"].stringValue == "success") {
                        self.commentTextView.text = ""
                        self.commentTextView.resignFirstResponder()
                        self.getComments()
                    }
                }
            }
        }
    }
    
    @IBAction func handleTapGesture(_ sender: AnyObject) {
        commentTextView.resignFirstResponder()
    }
    
}
