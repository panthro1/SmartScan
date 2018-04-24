//
//  BillViewController.swift
//  SmartScan
//
//  Created by Carin Gan on 4/21/18.
//  Copyright © 2018 Carin Gan. All rights reserved.
//

import UIKit
import TesseractOCR
import FirebaseAuth
import FirebaseDatabase

class BillViewController: UIViewController, G8TesseractDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var photo: UIImageView?
    @IBOutlet weak var tableView: UITableView!
    var prices : [String] = []
    var itemName : [String] = []
    
    let model = InnerDatabase()
    var username : String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getUsers()
    }

    func getUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            print(snapshot)

            if let dictionary = snapshot.value as? [String: AnyObject] {

                let user = User(loginName: (dictionary["name"] as? NSString)!)
                self.model.addUser(user: user)
                print(user)
            }

        }, withCancel: nil)
    }
    
    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(itemName.count)
        return itemName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath)
        cell.textLabel?.text = itemName[indexPath.row]
        cell.detailTextLabel?.text = prices[indexPath.row]
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemSegue" {
            if let destination = segue.destination as? ItemViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    destination.itemName = itemName[indexPath.row]
                    destination.price = prices[indexPath.row]
                }
            }
        }
    }
    
}
