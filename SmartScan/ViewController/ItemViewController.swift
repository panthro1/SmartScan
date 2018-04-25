//
//  ItemViewController.swift
//  SmartScan
//
//  Created by Carin Gan on 4/21/18.
//  Copyright © 2018 Carin Gan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var priceDisplay: UILabel!
    var model = InnerDatabase()
    var currentItem: Item?
    var bill = Bill()
    var switchStatus: Bool!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(String(describing: model.userList.count))

        tableView.delegate = self
        tableView.dataSource = self
        item.text = currentItem?.name
        priceDisplay.text = currentItem?.price
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    @IBAction func unwindToItem(segue: UIStoryboardSegue) {}
    
    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentItem?.member.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = currentItem?.member[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let itemToRemove = currentItem?.member[indexPath.row]
            currentItem?.member.remove(at: indexPath.row)
            for all in bill.item {
                if all == currentItem {
                    if let itemToRemoveIndex = all.member.index(of: itemToRemove!) {
                        all.member.remove(at: itemToRemoveIndex)
                    }
                }
            }
            
            // remove item in user
            for all in model.userList {
                if (all.loginName! as String) == itemToRemove {
                    if let itemToRemove = all.item.index(of: currentItem!) {
                        all.item.remove(at: itemToRemove)
                    }
                }
            }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMemberSegue" {
            if let destination = segue.destination as? AddMemberViewController {
                destination.currentItem = currentItem
                destination.bill = bill
                destination.model = model
                destination.switchStatus = switchStatus
            }
        }
        if segue.identifier == "unwindToBill" {
            if let destination = segue.destination as? BillViewController {
                for each in (bill.item) {
                    print(each.name!)
                    print(each.price!)
                    print(each.member)
                }
                for each in model.userList {
                    print(each.item)
                }
                destination.bill = bill
                destination.model = model
                destination.switchStatus = switchStatus
            }
        }
    }
}
