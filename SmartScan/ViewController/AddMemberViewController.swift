//
//  AddMemberViewController.swift
//  SmartScan
//
//  Created by Carin Gan on 4/23/18.
//  Copyright © 2018 Carin Gan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddMemberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let model = InnerDatabase()
    
    @IBOutlet weak var tableView: UITableView!
    
    func getUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = User(loginName: (dictionary["name"] as? NSString)!)
                self.model.addUser(user: user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }, withCancel: nil)
    }
    
    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath)
        cell.textLabel?.text = model.userList[indexPath.row].loginName! as String
        return cell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

    }
    
    // MARK: - Navigation

}
