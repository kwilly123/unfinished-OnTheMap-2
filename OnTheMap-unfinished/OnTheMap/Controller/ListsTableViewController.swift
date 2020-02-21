//
//  ListsTableViewController.swift
//  OnTheMap
//
//  Created by Kyle Wilson on 2020-02-11.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import UIKit

class ListsTableViewController: UITableViewController {
    
    var result = [StudentLocation]()
    @IBOutlet var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        result = StudentLocation.lastFetched ?? []
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DataViewCell
        let student = self.result[indexPath.row]
        cell.name.text = "\(String(describing: student.firstName)) \(String(describing: student.lastName))"
        cell.url.text = student.mediaURL
        if let url = URL(string: cell.url.text!) {
            if url.absoluteString.contains("https://") {
                cell.imageView?.image = UIImage(named: "icon")
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = self.result[indexPath.row].mediaURL
        if let url = URL(string: url!) {
            UIApplication.shared.open(url)
        }
    }

}
