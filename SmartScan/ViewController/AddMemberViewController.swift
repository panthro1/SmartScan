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

    var model : InnerDatabase?
    var bill = Bill()
    var currentItem : Item?
    
    @IBOutlet weak var tableView: UITableView!
    
    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model!.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
        cell.textLabel?.text = model?.userList[indexPath.row].loginName! as! String
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToItem" {
            if let destination = segue.destination as? ItemViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    let member = User(loginName: model?.userList[indexPath.row].loginName! as! NSString)
                    for each in bill.item {
                        if (each.name == currentItem?.name) {
                            each.member.append(member)
                        }
                    }
                    destination.model = model
                    destination.currentItem = currentItem
                    destination.bill = bill
                }
            }
        }
    }
}
