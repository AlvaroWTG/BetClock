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
    @IBOutlet weak var imageIcon: UIImageView!
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

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
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Table view cells are reused and should be dequeued using a cell identifier.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as? MainCell else {
            fatalError("The dequeued cell is not an instance of MainCell.")
        }
        cell.labelTitle.text = "Game #\(indexPath.row)"
        return cell
    }

    //MARK: - Inherited function from UITableView delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        viewController.row = indexPath.row
        navigationController?.pushViewController(viewController, animated: true)
    }

    //MARK: - Auxiliary functions

    /**
     * Auxiliary function that setups the interface
     */
    func setupInterface() {

        // Setup navigation bar
        let navigationBar = navigationController?.navigationBar
        UIApplication.shared.statusBarStyle = .lightContent
        navigationBar?.barTintColor = Colors.Color147855

        // Setup navigation item title
        navigationItem.title = "BetClock"
    }

    /**
     * Auxiliary function that post a request with a body
     * @param requestSession The initial request session
     * @param body The http body of the request
     * @return result The resulting arguments of the response
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

    //MARK: - JSON de-/serialization auxiliary functions

    /**
     * Auxiliary function that obtain a json from the serialized one
     * @param serializedJson The JSON object serialized
     * @return json The json object obtained from the body
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
     * Auxiliary function that serializes a JSON object
     * @param json The JSON object received for the body
     * return serializedJson The JSON object serialized
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
