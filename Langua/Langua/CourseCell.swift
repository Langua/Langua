//
//  CourseCell.swift
//  Langua
//
//  Created by Steven Hurtado on 3/22/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell
{

    @IBOutlet weak var flagImageView: UIImageView!
    
    @IBOutlet weak var mentorSwitch: UISwitch!
    
    @IBOutlet weak var learnerSwitch: UISwitch!
    
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
