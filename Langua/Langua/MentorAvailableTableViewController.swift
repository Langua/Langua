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
    var mentorArr : [FIRDataSnapshot] = []
    var ref : FIRDatabaseReference!
    var currentRow = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.assignRow()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        
        self.configureAuth()
    }
    
    func assignRow()
    {
        switch(Util._currentCourseLanguage!)
        {
        case "japanese":
            currentRow = 0
            break
        case "french":
            currentRow = 1
            break
        case "spanish":
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
            self.mentorArr.removeAll(keepingCapacity: false)
            self.tableView.reloadData()
            
            self.configureDB()
        }
    }
    
    func configureDB()
    {
//        let mentorUpdate = ["/modules/courses/\(row)/mentors/\((currentUser?.uid)!)" : setMent]
        
        ref.child("modules").child("courses").child("\(self.currentRow)").child("mentors").observe(.childAdded) { (snapshot: FIRDataSnapshot)in
            self.mentorArr.append(snapshot)
            self.tableView.insertRows(at: [IndexPath(row: self.mentorArr.count-1, section: 0)], with: .automatic)
        }
        
        ref.child("modules").child("courses").child("\(self.currentRow)").child("mentors").observe(.childChanged) { (snapshot: FIRDataSnapshot) in
            
            for i in (0...(self.mentorArr.count-1))
            {
                self.mentorArr[i] = snapshot
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
        return self.mentorArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mentorAvailableCell", for: indexPath) as! MentorAvailableCell

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
