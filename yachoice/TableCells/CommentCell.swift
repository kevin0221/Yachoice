//
//  CommentCell.swift
//  yachoice
//
//  Created by Admin on 3/19/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet var imgAvatar: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblTimeAgo: UILabel!
    @IBOutlet var lblComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
