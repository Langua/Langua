//
//  CatalogViewController.swift
//  Langua
//
//  Created by Steven Hurtado on 3/22/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Spring
import Firebase
import FirebaseAuthUI

class CatalogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var currentUser : FIRUser?
    
    var ref : FIRDatabaseReference!

    @IBOutlet weak var catalogImageView: UIImageView!
    
    @IBOutlet weak var allCoursesLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var langDict = [NSDictionary]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.currentUser = Util._currentUser
        
        self.ref = FIRDatabase.database().reference()
        
        configCourseLog()
        
        self.allCoursesLabel.layer.addBorder(edge: .bottom, color: UIColor.myDarkBambooGreen, thickness: 2)
        
        self.catalogImageView.image = UIImage(named: "Courses Filled-50")?.withRenderingMode(.alwaysTemplate)
    }
    
    func configCourseLog()
    {
        self.ref.child("modules").child("courses").observe(.value) { (snap : FIRDataSnapshot) in
            let generalDict = snap.value as? [NSDictionary]
            
            self.ref.child("user").child((self.currentUser?.uid)!).observe(.value) { (snap: FIRDataSnapshot) in
                
                if(snap.hasChild("modules"))
                {
                    let modSnap = snap.childSnapshot(forPath: "modules")
                    
                    for dict in generalDict!
                    {
                        if(modSnap.hasChild("courses"))
                        {
                            let courseSnap = modSnap.value(forKey: "courses") as? [NSDictionary]
                            
                            let currentLang = dict["language"]
                            
                            //using current language in iteration, determine whether language in course dictionary exists and whether user is mentor or learner;
                            //if learner/mentor , along with language, assign key value to true in langDict [NSDictionary]
                            //assign truth values to that languages switches in tableview cell
                            
//                            if(modSnap.hasChild("mentor"))
//                            {
//                                self.mentorLang = (modSnap.value(forKey: "mentor") as? [String: String])!
//                            }
//                            
//                            if(modSnap.hasChild("learner"))
//                            {
//                                self.mentorLang = (modSnap.value(forKey: "learner") as? [String: String])!
//                            }
                            
                        }
                        else
                        {
                            
                        }
                    }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //number of courses
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch(indexPath.row)
        {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "japaneseCell", for: indexPath) as! CourseCell
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "spanishCell", for: indexPath) as! CourseCell
                
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "frenchCell", for: indexPath) as! CourseCell
                
                return cell
            default:
                let cell = CourseCell()
                return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75
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
