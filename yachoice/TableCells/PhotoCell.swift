//
//  PhotoCell.swift
//  yachoice
//
//  Created by Admin on 2/23/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var lblTimeAgo: UILabel!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet var lblComment: UILabel!
    @IBOutlet var actionButton1: UIButton!
    @IBOutlet var actionButton2: UIButton!
    @IBOutlet var actionButton3: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet var imgStat1: UIImageView!
    @IBOutlet var lblStat1: UILabel!
    @IBOutlet var imgStat2: UIImageView!
    @IBOutlet var lblStat2: UILabel!
    
    @IBOutlet weak var lblComment1: UILabel!
    @IBOutlet weak var lblComment2: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
