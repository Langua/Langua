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
    
    var langDict = [NSMutableDictionary]()
    var generalDict = [NSMutableDictionary]()
    var courseVal = [NSMutableDictionary]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.currentUser = Util._currentUser
        
        self.ref = FIRDatabase.database().reference()
        
        configCourseLog()
        
        self.allCoursesLabel.layer.addBorder(edge: .bottom, color: UIColor.myDarkBambooGreen, thickness: 2)
        
        self.catalogImageView.image = UIImage(named: "Courses Filled-50")?.withRenderingMode(.alwaysTemplate)
    }
    
    func configDatabase()
    {
        print("Gen Dict \(generalDict.count)")
        for dict in generalDict
        {
            let currentLang = dict["language"] as? String
            var exists = false
            
            //using current language in iteration, determine whether language in course dictionary exists and whether user is mentor or learner;
            for lang in courseVal
            {
                if(lang.object(forKey: "language") as! String == currentLang!)
                {
                    self.langDict.append(lang)
                    exists = true
                    break
                }
            }
            
            if(!exists)
            {
                let failLang = ["language" : currentLang!, "mentor": "false", "learner" : "false"]
                self.langDict.append(failLang as! NSMutableDictionary)
            }
        }
        self.tableView.reloadData()
        
        //create ref to database and populate user's modules/courses/ language,mentor,learner
        
        print((self.currentUser?.uid)!)

        let childUpdates = ["/user/\((currentUser?.uid)!)/modules/courses": self.langDict]
        self.ref.updateChildValues(childUpdates)
        print(self.langDict.count)
    }
    
    func configCourseLog()
    {
        FIRAuth.auth()?.addStateDidChangeListener { (auth: FIRAuth, user: FIRUser?) in
            
//            let childUpdates = ["/user/\((user?.uid)!)/modules/courses": ["This" : "works"]]
//            self.ref.updateChildValues(childUpdates)
//        }
        
//        let childUpdates = ["modules": ["courses": self.langDict]]
//        
//        ref.child("user").child((self.currentUser?.uid)!).setValue(childUpdates)

//
            self.langDict.removeAll(keepingCapacity: false)
            
            self.ref.child("modules").child("courses").observeSingleEvent(of: .value) { (snap : FIRDataSnapshot) in
                 self.generalDict = (snap.value as? [NSMutableDictionary])!
                
                self.ref.child("user").child((self.currentUser?.uid)!).observeSingleEvent(of: .value) { (usersnap: FIRDataSnapshot) in
                    
                    if(usersnap.hasChild("modules"))
                    {
                        let modSnap = usersnap.childSnapshot(forPath: "modules")
                        
                        if(modSnap.hasChild("courses"))
                        {
                            let courseSnap = modSnap.childSnapshot(forPath: "courses")
                            self.courseVal = (courseSnap.value as? [NSMutableDictionary])!
                        }
                    }
                    
                    self.configDatabase()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(identifier!)Cell", for: indexPath) as! CourseCell
        
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
        
        
        switch(identifier!)
        {
            case "japanese":
                cell.flagImageView.image = UIImage(named:"Japan-48")?.withRenderingMode(.alwaysOriginal)
                break;
            case "french":
                cell.flagImageView.image = UIImage(named:"France-48")?.withRenderingMode(.alwaysOriginal)
                break;
            case "spanish":
                cell.flagImageView.image = UIImage(named:"Spain-48")?.withRenderingMode(.alwaysOriginal)
                break;
            default:
                break;
        }
        
        cell.mentorSwitch.indexPath = indexPath
        cell.mentorSwitch.addTarget(self, action: #selector(addMentorCourse(_:)), for: .touchUpInside)
        
        cell.learnerSwitch.indexPath = indexPath
        cell.learnerSwitch.addTarget(self, action: #selector(addLearnerCourse(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func addMentorCourse(_ sender: Any?)
    {
        let mentorSwitch = sender as! CustomSwitch
        let row = mentorSwitch.indexPath.row
        
        print(mentorSwitch.isOn ? "true":"false")
        self.langDict[row]["mentor"] = (mentorSwitch.isOn ? "true":"false")
        
        self.ref = FIRDatabase.database().reference()
        let childUpdates = ["/user/\((currentUser?.uid)!)/modules/courses": self.langDict]
        self.ref.updateChildValues(childUpdates)
        
        if(mentorSwitch.isOn)
        {
            let setMent : NSDictionary = ["online": "1", "mentorname" : (currentUser?.displayName)!]
            
            let mentorUpdate = ["/modules/courses/\(row)/mentors/\((currentUser?.uid)!)" : setMent]
            self.ref.updateChildValues(mentorUpdate)
        }
        else
        {
            //remove
            ref.child("modules").child("courses").child("\(row)").child("mentors").child((currentUser?.uid)!).removeValue()
        }
    }
    
    func addLearnerCourse(_ sender: Any?)
    {
        let learnerSwitch = sender as! CustomSwitch
        let row = learnerSwitch.indexPath.row
        
        print(learnerSwitch.isOn ? "true":"false")
        self.langDict[row]["learner"] = (learnerSwitch.isOn ? "true":"false")
        
        self.ref = FIRDatabase.database().reference()
        let childUpdates = ["/user/\((currentUser?.uid)!)/modules/courses": self.langDict]
        self.ref.updateChildValues(childUpdates)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath) as! CourseCell
        cell.selectionStyle = .none
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
