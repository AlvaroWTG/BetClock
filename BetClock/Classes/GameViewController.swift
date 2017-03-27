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
        setupInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Inherited functions from UICollectionView data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sponsors.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as? GameCell else {
            fatalError("The dequeued cell is not an instance of GameCell.")
        }

        let label = UILabel.init(frame: frameForLabel())
        label.text = sponsors[indexPath.row]
        label.adjustsFontSizeToFitWidth = true
        label.textColor = Colors.Color3A3A3A
        label.textAlignment = .center
        label.numberOfLines = 0
        cell.addSubview(label)

        // Setup border color and width for cell
        cell.layer.borderColor = Colors.ColorF0F0F0.cgColor;
        cell.layer.borderWidth = 0.5;
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        sizePerItem = view.frame.size.width / 2.0
        return CGSize.init(width: sizePerItem, height: sizePerItem)
    }

    //MARK: Inherited functions from UICollectionView delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        NSLog("tapped %@!", sponsors[indexPath.row])
    }

    //MARK: Auxiliary functions
    
    /**
     * Auxiliary function that returns the frame size for a cell element
     * @param isImage The boolean parameter whether is image or not
     */
    func frameForLabel() -> CGRect {
        if sizePerItem == Size.SizeIphone5 {
            return CGRect.init(x: 8, y: 106, width: 144, height: 46)
        } else if sizePerItem == Size.SizeIphone6 {
            return CGRect.init(x: 8, y: 121, width: 171, height: 58)
        } else if sizePerItem == Size.SizeIphone6plus {
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
        let navigationBar = navigationController?.navigationBar
        navigationBar?.barTintColor = Colors.Color147855
        UIApplication.shared.statusBarStyle = .lightContent

        // Setup the navigation item title
        navigationItem.title = "Game #\(row)"

        // Setup interface
        labelTeamHome.text = "PES United"
        labelTeamAway.text = "FC Bayern"
        labelScoreHome.text = "1"
        labelScoreAway.text = "0"
    }
}
