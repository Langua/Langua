//
//  menuViewCell.swift
//  Langua
//
//  Created by Steven Hurtado on 3/13/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class menuViewCell: UITableViewCell
{

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var viewName: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
