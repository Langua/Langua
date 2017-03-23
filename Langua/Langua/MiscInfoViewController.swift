//
//  MiscInfoViewController.swift
//  Langua
//
//  Created by Steven Hurtado on 3/21/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MiscInfoViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    var origPos : CGFloat = 0.0
    var ref : FIRDatabaseReference!
    var currentUser : FIRUser?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.origPos = self.view.frame.origin.y

        self.displayView.layer.cornerRadius = 10
        
        self.currentUser = Util._currentUser
        // Do any additional setup after loading the view.
    }

    @IBAction func doneBtnPressed(_ sender: Any)
    {
        if(self.displayNameTextField.text == "")
        {
            Util.invokeAlertMethod("Error", strBody: "Please input a display name.", delegate: nil)
        }
        else
        {
            self.ref = FIRDatabase.database().reference()
            self.ref?.child("user").child((self.currentUser?.uid)!).setValue(["email" : self.currentUser?.email!, "displayName" : self.displayNameTextField.text!])
            
            Util._currentDisplayName = self.displayNameTextField.text!
            
            self.performSegue(withIdentifier: "displayNameSegue", sender: self)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        UIView.animate(withDuration: 0.7)
        {
            self.view.frame.origin.y = self.origPos - self.view.frame.height/4
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        UIView.animate(withDuration: 0.3)
        {
            self.view.frame.origin.y = self.origPos
        }
        
        self.view.endEditing(true)
        self.resignFirstResponder()
        
        return true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
