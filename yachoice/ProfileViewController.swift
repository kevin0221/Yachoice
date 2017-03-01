//
//  ProfileViewController.swift
//  Mega
//
//  Created by Tope Abayomi on 20/11/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController : UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var bgImageView : UIImageView!
    @IBOutlet var profileImageView : UIImageView!
    
    @IBOutlet var profileContainer : UIView!
    @IBOutlet var doneButton : UIButton!
    
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var locationLabel : UILabel!
    @IBOutlet var locationImageView : UIImageView!
    
    @IBOutlet var followersLabel : UILabel!
    @IBOutlet var followersCount : UILabel!
    @IBOutlet var followingLabel : UILabel!
    @IBOutlet var followingCount : UILabel!
    @IBOutlet var photosLabel : UILabel!
    @IBOutlet var photosCount : UILabel!
    
    @IBOutlet var checkinsLabel : UILabel!
    @IBOutlet var friendsLabel : UILabel!
    
    @IBOutlet var photosContainer : UIView!
    @IBOutlet var photosCollectionLabel : UILabel!
    @IBOutlet var photosCollectionView : UICollectionView!
    @IBOutlet var photosLayout : UICollectionViewFlowLayout!
    
    var photos : [String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgImageView.image = UIImage(named: "profile-bg")
        profileImageView.image = UIImage(named: "profile-pic-1")
        profileImageView.layer.cornerRadius = 30
        profileImageView.clipsToBounds = true
        
        nameLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        nameLabel.textColor = UIColor.white
        nameLabel.text = "John Hoylett"
        
        locationLabel.font = UIFont(name: MegaTheme.fontName, size: 12)
        locationLabel.textColor = UIColor.white
        locationLabel.text = "London, UK"
        
        locationImageView.image = UIImage(named: "location")
        
        let statsCountFontSize : CGFloat = 16
        let statsLabelFontSize : CGFloat = 12
        let statsCountColor = UIColor.white
        let statsLabelColor = UIColor(white: 0.7, alpha: 1.0)
        
        followingCount.font = UIFont(name: MegaTheme.boldFontName, size: statsCountFontSize)
        followingCount.textColor = statsCountColor
        followingCount.text = "35"
        
        followingLabel.font = UIFont(name: MegaTheme.fontName, size: statsLabelFontSize)
        followingLabel.textColor = statsLabelColor
        followingLabel.text = "FOLLOWING"
        
        followersCount.font = UIFont(name: MegaTheme.boldFontName, size: statsCountFontSize)
        followersCount.textColor = statsCountColor
        followersCount.text = "2200"
        
        followersLabel.font = UIFont(name: MegaTheme.fontName, size: statsLabelFontSize)
        followersLabel.textColor = statsLabelColor
        followersLabel.text = "FOLLOWERS"
        
        photosCount.font = UIFont(name: MegaTheme.boldFontName, size: statsCountFontSize)
        photosCount.textColor = statsCountColor
        photosCount.text = "45"
        
        photosLabel.font = UIFont(name: MegaTheme.fontName, size: statsLabelFontSize)
        photosLabel.textColor = statsLabelColor
        photosLabel.text = "PHOTOS"
        
        addBlurView()
        
        photosCollectionLabel.font = UIFont(name: MegaTheme.boldFontName, size: 16)
        photosCollectionLabel.textColor = UIColor.black
        photosCollectionLabel.text = "PHOTOS (31)"
        
        photosContainer.backgroundColor = UIColor(white: 0.92, alpha: 1.0)
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        photosCollectionView.backgroundColor = UIColor.clear
        
        photosLayout.itemSize = CGSize(width: 90, height: 90)
        photosLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        photosLayout.minimumInteritemSpacing = 5
        photosLayout.minimumLineSpacing = 10
        photosLayout.scrollDirection = .horizontal
        
        photos = ["photos-1", "photos-2", "photos-3", "photos-4", "photos-5", "photos-6", "photos-7", "photos-8", "photos-9"]
        
        let doneImage = UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate)
        doneButton.setImage(doneImage, for: UIControlState())
        doneButton.tintColor = UIColor.white

    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath as NSIndexPath).row == 0{
            return 250
        } else {
            return 400
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as UICollectionViewCell
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        let photo = photos[(indexPath as NSIndexPath).row]
        imageView.image = UIImage(named: photo)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func doneTapped(_ sender: AnyObject?){
        dismiss(animated: true, completion: nil)
    }
}
