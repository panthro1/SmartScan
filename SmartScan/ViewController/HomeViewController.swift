//
//  HomeViewController.swift
//  SmartScan
//
//  Created by Carin Gan on 4/21/18.
//  Copyright © 2018 Carin Gan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var username: String?
    @IBOutlet weak var hi: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let database = InnerDatabase()
    var user: User?
    var bills: [Bill] = []
    var bill: Bill?
    
    let ref = Database.database().reference().child("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["loginName"] as? String ?? ""
            self.hi.text = "Hi " + username + "!"
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func didTapLogOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    //Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)
        //cell.textLabel?.text = bills[indexPath.row]
        //cell.detailTextLabel?.text = bills[indexPath.row].total
        return cell
    }
    
    @IBAction func didTapScanner(_ sender: Any) {
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historySegue" {
            if let destination = segue.destination as? HistoryViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    destination.bill = bills[indexPath.row]
                }
            }
        }
    }

}
