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
    var generalDict = [NSDictionary]()
    var courseVal = [NSDictionary]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.currentUser = Util._currentUser
        
        self.ref = FIRDatabase.database().reference()
//        
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Util.didSnapCatalogNotification), object: nil, queue: OperationQueue.main) { (Notification) in
//            
//            self.didSnap()
//        }

        
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
            }
        }
        self.tableView.reloadData()
        
        //create ref to database and populate user's modules/courses/ language,mentor,learner
        
        print((self.currentUser?.uid)!)
//        let childUpdates = ["/modules/courses": self.langDict]
        
//        ref.child("user").child((self.currentUser?.uid)!).setValue(childUpdates)
        let childUpdates = ["/user/\((currentUser?.uid)!)/modules/courses": self.langDict]
        self.ref.updateChildValues(childUpdates)

        
//        self.ref.updateChildValues(childUpdates)
        print(self.langDict.count)
        
        
        for dict in self.langDict
        {
            print("DICT")
            let snapLanguage = dict["language"]
            let mentValue = dict["mentor"]
            let learnValue = dict["learner"]
            
            print("\nLang: \(snapLanguage)")
            print("Mentor: \(mentValue)")
            print("Learner: \(learnValue)")
            
        }

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
                 self.generalDict = (snap.value as? [NSDictionary])!
                
                self.ref.child("user").child((self.currentUser?.uid)!).observeSingleEvent(of: .value) { (usersnap: FIRDataSnapshot) in
                    
                    if(usersnap.hasChild("modules"))
                    {
                        let modSnap = usersnap.childSnapshot(forPath: "modules")
                        
                        if(modSnap.hasChild("courses"))
                        {
                            let courseSnap = modSnap.childSnapshot(forPath: "courses")
                            self.courseVal = (courseSnap.value as? [NSDictionary])!
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
        self.langDict[row].setValue((mentorSwitch.isOn ? "true":"false"), forKey: "mentor")
        
        self.ref = FIRDatabase.database().reference()
        let childUpdates = ["/user/\((currentUser?.uid)!)/modules/courses": self.langDict]
        self.ref.updateChildValues(childUpdates)
    }
    
    func addLearnerCourse(_ sender: Any?)
    {
        let learnerSwitch = sender as! CustomSwitch
        let row = learnerSwitch.indexPath.row
        
        print(learnerSwitch.isOn ? "true":"false")
        self.langDict[row].setValue((learnerSwitch.isOn ? "true":"false"), forKey: "learner")
        
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
