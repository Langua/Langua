//
//  ChatViewController.swift
//  Langua
//
//  Created by Steven Hurtado on 4/16/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate
{
    @IBOutlet weak var chatTextView: UITextView!

    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var messageArray: [String]! = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(messageArray != nil)
        {
            return messageArray.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch(indexPath.row)
        {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "receiveCell", for: indexPath) as! ChatCell
//            
//            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "sendCell", for: indexPath) as! ChatCell
            
            cell.chatLabel.text = messageArray[indexPath.row]
            
            return cell
        }
    }
    
    @IBAction func sendBtnPressed(_ sender: Any)
    {
        
        if(self.chatTextView.text! != "")
        {
            let textToSend = self.chatTextView.text!
            
            self.messageArray.append(textToSend)
            
            self.tableView.reloadData()
        }
        
        self.chatTextView.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        self.chatTextView.resignFirstResponder()
        self.view.endEditing(true)
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
