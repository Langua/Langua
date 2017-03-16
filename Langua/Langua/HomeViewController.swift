//
//  HomeViewController.swift
//  Langua
//
//  Created by Steven Hurtado on 3/15/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func signOut(_ sender: Any)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Util.didSignOutNotification), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
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
