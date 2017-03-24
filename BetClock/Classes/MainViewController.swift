//
//  MainViewController.swift
//  BetClock
//
//  Created by WebToGo on 3/24/17.
//  Copyright © 2017 Alvaro GMH. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var labelTitle: UILabel!
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Setup navigation bar
        let navigationBar = self.navigationController?.navigationBar
        UIApplication.shared.statusBarStyle = .lightContent
        navigationBar?.barTintColor = UIColor.green

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Table view cells are reused and should be dequeued using a cell identifier.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as? MainCell else {
            fatalError("The dequeued cell is not an instance of MainCell.")
        }
        cell.labelTitle.text = "blabla"
        return cell
    }

    //MARK: Inherited functions from UITableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Bla!")
    }

}
