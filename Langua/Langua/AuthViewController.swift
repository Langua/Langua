//
//  AuthViewController.swift
//  Langua
//
//  Created by Steven Hurtado on 3/15/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class AuthViewController: UIViewController
{

    var ref: FIRDatabaseReference!
    var _refHandle: FIRDatabaseHandle!
    var _authHandle: FIRAuthStateDidChangeListenerHandle!
    
    var user: FIRUser?
    var displayName = "User"
    
    @IBOutlet weak var authBtn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureAuth()
        
        self.authBtn.setTitle("Authorizing...", for: .normal)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Util.didSignOutNotification), object: nil, queue: OperationQueue.main) { (Notification) in
            
            self.didSignOut()
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.user = nil
        configureAuth()
    }
    
    @IBAction func authButtonPressed(_ sender: Any)
    {
        loginSession()
    }

    deinit
    {
//        FIRAuth.auth()?.removeStateDidChangeListener(_authHandle)
//        self.ref.removeObserver(withHandle: self._refHandle)
    }
    
    func configureAuth()
    {
        let provider: [FUIAuthProvider] = [FUIGoogleAuth()]
        
        FUIAuth.defaultAuthUI()?.providers = provider
        
        _authHandle = FIRAuth.auth()?.addStateDidChangeListener({ (auth: FIRAuth, user: FIRUser?) in
            
            if let activeUser = user
            {
                if(self.user != activeUser)
                {
                    self.user = activeUser
                    
                    self.ref = FIRDatabase.database().reference()
                    
                    if(self.user?.uid != nil && self.user?.email != nil)
                    {
                        print(self.user?.uid)
                        
                        print(self.user?.email)
                        
                        self.ref.child("user").child((self.user?.uid)!).observeSingleEvent(of: .value, with: { (snap: FIRDataSnapshot) in

                            if(snap.hasChild("displayName"))
                            {
                                let currentDisplayName = snap.childSnapshot(forPath: "displayName").value
                                Util._currentDisplayName = currentDisplayName as? String
                                
                                if(Util._currentDisplayName == "")
                                {
                                    self.performSegue(withIdentifier: "authAddDisplaySegue", sender: self.user)
                                }
                                else
                                {
                                    self.ref.child("user").child((self.user?.uid)!).updateChildValues(["email" : self.user!.email!, "displayName" :currentDisplayName])
//                                    setValue(["email" : self.user?.email!, "displayName" : currentDisplayName])
                                    Util._currentUser = self.user
                                    self.performSegue(withIdentifier: "authSegue", sender: self.user)
                                }
                            }
                            else
                            {
                                self.ref.child("user").child((self.user?.uid)!).setValue(["email" : self.user?.email!, "displayName" : ""])
                                Util._currentUser = self.user
                                self.performSegue(withIdentifier: "authAddDisplaySegue", sender: self.user)
                            }
                        })
                    }
                }
            }
            else
            {
                self.loginSession()
            }
        })
    }
    
    func didSignOut()
    {
        do
        {
            try FIRAuth.auth()?.signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            let initialView = storyboard.instantiateInitialViewController()
            UIApplication.shared.keyWindow?.rootViewController = initialView

        }
        catch
        {
            print("Error: \(error)")
        }
    }
    
    func loginSession()
    {
        let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
        authViewController.navigationItem.leftBarButtonItem?.isEnabled = false
        present(authViewController, animated: true, completion: nil)
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
        if(segue.identifier == "authSegue" || segue.identifier == "authAddDisplaySegue")
        {
            let sendUser = sender as! FIRUser
            
            Util._currentUser = sendUser
        }
    }

}
