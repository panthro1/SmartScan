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

    var model = InnerDatabase()
    var bill = Bill()
    var currentItem : Item?
    var switchStatus: Bool!

    @IBOutlet weak var tableView: UITableView!
    
    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
        cell.textLabel?.text = model.userList[indexPath.row].loginName! as String
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToItem" {
            if let destination = segue.destination as? ItemViewController {
                    destination.model = model
                    destination.currentItem = currentItem
                    destination.bill = bill
                    destination.switchStatus = switchStatus
                }
            }
        }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "unwindToItem" {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                let member = User(loginName: model.userList[indexPath.row].loginName!, email: "")
                var alreadyAdded = false
                for each in bill.item {
                    if each.name == currentItem?.name {
                        if (currentItem?.member.contains(member.loginName as! String))! {
                            alreadyAdded = true
                            let alert  = UIAlertController(title: "Warning", message: "Already added this person", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return false
                        }
                        if (!alreadyAdded) {
                            each.member.append(member.loginName! as String)
                            for each in model.userList {
                                if each.loginName == member.loginName {
                                    each.item.append(currentItem!)
                                    return true
                                }
                            }
                        }
                    }
                }
            }
        }
        return true
    }
}

