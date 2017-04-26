//
//  AnswerChoiceCell.swift
//  Langua
//
//  Created by Steven Hurtado on 4/22/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class AnswerChoiceCell: UICollectionViewCell
{
    
    @IBOutlet weak var choiceLabel: UILabel!
    
    @IBOutlet weak var choiceView: UIView!
    
    var toggled : Bool = false
    
    var origin : CGPoint = CGPoint.zero
}
