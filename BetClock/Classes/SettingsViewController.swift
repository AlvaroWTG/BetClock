//
//  SettingsViewController.swift
//  BetClock
//
//  Created by WebToGo on 3/24/17.
//  Copyright © 2017 Alvaro GMH. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Setup navigation bar
        navigationController?.navigationBar.barTintColor = Configuration.Color.Color147855
        UIApplication.shared.statusBarStyle = .lightContent

        // Setup the navigation item title
        navigationItem.title = "Settings"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
