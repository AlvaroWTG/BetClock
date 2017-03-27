//
//  UpcomingViewController.swift
//  BetClock
//
//  Created by WebToGo on 3/27/17.
//  Copyright © 2017 Alvaro GMH. All rights reserved.
//

import UIKit

class UpcomingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Setup navigation bar
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barTintColor = UIColor.init(red: 20/255, green: 120/255, blue: 85/255, alpha: 1)
        UIApplication.shared.statusBarStyle = .lightContent

        // Setup the navigation item title
        self.navigationItem.title = "Upcoming games"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Inherited functions from UITableView data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as? MainCell else {
            fatalError("The dequeued cell is not an instance of MainCell.")
        }
        cell.labelTitle.text = "Upcoming Game #\(indexPath.row)"
        return cell
    }

    //MARK: Inherited functions from UITableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alertView = UIAlertView.init(title: "Information", message: "Do you want to setup a reminder for this game?", delegate: self, cancelButtonTitle: "No, thanks")
        alertView.addButton(withTitle: "Yes, please")
        alertView.show()
    }

    //MARK: Inherited functions from UIAlertView delegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == alertView.cancelButtonIndex { // No
            NSLog("Log: Avoid setting reminder for game")
        } else { // Yes
            NSLog("Log: Setting reminder for this game")
        }
    }

}
