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
        FIRAuth.auth()?.removeStateDidChangeListener(_authHandle)
    }
    
    func configureAuth()
    {
        let provider: [FUIAuthProvider] = [FUIGoogleAuth()]
        
        FUIAuth.defaultAuthUI()?.providers = provider
        
        _authHandle = FIRAuth.auth()?.addStateDidChangeListener({ (auth: FIRAuth, user: FIRUser?) in
            
            self.authBtn.setTitle("Authorizing...", for: .normal)
            
            if let activeUser = user
            {
                if(self.user != activeUser)
                {
                    self.user = activeUser
                    
                    self.displayName = (self.user?.displayName!)!
                    
                    self.performSegue(withIdentifier: "authSegue", sender: self)
                }
            }
            else
            {
                
                self.authBtn.setTitle("Authorize", for: .normal)
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
        present(authViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
