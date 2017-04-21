//
//  ChatViewController.swift
//  Langua
//
//  Created by Steven Hurtado on 4/16/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate
{
    @IBOutlet weak var chatTextView: UITextView!

    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var snap : FIRDataSnapshot?
    var writeArray : [NSMutableDictionary] = []
    var ref : FIRDatabaseReference!
    var currentRow : Int = 0
    
     var origPos: CGPoint!
    
    var user1ID : String?
    var user2ID : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        
        self.origPos = self.view.frame.origin
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        self.configureAuth()
    }
    
    func configureAuth()
    {
        FIRAuth.auth()?.addStateDidChangeListener { (auth: FIRAuth, user: FIRUser?) in
            //call reference to database
            self.ref = self.snap?.ref
            
            // refresh table data
            self.writeArray.removeAll(keepingCapacity: false)
            self.tableView.reloadData()
            
            self.configureDB()
        }
    }
    
    func configureDB()
    {
        self.user2ID = self.snap?.key
        self.user1ID = (Util._currentUser?.uid)!
        
        if(Util._currentUserType == "Learner")
        {
            
            ref.child("inbox").child("\(self.user1ID!)").child("messages").observe(.childAdded) { (snapshot: FIRDataSnapshot)in
                
                if(Util._currentUserType == "Learner")
                {
                    let val = snapshot.value as! NSMutableDictionary
                    self.writeArray.append(["message" : val["message"] as! String, "user" : val["user"] as! String])
                    
                    self.tableView.insertRows(at: [IndexPath(row: self.writeArray.count-1, section: 0)], with: .automatic)
                    self.tableViewScrollToBottom(animated: true)
                }
            }
        }
        else
        {
            //.child("inbox").child("\(self.user2ID!)")
            ref.child("messages").observe(.childAdded) { (snapshot: FIRDataSnapshot)in
            
                if(Util._currentUserType == "Mentor")
                {
                    let val = snapshot.value as! NSMutableDictionary
                    self.writeArray.append(["message" : val["message"] as! String, "user" : val["user"] as! String])
                    
                    self.tableView.insertRows(at: [IndexPath(row: self.writeArray.count-1, section: 0)], with: .automatic)
                    self.tableViewScrollToBottom(animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return writeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let val = self.writeArray[indexPath.row]
        
        let userID = val["user"] as! String
        
        var cell = ChatCell()
        
        if(userID == self.user1ID)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "sendCell", for: indexPath) as! ChatCell
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "receiveCell", for: indexPath) as! ChatCell
        }
        
        let message = val["message"] as! String
        cell.chatLabel.text = message
        
        return cell
    }
    
    @IBAction func sendBtnPressed(_ sender: Any)
    {
        
        if(self.chatTextView.text! != "")
        {
            let textToSend = self.chatTextView.text!
            
            var tempArr = self.writeArray
            tempArr.append(["message" : textToSend, "user" : self.user1ID!])
            
            //write to database
            if(Util._currentUserType == "Learner")
            {
                self.ref = self.snap?.ref
                let childUpdates = ["/inbox/\(self.user1ID!)" : ["messages" : tempArr, "learnername" : Util._currentDisplayName!]]
                self.ref.updateChildValues(childUpdates)
                
                
            }
            else
            {
                self.ref = FIRDatabase.database().reference()
                
                self.ref.child("user").child("\(self.user2ID!)").observe(.value
                    , with: { (snap: FIRDataSnapshot) in
                        let val = snap.value as! NSDictionary
                        let learnerName = val["displayName"] as! String
                        
                        let childUpdates = ["messages" : tempArr, "learnername" : learnerName] as [String : Any]
                        self.snap?.ref.updateChildValues(childUpdates)
                })
            }
        }
        
        UIView.animate(withDuration: 0.15)
        {
            self.view.frame.origin = self.origPos
        }
        
        self.chatTextView.text = ""
        self.chatTextView.resignFirstResponder()
        
        self.view.endEditing(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        UIView.animate(withDuration: 0.15)
        {
            self.view.frame.origin = self.origPos
        }
        
        self.chatTextView.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func keyboardNotification(notification: NSNotification)
    {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                
            } else {
                
                print("animating")
                UIView.animate(withDuration: 0.3, animations:
                    {
                        
                        let yPos = self.origPos.y - (endFrame?.size.height ?? 20)
                        self.view.frame.origin = CGPoint(x: 0, y: yPos)
                        
                        
                })
                
                
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    
    func tableViewScrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300))
        {
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0
            {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
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
