//
//  MentorAvailableTableViewController.swift
//  Langua
//
//  Created by Steven Hurtado on 4/18/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Firebase

class MentorAvailableTableViewController: UITableViewController
{
    var inboxArr : [FIRDataSnapshot] = []
    var ref : FIRDatabaseReference!
    var currentRow = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if(Util._currentUserType == "Learner")
        {
            self.title = "Mentors"
        }
        else
        {
            self.title = "Learners"
        }
        
        self.assignRow()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        
        self.configureAuth()
    }
    
    func assignRow()
    {
        switch(Util._currentCourseLanguage!)
        {
        case "Japanese":
            currentRow = 0
            break
        case "French":
            currentRow = 1
            break
        case "Spanish":
            currentRow = 2
            break
        default:
            break
        }
    }
    
    func configureAuth()
    {
        FIRAuth.auth()?.addStateDidChangeListener { (auth: FIRAuth, user: FIRUser?) in
            //call reference to database
            self.ref = FIRDatabase.database().reference()
            
            // refresh table data
            self.inboxArr.removeAll(keepingCapacity: false)
            self.tableView.reloadData()
            
            self.configureDB()
        }
    }
    
    func configureDB()
    {
        if(Util._currentUserType == "Learner")
        {
            ref.child("modules").child("courses").child("\(self.currentRow)").child("mentors").observe(.childAdded) { (snapshot: FIRDataSnapshot)in
                if(Util._currentUserType == "Learner")
                {
                    self.inboxArr.append(snapshot)
                    self.tableView.insertRows(at: [IndexPath(row: self.inboxArr.count-1, section: 0)], with: .automatic)
                }
            }
            
            ref.child("modules").child("courses").child("\(self.currentRow)").child("mentors").observe(.childChanged) { (snapshot: FIRDataSnapshot) in
                if(Util._currentUserType == "Learner")
                {
                    for i in (0...(self.inboxArr.count-1))
                    {
                        self.inboxArr[i] = snapshot
                    }
                }
            }
        }
        else
        {
            ref.child("modules").child("courses").child("\(self.currentRow)").child("mentors").child("\((Util._currentUser?.uid)!)").child("inbox").observe(.childAdded) { (snapshot: FIRDataSnapshot)in
                if(Util._currentUserType == "Mentor")
                {
                    self.inboxArr.append(snapshot)
                    self.tableView.insertRows(at: [IndexPath(row: self.inboxArr.count-1, section: 0)], with: .automatic)
                }
            }
            
            ref.child("modules").child("courses").child("\(self.currentRow)").child("mentors").child("\((Util._currentUser?.uid)!)").child("inbox").observe(.childChanged) { (snapshot: FIRDataSnapshot) in
                if(Util._currentUserType == "Mentor")
                {
                    for i in (0...(self.inboxArr.count-1))
                    {
                        self.inboxArr[i] = snapshot
                    }
                }
            }

        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return self.inboxArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mentorAvailableCell", for: indexPath) as! MentorAvailableCell

        let snap = inboxArr[indexPath.row]
        let key = snap.key
        let val = snap.value as! NSDictionary
        
        self.ref = FIRDatabase.database().reference()
        
        var name = ""
        
        if(Util._currentUserType == "Learner")
        {
            name = val["mentorname"] as! String
        }
        else
        {
            name = val["learnername"] as! String
        }
        
        self.ref.child("user").child("\(key)").observe(.value, with: { (userSnap: FIRDataSnapshot) in
            
            let userVal = userSnap.value as! NSDictionary
            
            let online = userVal["online"] as! Bool
            
            if(online)
            {
                cell.avatarImageView.layer.borderColor = UIColor.myLightBambooGreen.cgColor
                cell.statusLabel.text = "Online"
                cell.statusLabel.textColor = UIColor.myLightBambooGreen
            }
            else
            {
                cell.avatarImageView.layer.borderColor = UIColor.myOuterSpaceBlack.cgColor
                cell.statusLabel.text = "Offline"
                cell.statusLabel.textColor = UIColor.myOuterSpaceBlack
            }
            
            cell.userLabel.text = name
        })
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        
        self.performSegue(withIdentifier: "chatSegue", sender: indexPath)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "chatSegue")
        {
            let indexPath = sender as! IndexPath
            
            let snap = self.inboxArr[indexPath.row]
            
            let dest = segue.destination as! ChatViewController
            
            dest.snap = snap
            dest.currentRow = currentRow
        }
    }
}
