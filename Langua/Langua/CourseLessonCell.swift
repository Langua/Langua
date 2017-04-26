//
//  CourseLessonCell.swift
//  Langua
//
//  Created by Steven Hurtado on 4/3/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class CustomTap : UITapGestureRecognizer
{
    var indexPath : IndexPath?
}

class CourseLessonCell: UITableViewCell
{

    @IBOutlet weak var lessonBtn: UIButton!
    
    @IBOutlet weak var lessonLabel: UILabel!
    
    var customTap : CustomTap?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
