//
//  HomeViewController.swift
//  Langua
//
//  Created by Steven Hurtado on 3/15/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Spring
import Firebase
import FirebaseAuthUI

class HomeViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var languBtn: SpringButton!

    var currentUser : FIRUser?
    
    var ref : FIRDatabaseReference!
    
    @IBOutlet weak var languAvatar: UIImageView!
    
    @IBOutlet weak var uploadBtn: UIButton!
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBOutlet weak var mentorLevelLabel: UILabel!
    
    @IBOutlet weak var learnerLevelLabel: UILabel!
    
    @IBOutlet weak var trophiesLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.currentUser = Util._currentUser
        
//        self.ref = FIRDatabase.database().reference()
        
        self.displayNameTextField.text = Util._currentDisplayName

        self.mentorLevelLabel.layer.addBorder(edge: .bottom, color: UIColor.myOuterSpaceBlack, thickness: 2)
        
        self.learnerLevelLabel.layer.addBorder(edge: .bottom, color: UIColor.myOuterSpaceBlack, thickness: 2)
        
        self.trophiesLabel.layer.addBorder(edge: .bottom, color: UIColor.myOuterSpaceBlack, thickness: 2)
        
        self.languBtn.layer.cornerRadius = self.languBtn.frame.width/2
        self.languBtn.clipsToBounds = true
        
        self.languAvatar.layer.cornerRadius = self.languAvatar.frame.width/2
        self.languAvatar.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func languPressed(_ sender: Any)
    {
        print((currentUser?.email!)!)
        print((currentUser?.uid)!)
        
        self.languBtn.animation = "wobble"
        self.languBtn.duration = 0.7
        self.languBtn.curve = "easeOutQuart"
        self.languBtn.animate()
    }
    
    @IBAction func signOut(_ sender: Any)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Util.didSignOutNotification), object: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
