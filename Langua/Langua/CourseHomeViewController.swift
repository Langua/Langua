//
//  CourseHomeViewController.swift
//  Langua
//
//  Created by Steven Hurtado on 3/26/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import Spring

class CourseHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate
{
    @IBOutlet weak var languTeachBtn: SpringButton!
    
    @IBOutlet weak var chatBtn: SpringButton!
    var chatStart = CGPoint()
    @IBOutlet weak var chatLabel: UILabel!
    
    @IBOutlet weak var discussionBtn: SpringButton!
    var discussStart = CGPoint()
    @IBOutlet weak var discussionLabel: UILabel!
    
    @IBOutlet weak var dictionaryBtn: SpringButton!
    var dictStart = CGPoint()
    @IBOutlet weak var dictionaryLabel: UILabel!
    
    @IBOutlet weak var automationBtn: SpringButton!
    var autoStart = CGPoint()
    @IBOutlet weak var autoLabel: UILabel!
    
    @IBOutlet weak var courseNameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var courseName = String()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.courseNameLabel.layer.addBorder(edge: .bottom, color: .myDarkBambooGreen, thickness: 2)
        self.courseName = Util._currentCourseLanguage!
        self.courseNameLabel.text = self.courseName
        
        self.chatLabel.text = (Util._currentUserType == "Mentor") ? "Chat with a Learner!" : "Chat with a Mentor!"
        
        self.initializeBtnAnimation()
        self.configDatabase()
    }
    
    func configDatabase()
    {
        //call for course list of user with passed indexpath
        // TODO: - Unique Courses
            //not each course will have the same type of lessons
            //this is open for implementation later
    }
    
    func initializeBtnAnimation()
    {
        self.languTeachBtn.layer.cornerRadius = self.languTeachBtn.frame.width/2
        self.languTeachBtn.clipsToBounds = true
        
        self.chatBtn.layer.cornerRadius = self.chatBtn.frame.width/2
        self.chatBtn.clipsToBounds = true
        self.chatStart = self.chatBtn.frame.origin
        
        self.discussionBtn.layer.cornerRadius = self.discussionBtn.frame.width/2
        self.discussionBtn.clipsToBounds = true
        self.discussStart = self.discussionBtn.frame.origin
        
        self.dictionaryBtn.layer.cornerRadius = self.dictionaryBtn.frame.width/2
        self.dictionaryBtn.clipsToBounds = true
        self.dictStart = self.dictionaryBtn.frame.origin
        
        self.automationBtn.layer.cornerRadius = self.automationBtn.frame.width/2
        self.automationBtn.clipsToBounds = true
        self.autoStart = self.automationBtn.frame.origin
        
        self.chatBtn.frame.origin = self.languTeachBtn.frame.origin
        self.discussionBtn.frame.origin = self.languTeachBtn.frame.origin
        self.dictionaryBtn.frame.origin = self.languTeachBtn.frame.origin
        self.automationBtn.frame.origin = self.languTeachBtn.frame.origin
        
        self.chatBtn.alpha = 0
        self.discussionBtn.alpha = 0
        self.dictionaryBtn.alpha = 0
        self.automationBtn.alpha = 0
        
        self.chatLabel.alpha = 0
        self.discussionLabel.alpha = 0
        self.dictionaryLabel.alpha = 0
        self.autoLabel.alpha = 0
    }

    func toggleBtns()
    {
        if(self.chatBtn.alpha == 0)
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.chatBtn.alpha = 1
                self.discussionBtn.alpha = 1
                self.dictionaryBtn.alpha = 1
                self.automationBtn.alpha = 1
                
                self.chatLabel.alpha = 1
                self.discussionLabel.alpha = 1
                self.dictionaryLabel.alpha = 1
                self.autoLabel.alpha = 1
                
                self.chatBtn.frame.origin = self.chatStart
                self.discussionBtn.frame.origin = self.self.discussStart
                self.dictionaryBtn.frame.origin = self.self.dictStart
                self.automationBtn.frame.origin = self.autoStart
            })
        }
        else
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.chatBtn.alpha = 0
                self.discussionBtn.alpha = 0
                self.dictionaryBtn.alpha = 0
                self.automationBtn.alpha = 0
                
                self.chatLabel.alpha = 0
                self.discussionLabel.alpha = 0
                self.dictionaryLabel.alpha = 0
                self.autoLabel.alpha = 0
                
                self.chatBtn.frame.origin = self.languTeachBtn.frame.origin
                self.discussionBtn.frame.origin = self.languTeachBtn.frame.origin
                self.dictionaryBtn.frame.origin = self.languTeachBtn.frame.origin
                self.automationBtn.frame.origin = self.languTeachBtn.frame.origin
            })

        }
    }
    
    @IBAction func languPressed(_ sender: Any)
    {
        self.languTeachBtn.animation = "wobble"
        self.languTeachBtn.duration = 0.7
        self.languTeachBtn.curve = "easeOutQuart"
        self.languTeachBtn.animate()
        
        self.toggleBtns()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseLessonCell", for: indexPath) as! CourseLessonCell
        
        cell.lessonBtn.layer.cornerRadius = cell.lessonBtn.frame.width/2
        
        switch(indexPath.row)
        {
            case 0:
                cell.lessonLabel.text = "For Beginners"
                cell.lessonBtn.setImage(UIImage(named: "Baby Bottle Filled-50"), for: .normal)
                break
            case 1:
                cell.lessonLabel.text = "Common Phrases"
                cell.lessonBtn.setImage(UIImage(named: "Talk Male Filled-50"), for: .normal)
                break
            case 2:
                cell.lessonLabel.text = "Verbs"
                cell.lessonBtn.setImage(UIImage(named: "Action Filled-50"), for: .normal)
                break
            default:
                cell.lessonLabel.text = "Tenses"
                cell.lessonBtn.setImage(UIImage(named: "Tenses Filled-50"), for: .normal)
                break
        }
        
        cell.customTap = CustomTap(target: self, action: #selector(btnSelected(_:)))
        
        cell.customTap?.indexPath = indexPath
        
        cell.lessonBtn.addGestureRecognizer(cell.customTap!)
        
        return cell
    }
    
    func btnSelected(_ sender: CustomTap)
    {
        self.tableView(self.tableView, didSelectRowAt: sender.indexPath!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Selected")
        self.performSegue(withIdentifier: "lessonSegue", sender: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let visibleCells = tableView.visibleCells
        
        if visibleCells.count == 0 {
            return
        }
        
        guard let bottomCell = visibleCells.last else {
            return
        }
        
        guard let topCell = visibleCells.first else {
            return
        }
        
        for cell in visibleCells {
            cell.contentView.alpha = 1.0
        }
        
        let cellHeight = topCell.frame.size.height - 1
        let tableViewTopPosition = tableView.frame.origin.y
        let tableViewBottomPosition = tableView.frame.origin.y + tableView.frame.size.height
        
        let topCellPositionInTableView = tableView.rectForRow(at: tableView.indexPath(for: topCell)!)
        let bottomCellPositionInTableView = tableView.rectForRow(at: tableView.indexPath(for: bottomCell)!)
        let topCellPosition = tableView.convert(topCellPositionInTableView, to: tableView.superview).origin.y
        let bottomCellPosition = tableView.convert(bottomCellPositionInTableView, to: tableView.superview).origin.y + cellHeight
        
        let modifier: CGFloat = 2.5
        let topCellOpacity = 1.0 - ((tableViewTopPosition - topCellPosition) / cellHeight) * modifier
        let bottomCellOpacity = 1.0 - ((bottomCellPosition - tableViewBottomPosition) / cellHeight) * modifier
        
        topCell.contentView.alpha = topCellOpacity
        bottomCell.contentView.alpha = bottomCellOpacity
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
        if(segue.identifier == "lessonSegue")
        {
            switch(Util._currentCourseLanguage!)
            {
            case "Spanish":
                print("Spanish")
            default:
                let vc = segue.destination as! SpanishCourseViewController
                
                vc.currentLesson = sender as! Int
                break
            }
        }
    }

}
