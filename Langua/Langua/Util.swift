//
//  Util.swift
//  Langua
//
//  Created by Steven Hurtado on 3/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseAuthUI

class Util
{
    static var didSignOutNotification = "didSignOutNotification"
    static var _currentUser : FIRUser?
    static var _currentDisplayName : String?
    
    static var _currentUserType : String?
    static var _currentCourseLanguage : String?
    
    static var didSnapCatalogNotification = "didSnapCatalogNotification"
    
    class func invokeAlertMethod(_ strTitle: NSString, strBody: NSString, delegate: AnyObject?)
    {
        let alert = UIAlertController(title: strTitle as String, message: strBody as String, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Okay", style: .default){ _ in}
        
        alert.addAction(action1)
        
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(alert, animated: true){}
    }
}

extension CALayer
{
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat)
    {
        
        let border = CALayer()
        
        switch edge
        {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}

extension UIColor
{
    //langua colors
    static var myMugiwaraYellow: UIColor
    {
        //E1CE7A
        return UIColor(red: 250.0/255.0, green: 123.0/255.0, blue: 84.0/255.0, alpha: 1)
    }

    static var myOuterSpaceBlack: UIColor
    {
        //424B54
        return UIColor(red: 66.0/255.0, green: 75.0/255.0, blue: 84.0/255.0, alpha: 1)
    }
    
    static var myLightBambooGreen: UIColor
    {
        //6BCF63
        return UIColor(red: 107.0/255.0, green: 207.0/255.0, blue: 99.0/255.0, alpha: 1)
    }
    
    static var myDarkBambooGreen: UIColor
    {
        //4C9347
        return UIColor(red: 76.0/255.0, green: 147.0/255.0, blue: 71.0/255.0, alpha: 1)
    }
    
    static var myIsabellineWhite: UIColor
    {
        //F6E8EA
        return UIColor(red: 246.0/255.0, green: 232.0/255.0, blue: 234.0/255.0, alpha: 1)
    }
    
    static var myCarminePink: UIColor
    {
        //EF626C
        return UIColor(red: 250.0/255.0, green: 123.0/255.0, blue: 84.0/255.0, alpha: 1)
    }
    
    //sg colors
    static var myCreamOrange: UIColor
    {
        //FA7B54
        return UIColor(red: 250.0/255.0, green: 123.0/255.0, blue: 84.0/255.0, alpha: 1)
    }
    
    static var myDullBlue: UIColor
    {
        //5B7FA4
        return UIColor(red: 91.0/255.0, green: 127.0/255.0, blue: 164.0/255.0, alpha: 1)
    }
    
    static var groupTableViewCell: UIColor
    {
        //EBEBF1
        return UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 241.0/255.0, alpha: 1)
    }
    
    
    //other colors
    static var myOffWhite: UIColor
    {
        //FAFAFA
        return UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1)
    }
    
    static var mySalmonRed: UIColor
    {
        //F55D3E
        return UIColor(red: 245.0/255.0, green: 93.0/255.0, blue: 62.0/255.0, alpha: 1)
    }
    
    static var myRoseMadder: UIColor
    {
        //D72638
        return UIColor(red: 215.0/255.0, green: 38.0/255.0, blue: 56.0/255.0, alpha: 1)
    }
    
    static var myOnyxGray: UIColor
    {
        //878E88
        return UIColor(red: 135.0/255.0, green: 142.0/255.0, blue: 136.0/255.0, alpha: 1)
    }
    
    static var myTimberWolf: UIColor
    {
        //DAD6D6
        return UIColor(red: 218.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1)
    }
    
    
    static var myMatteGold: UIColor
    {
        //F7CB15
        return UIColor(red: 247.0/255.0, green: 203.0/255.0, blue: 21.0/255.0, alpha: 1)
    }
    
    static var twitterBlue: UIColor
    {
        //00aced
        return UIColor(red: 0.0/255.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1)
    }
}
