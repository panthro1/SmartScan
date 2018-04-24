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
    
    
    var model : InnerDatabase?
    var bill : Bill?
    
    var username : String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let rootRef = Database.database().reference()
        let query = rootRef.child("Users").queryOrdered(byChild: "loginName")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let value = child.value as? NSDictionary
                let loginName = value?["loginName"] as? String ?? ""
                print(loginName)
                let user = User(loginName: loginName as NSString)
                self.model?.userList.append(user)
                self.tableView.reloadData()
            }
        }
    }
    
    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(String(bill!.item.count))
        return bill!.item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath)
        cell.textLabel?.text = bill?.item[indexPath.row].name
        cell.detailTextLabel?.text = bill?.item[indexPath.row].price
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemSegue" {
            if let destination = segue.destination as? ItemViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    destination.currentItem = bill?.item[indexPath.row]
                    destination.bill = bill
                    destination.model = model
                }
            }
        }
    }
    
}
