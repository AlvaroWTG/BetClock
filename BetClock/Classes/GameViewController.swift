//
//  GameViewController.swift
//  BetClock
//
//  Created by WebToGo on 3/27/17.
//  Copyright © 2017 Alvaro GMH. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell {
    
    //MARK: Properties
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
}

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelScoreHome: UILabel!
    @IBOutlet weak var labelScoreAway: UILabel!
    @IBOutlet weak var labelTeamHome: UILabel!
    @IBOutlet weak var labelTeamAway: UILabel!
    var sponsors: [String] = ["Bet365", "BetFair", "Bet4", "Bet5"]
    var sizePerItem: CGFloat = 0
    var row: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Setup interface
        self.setupInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Inherited functions from UICollectionView data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sponsors.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as? GameCell else {
            fatalError("The dequeued cell is not an instance of GameCell.")
        }

        let label = UILabel.init(frame: self.frameForLabel())
        label.text = self.sponsors[indexPath.row]
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.blue
        label.numberOfLines = 0
        cell.addSubview(label)

        // Setup border color and width for cell
        cell.layer.borderColor = UIColor.blue.cgColor;
        cell.layer.borderWidth = 0.5;
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        sizePerItem = self.view.frame.size.width / 2.0
        return CGSize.init(width: sizePerItem, height: sizePerItem)
    }

    //MARK: Inherited functions from UICollectionView delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        NSLog("tapped %@!", self.sponsors[indexPath.row])
    }

    //MARK: Auxiliary functions
    
    /**
     * Auxiliary function that returns the frame size for a cell element
     * @param isImage The boolean parameter whether is image or not
     */
    func frameForLabel() -> CGRect {
        if sizePerItem == 160.0 {
            return CGRect.init(x: 8, y: 106, width: 144, height: 46)
        } else if sizePerItem == 187.0 {
            return CGRect.init(x: 8, y: 121, width: 171, height: 58)
        } else if sizePerItem == 207.0 {
            return CGRect.init(x: 8, y: 131, width: 191, height: 68)
        } else {
            return CGRect.init(x: 8, y: 106, width: 144, height: 46)
        }
    }

    /**
     * Auxiliary function that setups the interface
     */
    func setupInterface() {

        // Setup navigation bar
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barTintColor = UIColor.init(red: 20/255, green: 120/255, blue: 85/255, alpha: 1)
        UIApplication.shared.statusBarStyle = .lightContent

        // Setup the navigation item title
        self.navigationItem.title = "Game #\(self.row)"

        // Setup interface
        self.labelTeamHome.text = "PES United"
        self.labelTeamAway.text = "FC Bayern"
        self.labelScoreHome.text = "1"
        self.labelScoreAway.text = "0"
    }
}
