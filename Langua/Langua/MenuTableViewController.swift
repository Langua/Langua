//
//  MenuTableViewController.swift
//  Langua
//
//  Created by Steven Hurtado on 3/13/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class MenuTableViewController: UITableViewController
{
    let segues = ["embedInitialCenterController", "embedInitialCenterController", "embedInitialCenterController", "embedCoursesCenterController", "embedInitialCenterController"]
    
    var ref : FIRDatabaseReference!
    var user : FIRUser?
    
    var mentorLang = [String : String]()
    var learnerLang = [String : String]()
    
    private var previousIndex: NSIndexPath?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.user = Util._currentUser
        
        self.ref = FIRDatabase.database().reference()
        
        setUpLanguages()

        let backgroundImage = UIImage(named: "bamboo-1x")
        
        let imgView = UIImageView(image: backgroundImage)
        
        imgView.contentMode = .scaleAspectFill
        
        self.tableView.backgroundView = imgView
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func setUpLanguages()
    {
        self.ref.child("user").child((self.user?.uid)!).observe(.value) { (snap: FIRDataSnapshot) in
            if(snap.hasChild("modules"))
            {
                let modSnap = snap.childSnapshot(forPath: "modules")
                
                if(modSnap.hasChild("mentor"))
                {
                    self.mentorLang = (modSnap.value(forKey: "mentor") as? [String: String])!
                }
                
                if(modSnap.hasChild("learner"))
                {
                    self.mentorLang = (modSnap.value(forKey: "learner") as? [String: String])!
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        
        //if both mentor and learner then 2 else 1
        
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch(section)
        {
            case 1:
                return self.mentorLang.count
            case 2:
                return self.learnerLang.count
            default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.section == 0 || indexPath.section == 3 || indexPath.section == 4)
        {
            return 60
        }
        
        return 42
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.selectionStyle = .none
        
        if let index = previousIndex
        {
            print("Deselect : \(segues[indexPath.section])")
            tableView.deselectRow(at: index as IndexPath, animated: true)
        }
        
        print("Perform : \(segues[indexPath.section])")
        sideMenuController?.performSegue(withIdentifier: segues[indexPath.section], sender: nil)
        previousIndex = indexPath as NSIndexPath?
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cell = menuViewCell()
        
        
        switch(indexPath.section)
        {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! menuViewCell
                cell.imgView.image = UIImage(named: "School Filled-50")?.withRenderingMode(.alwaysTemplate)
            case 1:
    //            cell.viewName.text = "Home"
                
                let lang = mentorLang["language"]
                
                if(lang == "spanish")
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "languageCell") as! menuViewCell
                    let viewImg = (UIImage(named: "Spain-48")?.withRenderingMode(.alwaysOriginal))!
                    cell.imgView.image = viewImg
                    cell.viewName.text = "Spanish"
                }
                else if(lang == "japanese")
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "languageCell") as! menuViewCell
                    let viewImg = (UIImage(named: "Japan-48")?.withRenderingMode(.alwaysOriginal))!
                    cell.imgView.image = viewImg
                    cell.viewName.text = "Japanese"
                }
                else if(lang == "french")
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "languageCell") as! menuViewCell
                    let viewImg = (UIImage(named: "France-48")?.withRenderingMode(.alwaysOriginal))!
                    cell.imgView.image = viewImg
                    cell.viewName.text = "French"
                }
    
                break;
            case 2:
                let lang = learnerLang["language"]
                
                if(lang == "spanish")
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "languageCell") as! menuViewCell
                    let viewImg = (UIImage(named: "Spain-48")?.withRenderingMode(.alwaysOriginal))!
                    cell.imgView.image = viewImg
                    cell.viewName.text = "Spanish"
                }
                else if(lang == "japanese")
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "languageCell") as! menuViewCell
                    let viewImg = (UIImage(named: "Japan-48")?.withRenderingMode(.alwaysOriginal))!
                    cell.imgView.image = viewImg
                    cell.viewName.text = "Japanese"
                }
                else if(lang == "french")
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "languageCell") as! menuViewCell
                    let viewImg = (UIImage(named: "France-48")?.withRenderingMode(.alwaysOriginal))!
                    cell.imgView.image = viewImg
                    cell.viewName.text = "French"
                }
                
                break;
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: "catalogCell") as! menuViewCell
                let viewImg = (UIImage(named: "Courses Filled-50")?.withRenderingMode(.alwaysTemplate))!
                cell.imgView.image = viewImg
                break;
            case 4:
                cell = tableView.dequeueReusableCell(withIdentifier: "signOutCell") as! menuViewCell
                let viewImg = (UIImage(named: "Exit Filled-50")?.withRenderingMode(.alwaysTemplate))!
                cell.imgView.image = viewImg
                break;
            default:
                break;
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if(section != 1 && section != 2)
        {
            return 0
        }
        
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        switch(section)
        {
            case 1:
                //if mentor array count > 0
                let header = tableView.dequeueReusableCell(withIdentifier: "mentorCell") as! menuViewCell
                header.imgView.image = UIImage(named: "Guru Filled-50")?.withRenderingMode(.alwaysTemplate)
                return header
            case 2:
                let header = tableView.dequeueReusableCell(withIdentifier: "learnerCell") as! menuViewCell
                header.imgView.image = UIImage(named: "Student Female Filled-50")?.withRenderingMode(.alwaysTemplate)
                return header
            default:
                return nil
            
        }
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
