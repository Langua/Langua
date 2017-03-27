//
//  CourseCell.swift
//  Langua
//
//  Created by Steven Hurtado on 3/22/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class CustomSwitch: UISwitch
{
    var indexPath : IndexPath = IndexPath()
}

class CourseCell: UITableViewCell
{

    @IBOutlet weak var flagImageView: UIImageView!
    
    @IBOutlet weak var mentorSwitch: CustomSwitch!
    
    @IBOutlet weak var learnerSwitch: CustomSwitch!
    
    var indexPath : IndexPath = IndexPath()
    
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
