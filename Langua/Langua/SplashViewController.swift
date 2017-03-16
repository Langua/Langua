//
//  SplashViewController.swift
//  Langua
//
//  Created by Steven Hurtado on 3/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Spring

class SplashViewController: UIViewController
{

    @IBOutlet weak var languImageView: UIImageView!
    
    @IBOutlet weak var languaLabel: UILabel!
    
    @IBOutlet weak var bambooLeft: SpringImageView!
    @IBOutlet weak var bambooRight: SpringImageView!
    
    var titlePos : CGPoint = CGPoint()
    
    @IBOutlet weak var enterBtn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.enterBtn.layer.cornerRadius = 6
        
        self.languaLabel.alpha = 0
        self.enterBtn.alpha = 0
        
        self.titlePos = languaLabel.frame.origin
        
        animateTheWorld()
        
        let timer = Timer.scheduledTimer(timeInterval: 2.7, target: self, selector: #selector(animateBamboo), userInfo: nil, repeats: true)
        
        timer.fire()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func enterPressed(_ sender: Any)
    {
    }
    
    func animateBamboo()
    {
        self.bambooLeft.animation = "swing"
        self.bambooLeft.curve = "easeOutQuart"
        self.bambooLeft.velocity = 0.4
        self.bambooLeft.duration = 1.7
        self.bambooLeft.damping = 0.7
        
        self.bambooRight.animation = "swing"
        self.bambooRight.curve = "easeOutQuart"
        self.bambooRight.velocity = 0.4
        self.bambooRight.duration = 1.7
        self.bambooRight.damping = 0.7
        
        self.bambooLeft.animate()
        self.bambooRight.animate()
    }

    func animateTheWorld()
    {
        
        UIView.animate(withDuration:
            0.7)
        {
            self.languaLabel.alpha = 1
            self.enterBtn.alpha = 1
            self.languaLabel.frame.origin.y = self.titlePos.y + self.view.frame.height/4
            self.languaLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.languImageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }
        
        self.bambooLeft.animation = "squeezeRight"
        self.bambooLeft.curve = "easeOutQuart"
        self.bambooLeft.velocity = 0.4
        self.bambooLeft.duration = 2.0
        self.bambooLeft.damping = 0.7
        
        self.bambooRight.animation = "squeezeLeft"
        self.bambooRight.curve = "easeOutQuart"
        self.bambooRight.velocity = 0.4
        self.bambooRight.duration = 2.0
        self.bambooRight.damping = 0.7
        
        self.bambooLeft.animate()
        self.bambooRight.animate()
    }
    
    override func didReceiveMemoryWarning() {
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
