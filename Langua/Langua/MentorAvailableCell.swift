//
//  MentorAvailableCell.swift
//  Langua
//
//  Created by Steven Hurtado on 4/18/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class MentorAvailableCell: UITableViewCell
{
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib()
    {
        self.notificationView.layer.cornerRadius = self.notificationView.frame.width/2
        self.notificationView.isHidden = true
        
        super.awakeFromNib()
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width/2
        
        self.userLabel.text = "Langu DaPanda"
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
