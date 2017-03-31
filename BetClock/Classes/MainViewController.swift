//
//  MainViewController.swift
//  BetClock
//
//  Created by WebToGo on 3/24/17.
//  Copyright © 2017 Alvaro GMH. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

class MainCell: UITableViewCell {

    //MARK: Properties

    /** Property that represents the label for cell title */
    @IBOutlet weak var labelTitle: UILabel!
    /** Property that represents the image view for the game icon */
    @IBOutlet weak var imageIcon: UIImageView!
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties

    /** Property that represents the main table view */
    @IBOutlet weak var tableView: UITableView!
    /** Property that represents the list of scores obtained */
    var scores:Array<String> = []
    /** Property that represents the list of home teams obtained */
    var homeTeams:Array<String> = []
    /** Property that represents the list of away teams obtained */
    var awayTeams:Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Fetch content and setup interface
        DispatchQueue.global().async {self.fetch()}
        setupInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Inherited functions from UITableView data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return scores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Table view cells are reused and should be dequeued using a cell identifier.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as? MainCell else {
            fatalError("The dequeued cell is not an instance of MainCell.")
        }
        cell.labelTitle.text = "\(homeTeams[indexPath.row])\n\(awayTeams[indexPath.row])"
        cell.labelTitle.numberOfLines = 0
        return cell
    }

    //MARK: - Inherited function from UITableView delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        viewController.homeTeam = homeTeams[indexPath.row]
        viewController.awayTeam = awayTeams[indexPath.row]
        viewController.score = scores[indexPath.row]
        viewController.row = indexPath.row
        navigationController?.pushViewController(viewController, animated: true)
    }

    //MARK: - Auxiliary functions

    /**
     * Auxiliary function that fetchs html content
     */
    func fetch() {
        let requestSession = "https://www.betfair.es/exchange/inplay"
        NSLog("[Alamofire] Log: Sending request to %@", requestSession)
        var request = URLRequest.init(url: URL.init(string: requestSession)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        Alamofire.request(request).responseString { response in
            NSLog("[Alamofire] Log: Server response: \(response.result.description)")
            if let contents = response.result.value {
                self.parse(contents: contents)
            }
        }
    }

    /**
     * Auxiliary function that parse initial content
     * - parameter contents: The content string-value to parse
     */
    func parse(contents: String) {
        if let html = HTML(html: contents, encoding: .utf8) { // create html document
            NSLog("[Kanna] Log: HTML document (ID:%@) created...", html.title ?? "unknown")
            for node in html.css(Configuration.Tag.TagSpan) { // loop for nodes
                let range = node.innerHTML?.range(of: Configuration.Tag.TagInPlay)
                if range != nil { // if found, append content
                    parseElement(category: 0, html: node.innerHTML!, key: Configuration.Tag.TagTeamHome)
                    parseElement(category: 1, html: node.innerHTML!, key: Configuration.Tag.TagScore)
                    parseElement(category: 2, html: node.innerHTML!, key: Configuration.Tag.TagTeamAway)
                }
            }
        } else {
            NSLog("[Kanna] Error! An error ocurred. Error 404 - HTML document failed to create")
        }
        tableView.reloadData()
    }

    /**
     * Auxiliary function that parse and element
     * - parameter category: The index of the category
     * - parameter html: The html string-value to parse
     * - parameter key: The key string-value to parse for
     */
    func parseElement(category: Int, html: String, key: String) {
        var element = ""
        var range = html.range(of: key)
        if range != nil { // found element
            element = (html.substring(from: (range?.upperBound)!))
            range = element.range(of: Configuration.Tag.TagSpanEnd)
            element = element.substring(to: (range?.lowerBound)!)
        }
        switch category {
            case 0: // home team
                homeTeams.append(element)
            case 1: // score
                scores.append(element)
            case 2: // away team
                awayTeams.append(element)
            default:
                print("unknown")
        }
    }

    /**
     * Auxiliary function that setups the interface
     */
    func setupInterface() {

        // Setup navigation bar
        navigationController?.navigationBar.barTintColor = Configuration.Color.Color147855
        UIApplication.shared.statusBarStyle = .lightContent

        // Setup navigation item title
        navigationItem.title = "BetClock"
    }

    /**
     * Auxiliary function that returns a trimmed text
     * - parameter text: The text string-value to trim
     */
    func trim(text: String) -> String {
        let result = text.replacingOccurrences(of: "\n", with: "")
        return result.replacingOccurrences(of: "   ", with: "")
    }

    //MARK: - JSON de-/serialization auxiliary functions - UNUSED

    /**
     * Auxiliary function that obtain a json from the serialized one
     * - parameter serializedJson: The JSON object serialized
     */
    func deserializeJson(serializedJson: NSData) -> NSDictionary {
        let stringSerializedJson = String(data: serializedJson as Data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
        NSLog("[JSONSerialization] Log: serializedJson JSON - %@", stringSerializedJson)
        do {
            let json = try JSONSerialization.jsonObject(with: serializedJson as Data , options:.mutableContainers)
            if let dictionary = json as? NSDictionary {
                NSLog("[JSONSerialization] Log: Deserialized JSON - %@", dictionary)
                return dictionary
            }
            NSLog("[JSONSerialization] Error! Found an error. Error 404: Result is not a dictionary")
        } catch let error as NSError {
            NSLog("[JSONSerialization] Error! Found an error. Error %d: %@", error.code, error.localizedDescription)
        }
        return NSDictionary.init()
    }

    /**
     * Auxiliary function that post a request and returns the result
     */
    func postRequest() -> NSDictionary {
        let request = NSMutableURLRequest.init(url: URL.init(string: "https://api.betfair.com/exchange/betting/rest/v1.0/")!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            var response: URLResponse?
            NSLog("[NSURLConnection] Log: Sending synch request %@", request.url?.absoluteString ?? "")
            let responseData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
            return deserializeJson(serializedJson: responseData as NSData)
        } catch let error as NSError {
            NSLog("[NSURLConnection] Error! Found an error. Error %d: %@", error.code, error.localizedDescription)
        }
        return NSDictionary.init()
    }

    /**
     * Auxiliary function that serializes a JSON object
     * - parameter json: The JSON object received for the body
     */
    func serializeJson(json: NSDictionary) -> NSData {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            NSLog("[JSONSerialization] Log: Serialized JSON")
            return data as NSData
        } catch let error as NSError {
            NSLog("[JSONSerialization] Error! Found an error. Error %d: %@", error.code, error.localizedDescription)
        }
        return NSData.init()
    }
}
