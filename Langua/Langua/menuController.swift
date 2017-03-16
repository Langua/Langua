//
//  menuController.swift
//  Langua
//
//  Created by Steven Hurtado on 3/13/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Foundation
import SideMenuController

class menuController: SideMenuController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        performSegue(withIdentifier: "embedInitialCenterController", sender: nil)
        performSegue(withIdentifier: "embedSideController", sender: nil)
        // Do any additional setup after loading the view.
    }

    required init?(coder aDecoder: NSCoder)
    {
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "Menu Filled-50")?.withRenderingMode(.alwaysTemplate)
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = 300
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay
        
        super.init(coder: aDecoder)
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
