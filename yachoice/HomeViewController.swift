//
//  FirstViewController.swift
//  SSASideMenuExample
//
//  Created by Sebastian Andersen on 20/10/14.
//  Copyright (c) 2015 Sebastian Andersen. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON
import SDWebImage
import CoreLocation

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var photoTable: UITableView!
    
    @IBOutlet var previewView: UIView!
    
    @IBOutlet var locationSegment: UISegmentedControl!
    var currentPage = 0
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var photos:[NSDictionary]!
    
    let locationManager = CLLocationManager()
    var currentLocation:CLLocation!
    var locality = ""
    var country = ""
    var location = "Local"
    var gettingAddress = false
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        photos = [NSDictionary]()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (locality != "" && country != "") {
            self.getPhotos()
        }
        
        /*captureSession = AVCaptureSession()
        //captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        //captureSession!.sessionPreset = AVCaptureSessionPreset640x480
        captureSession!.sessionPreset = AVCaptureSessionPreset1280x720
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
                previewView.layer.addSublayer(previewLayer!)
                
                captureSession!.startRunning()
            }
        }*/

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //previewLayer!.frame = previewView.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[locations.count - 1];
        if (locality == "" && country == "" && gettingAddress == false) {
            gettingAddress = true
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
                    self.getPhotos()
                    self.locationManager.stopUpdatingLocation()
                } else {
                    print("Problem with the data received from geocoder")
                }
            })
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Scroll Ended")
        if (scrollView == self.scrollView) {
            let pageWidth = UIScreen.main.bounds.size.width
            let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth)) + 1
            
            if (currentPage == 0 && page == 0) {
                print("Show Menu")
                currentPage = page
                self.presentLeftMenuViewController()
            } else {
                if (currentPage == 1 && page == 0) {
                    self.getPhotos()
                }
                currentPage = page
            }
        }
    }
    
    @IBAction func changeLocation(_ sender: AnyObject) {
        if (locationSegment.selectedSegmentIndex == 0) {
            print("Local")
            self.location = "Local"
            self.getPhotos()
        } else if (locationSegment.selectedSegmentIndex == 1) {
            print("Nation")
            self.location = "Nation"
            self.getPhotos()
        } else {
            print("World")
            self.location = "World"
            self.getPhotos()
        }
    }
    
    func getPhotos() {
        print("Get Photos")
        JHProgressHUD.sharedHUD.showInView(self.view, withHeader: nil, andFooter: "Loading...")
        let params = ["action":"get_photos","location":self.location, "locality":self.locality, "country":self.country, "user_id":User.myProfile.id] as [String : Any]
        print("Params \(params)")
        Alamofire.request(.POST, api_endpoint, parameters:params).responseJSON { response in
            //print(response)
            JHProgressHUD.sharedHUD.hide()
            if let JSON = response.result.value {
                //print(JSON)
                let res:NSArray = JSON["photos"] as! NSArray
                self.photos = res as! [NSDictionary]
                self.photoTable.reloadData()
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        let photo = JSON(self.photos[(indexPath as NSIndexPath).row])
        let comment = NSString(string:photo["memo"].stringValue)
        var commentHeight = CGFloat(0.0)
        if (comment != "") {
            let attrs = [NSFontAttributeName: UIFont(name: MegaTheme.lighterFontName, size: 12.0) as AnyObject]
            let rect = comment.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - UIScreen.main.bounds.size.width / 750.0  * 50.0, height: CGFloat.max), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrs, context: nil)
            commentHeight = rect.size.height
        }
        //print(comment)
        //print(commentHeight)
        
        var commentsHeight = CGFloat(0.0)
        let comments = photo["comments"].arrayValue
        if (comments.count == 0) {
            commentsHeight = 0.0
        }
        if (comments.count > 0){
            let string1 = NSString(string:comments[0]["username"].stringValue + " " + comments[0]["comment"].stringValue)
            //print(string1)
            let attrs = [NSFontAttributeName: UIFont(name: MegaTheme.semiBoldFontName, size: 12.0) as AnyObject]
            let rect = string1.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - UIScreen.main.bounds.size.width / 750.0  * 50.0, height: CGFloat.max), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrs, context: nil)
            //print(rect.size.height)
            commentsHeight += rect.size.height + 5.0 + 35.0
        }
        
        if (comments.count > 1){
            let string2 = NSString(string:comments[1]["username"].stringValue + " " + comments[1]["comment"].stringValue)
            //print(string2)
            let attrs = [NSFontAttributeName: UIFont(name: MegaTheme.semiBoldFontName, size: 12.0) as AnyObject]
            let rect = string2.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - UIScreen.main.bounds.size.width / 750.0  * 50.0, height: CGFloat.max), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrs, context: nil)
            //print(rect.size.height)
            commentsHeight += rect.size.height
        }
        
        return screenWidth + 130 + commentHeight + commentsHeight
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "PhotoCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PhotoCell
        let photo = JSON(self.photos[(indexPath as NSIndexPath).row])
        
        if ( photo["anonymous"] == "1" ){
            cell.lblUsername.text = "Anonymous"
        } else {
            if (photo["hide_in_wall"] == "1") {
                cell.lblUsername.text = photo["fullname"].stringValue
            } else {
                cell.lblUsername.text = photo["username"].stringValue
            }
        }
        
        cell.lblTimeAgo.text = photo["time_ago"].stringValue
        if (photo["type"] == "0") {
            cell.actionButton1 .setImage(UIImage(named: "icon-like"), for: UIControlState())
            cell.actionButton2 .setImage(UIImage(named: "icon-comment"), for: UIControlState())
            cell.actionButton3.isHidden = true
        } else if (photo["type"] == "1") {
            cell.actionButton1 .setImage(UIImage(named: "icon-like"), for: UIControlState())
            cell.actionButton2 .setImage(UIImage(named: "icon-dislike"), for: UIControlState())
            cell.actionButton3 .setImage(UIImage(named: "icon-comment"), for: UIControlState())
            cell.actionButton3.isHidden = false
        } else {
            cell.actionButton1 .setImage(UIImage(named: "icon-dislike"), for: UIControlState())
            cell.actionButton2 .setImage(UIImage(named: "icon-comment"), for: UIControlState())
            cell.actionButton3.isHidden = true
        }
        
        let imgURL = photo["image_url"].string
        cell.imgPhoto.sd_setImage(with: URL(string: imgURL!), placeholderImage: nil)
        cell.lblComment.text = photo["memo"].string
        cell.lblComment.sizeToFit()
        
        if ( photo["type"] == "0" ) {
            cell.imgStat1.image = UIImage(named: "icon-like")
            cell.lblStat1.text = photo["likes"].stringValue + " likes"
            cell.imgStat2.isHidden = true
            cell.lblStat2.isHidden = true
        } else if ( photo["type"] == "1" ) {
            cell.imgStat1.image = UIImage(named: "icon-like")
            cell.lblStat1.text = photo["likes"].stringValue + " likes"
            cell.imgStat2.image = UIImage(named: "icon-dislike")
            cell.lblStat2.text = photo["dislikes"].stringValue + " dislikes"
            cell.imgStat2.isHidden = false
            cell.lblStat2.isHidden = false
        } else {
            cell.imgStat1.image = UIImage(named: "icon-dislike")
            cell.lblStat1.text = photo["dislikes"].stringValue + " dislikes"
            cell.imgStat2.isHidden = true
            cell.lblStat2.isHidden = true
        }
        
        if ( photo["comments"].arrayValue.count > 0 ) {
            let content = NSMutableAttributedString(string: photo["comments"].arrayValue[0]["username"].stringValue + " " + photo["comments"].arrayValue[0]["comment"].stringValue, attributes: [NSFontAttributeName:UIFont(name: MegaTheme.lighterFontName, size: 12.0)!])
            content.addAttribute(NSFontAttributeName, value: UIFont(name: MegaTheme.semiBoldFontName, size: 12.0)!, range: NSRange(location:0,length:NSString(string:photo["comments"].arrayValue[0]["username"].stringValue).length)
            )
            cell.lblComment1.attributedText = content
            cell.lblComment1.sizeToFit()
        }
        
        if ( photo["comments"].arrayValue.count > 1 ) {
            let content = NSMutableAttributedString(string: photo["comments"].arrayValue[1]["username"].stringValue + " " + photo["comments"].arrayValue[1]["comment"].stringValue, attributes: [NSFontAttributeName:UIFont(name: MegaTheme.lighterFontName, size: 12.0)!])
            content.addAttribute(NSFontAttributeName, value: UIFont(name: MegaTheme.semiBoldFontName, size: 12.0)!, range: NSRange(location:0,length:NSString(string:photo["comments"].arrayValue[1]["username"].stringValue).length)
            )
            
            cell.lblComment2.attributedText = content
            cell.lblComment2.sizeToFit()
        }
        cell.actionButton1.tag = (indexPath as NSIndexPath).row
        cell.actionButton2.tag = (indexPath as NSIndexPath).row
        cell.actionButton3.tag = (indexPath as NSIndexPath).row
        cell.reportButton.tag = (indexPath as NSIndexPath).row
        cell.viewAllButton.tag = (indexPath as NSIndexPath).row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func takePhoto(_ sender: AnyObject) {
        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProvider(data: imageData as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                    
                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.up)
                    let refWidth = image.size.width
                    let refHeight = image.size.height
                    print("Width \(refWidth)")
                    print("Height \(refHeight)")
                    let posX = refWidth / 1334.0 * 128.0
                    
                    let cropRect = CGRect(x: posX, y: 0.0, width: refHeight, height: refHeight)
                    print(cropRect)
                    
                    let imageRef = image.cgImage!.cropping(to: cropRect)
                    let imageCropped = UIImage(cgImage: imageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    let refWidth1 = imageCropped.size.width
                    let refHeight1 = imageCropped.size.height
                    print("Width \(refWidth1)")
                    print("Height \(refHeight1)")
                    
                    let uploadViewController = self.storyboard?.instantiateViewController(withIdentifier: "UploadViewController") as! UploadViewController
                    uploadViewController.imageTaken = imageCropped
                    
                    self.navigationController?.pushViewController(uploadViewController, animated: true)
                }
            })
        }

    }
  
    @IBAction func tappedAction1(_ sender: AnyObject) {
        let btn = sender as! UIButton
        let type = JSON(self.photos[btn.tag])["type"]
        if (type.string == "0") {
            print("Like")
            self.likePhoto(JSON(self.photos[btn.tag])["id"].stringValue)
        } else if (type.string == "1") {
            print("Like")
            self.likePhoto(JSON(self.photos[btn.tag])["id"].stringValue)
        } else {
            print("Dislike")
            self.dislikePhoto(JSON(self.photos[btn.tag])["id"].stringValue)
        }
    }
    
    @IBAction func tappedAction2(_ sender: AnyObject) {
        let btn = sender as! UIButton
        let type = JSON(self.photos[btn.tag])["type"]
        if (type.string == "0") {
            print("Comment")
            let commentsVC = self.storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsViewController
            commentsVC.photo = self.photos[btn.tag] as! [String : AnyObject]
            self.navigationController?.pushViewController(commentsVC, animated: true)
        } else if (type.string == "1") {
            print("Dislike")
            self.dislikePhoto(JSON(self.photos[btn.tag])["id"].stringValue)
        } else {
            print("Comment")
            let commentsVC = self.storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsViewController
            commentsVC.photo = self.photos[btn.tag] as! [String : AnyObject]
            self.navigationController?.pushViewController(commentsVC, animated: true)
        }
    }
    
    @IBAction func tappedAction3(_ sender: AnyObject) {
        let btn = sender as! UIButton
        let type = JSON(self.photos[btn.tag])["type"]
        if (type.string == "1") {
            print("Comment")
            let commentsVC = self.storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsViewController
            commentsVC.photo = self.photos[btn.tag] as! [String : AnyObject]
            self.navigationController?.pushViewController(commentsVC, animated: true)
        }
    }
    
    @IBAction func tappedReportButton(_ sender: AnyObject) {
        
    }
    
    @IBAction func tappedViewAllCommentsButton(_ sender: AnyObject) {
        let btn = sender as! UIButton
        let commentsVC = self.storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsViewController
        commentsVC.photo = self.photos[btn.tag] as! [String : AnyObject]
        self.navigationController?.pushViewController(commentsVC, animated: true)
    }
    
    func likePhoto(_ photo_id:String) {
        let params = ["action":"like_photo", "user_id":User.myProfile.id, "photo_id":photo_id] as [String : Any];
        JHProgressHUD.sharedHUD.showInView(self.view, withHeader: nil, andFooter: nil)
        print("Params \(params)")
        Alamofire.request(.POST, api_endpoint, parameters:params).responseJSON { response in
            //print(response)
            JHProgressHUD.sharedHUD.hide()
            if let result = response.result.value {
                //print(result)
                if (JSON(result)["status"].stringValue == "success") {
                    self.getPhotos()
                }
            }
        }
    }
    
    func dislikePhoto(_ photo_id:String) {
        let params = ["action":"dislike_photo", "user_id":User.myProfile.id, "photo_id":photo_id] as [String : Any];
        JHProgressHUD.sharedHUD.showInView(self.view, withHeader: nil, andFooter: nil)
        print("Params \(params)")
        Alamofire.request(.POST, api_endpoint, parameters:params).responseJSON { response in
            //print(response)
            JHProgressHUD.sharedHUD.hide()
            if let result = response.result.value {
                //print(result)
                if (JSON(result)["status"].stringValue == "success") {
                    self.getPhotos()
                }
            }
        }
    }
}

