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
    
    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(model.userList.count)
        return model.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
        cell.textLabel?.text = model.userList[indexPath.row].loginName! as String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "unwindToItem", sender: self)
//        if let navController = self.navigationController {
//            navController.popViewController(animated: true)
//        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let rootRef = Database.database().reference()
        let query = rootRef.child("Users").queryOrdered(byChild: "loginName")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let value = child.value as? NSDictionary
                let loginName = value?["loginName"] as? String ?? ""
                print(loginName)
                let user = User(loginName: loginName as NSString)
                self.model.userList.append(user)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToItem" {
            if let destination = segue.destination as? ItemViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    let member = User(loginName: model.userList[indexPath.row].loginName! as NSString)
                    destination.members.append(member)
                }
            }
        }
    }
}
