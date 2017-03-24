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
        var i = 0
        
        self.ref.child("modules").child("courses").observe(.value) { (snap : FIRDataSnapshot) in
            let generalDict = snap.value as? [NSDictionary]
            
            self.ref.child("user").child((self.currentUser?.uid)!).observe(.value) { (usersnap: FIRDataSnapshot) in
                
                //infinite loop
                print(i)
                i += 1
                for dict in generalDict!
                {
                    
                    let currentLang = dict["language"] as? String
                    
                    if(usersnap.hasChild("modules"))
                    {
                        let modSnap = usersnap.childSnapshot(forPath: "modules")
                        
                        if(modSnap.hasChild("courses"))
                        {
                            let courseSnap = modSnap.childSnapshot(forPath: "courses")
                            let courseVal = courseSnap.value as? [NSDictionary]
                            
                            var exists = false
                            //using current language in iteration, determine whether language in course dictionary exists and whether user is mentor or learner;
                            
                            for lang in courseVal!
                            {
                                if(lang.object(forKey: "language") as! String == currentLang!)
                                {
                                    let snapLanguage = lang["language"]
                                    let mentValue = lang["mentor"]
                                    let learnValue = lang["learner"]
                                    
                                    print("\nLang: \(snapLanguage)")
                                    print("Mentor: \(mentValue)")
                                    print("Learner: \(learnValue)")
                                    
                                    self.langDict.append(lang)
                                    
                                    exists = true
                                    break
                                }
                            }
                            
                            if(!exists)
                            {
                                let failLang = ["language" : currentLang!, "mentor": "false", "learner" : "false"]
                                self.langDict.append(failLang as NSDictionary)
                                
                                //create ref to database and populate user's modules/courses/ language,mentor,learner
                                print((self.currentUser?.uid)!)
                                let childUpdates = ["/user/\((self.currentUser?.uid)!)/modules/courses": self.langDict]
                                self.ref.updateChildValues(childUpdates)
                            }
                            
                        }
                        else
                        {
                            //create courses for user
                            let failLang = ["language" : currentLang!, "mentor": "false", "learner" : "false"]
                            self.langDict.append(failLang as NSDictionary)
                            
                            print((self.currentUser?.uid)!)
                            let childUpdates = ["/user/\((self.currentUser?.uid)!)/modules/courses": self.langDict]
                            self.ref.updateChildValues(childUpdates)
//                            self.ref.child("user").child((self.currentUser?.uid)!).child("modules").child("courses").setValue(["language": currentLang!, "mentor":"false", "learner":"false"])
                        }
                    }
                    else
                    {
                        //create modules and courses for user
                        let failLang = ["language" : currentLang!, "mentor": "false", "learner" : "false"]
                        self.langDict.append(failLang as NSDictionary)
                        
                        print((self.currentUser?.uid)!)
                        let childUpdates = ["/user/\((self.currentUser?.uid)!)/modules/courses": self.langDict]
                        self.ref.updateChildValues(childUpdates)
//                        self.ref.child("user").child((self.currentUser?.uid)!).child("modules").child("courses").setValue(["language": currentLang!, "mentor":"false", "learner":"false"])
                    }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //number of courses
        return langDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict = self.langDict[indexPath.row]
        
        let identifier = dict["language"] as? String
        let mentorVal = dict["mentor"] as? String
        let learnerVal = dict["learner"] as? String
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier!, for: indexPath) as! CourseCell
        
        if(mentorVal == "true")
        {
            cell.mentorSwitch.isOn = true
        }
        else
        {
            cell.mentorSwitch.isOn = false
        }
        
        if(learnerVal == "true")
        {
            cell.learnerSwitch.isOn = true
        }
        else
        {
            cell.learnerSwitch.isOn = false
        }
        
        return cell
        
//        switch(indexPath.row)
//        {
//            case 0:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "japaneseCell", for: indexPath) as! CourseCell
//                
//                return cell
//            case 1:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "spanishCell", for: indexPath) as! CourseCell
//                
//                return cell
//            case 2:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "frenchCell", for: indexPath) as! CourseCell
//                
//                return cell
//            default:
//                let cell = CourseCell()
//                return cell
//        }
        
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
