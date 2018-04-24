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
    var model : InnerDatabase?
    var currentItem: Item?
    var bill: Bill?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        item.text = currentItem?.name
        priceDisplay.text = currentItem?.price
    }
    

    @IBAction func unwindToItem(segue: UIStoryboardSegue) {}
    
    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentItem?.member.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = currentItem?.member[indexPath.row].loginName! as! String
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMemberSegue" {
            if let destination = segue.destination as? AddMemberViewController {
                destination.currentItem = currentItem
                destination.bill = bill!
                destination.model = model!
            }
        }
        if segue.identifier == "backToBill" {
            if let destination = segue.destination as? BillViewController {
                destination.bill = bill
                destination.model = model
            }
        }
    }

}
