//
//  ChatCell.swift
//  Langua
//
//  Created by Steven Hurtado on 4/16/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell
{
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var chatView: UIView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 4.0, height: 8.0)
        
        self.layer.shadowRadius = 5
        self.layer.shouldRasterize = true
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
