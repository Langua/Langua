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

class CourseHomeViewController: UIViewController
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
    
    var courseName = String()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.courseNameLabel.layer.addBorder(edge: .bottom, color: .myDarkBambooGreen, thickness: 2)
        self.courseNameLabel.text = self.courseName
        
        self.initializeBtnAnimation()
        self.configDatabase()
    }
    
    func configDatabase()
    {
        
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
