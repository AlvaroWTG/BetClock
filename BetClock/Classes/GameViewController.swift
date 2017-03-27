//
//  GameViewController.swift
//  BetClock
//
//  Created by WebToGo on 3/27/17.
//  Copyright © 2017 Alvaro GMH. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var labelTeamHome: UILabel!
    @IBOutlet weak var labelTeamAway: UILabel!
    @IBOutlet weak var labelScoreHome: UILabel!
    @IBOutlet weak var labelScoreAway: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Setup navigation bar
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barTintColor = UIColor.init(red: 20/255, green: 120/255, blue: 85/255, alpha: 1)
        UIApplication.shared.statusBarStyle = .lightContent

        // Setup the navigation item title
        self.navigationItem.title = "Game"
        
        // Setup interface
        self.labelTeamHome.text = "PES United"
        self.labelTeamAway.text = "FC Bayern"
        self.labelScoreHome.text = "1"
        self.labelScoreAway.text = "0"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}