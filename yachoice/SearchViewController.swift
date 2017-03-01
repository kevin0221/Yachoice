//
//  ThirdViewController.swift
//  SSASideMenuStoryboardExample
//
//  Created by Admin on 2/21/16.
//  Copyright © 2016 SebastianAndersen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class SearchViewController: UIViewController {

    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchTable: UITableView!
    var users:[NSDictionary]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        users = [NSDictionary]()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "UserCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserCell
        let user = JSON(self.users[(indexPath as NSIndexPath).row])
        cell.lblUsername.text = user["username"].stringValue
        return cell
    }

    
    /*func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let keyword = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        searchUser(keyword)
        return true
    }*/
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let keyword = textField.text! as NSString
        searchUser(keyword as String)
        textField.resignFirstResponder()
        return true
    }
    
    func searchUser(_ keyword:String) {
        print(keyword)
        let params = ["action":"search_user", "keyword":keyword];
        JHProgressHUD.sharedHUD.showInView(self.view, withHeader: nil, andFooter: nil)
        print("Params \(params)")
        Alamofire.request(.POST, api_endpoint, parameters:params).responseJSON { response in
            //print(response)
            JHProgressHUD.sharedHUD.hide()
            if let result = response.result.value {
                //print(result)
                self.users = result["users"] as! NSArray as! [NSDictionary]
                self.searchTable.reloadData()
            }
        }
    }
}
