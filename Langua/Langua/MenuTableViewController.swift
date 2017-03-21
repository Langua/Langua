//
//  MenuTableViewController.swift
//  Langua
//
//  Created by Steven Hurtado on 3/13/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController
{

    let segues = ["embedInitialCenterController"]
    
    private var previousIndex: NSIndexPath?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let backgroundImage = UIImage(named: "bamboo-1x")
        
        let imgView = UIImageView(image: backgroundImage)
        
        imgView.contentMode = .scaleAspectFill
        
        self.tableView.backgroundView = imgView
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        
        //if both mentor and learner then 2 else 1
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return segues.count
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.selectionStyle = .none
        
        if let index = previousIndex
        {
            print("Deselect : \(segues[indexPath.row])")
            tableView.deselectRow(at: index as IndexPath, animated: true)
        }
        
        print("Perform : \(segues[indexPath.row])")
        sideMenuController?.performSegue(withIdentifier: segues[indexPath.row], sender: nil)
        previousIndex = indexPath as NSIndexPath?
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = menuViewCell()
        
        let type = "Learner"
        
        if(type == "Learner")
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "learnerCell") as! menuViewCell
        }
        else // "mentor"
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "mentorCell") as! menuViewCell
        }
        
        switch(indexPath.row)
        {
        case 0:
//            cell.viewName.text = "Home"
            let viewImg = (UIImage(named: "Langu Solo")?.withRenderingMode(.alwaysTemplate))!
            cell.imgView.image = viewImg
            break;
        default:
            break;
            
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
