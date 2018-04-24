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
    
    var model = InnerDatabase()
    var bill : Bill?
    var switchStatus : Bool = false
    
    @IBOutlet weak var switchOutlet: UISwitch!
    @IBAction func mySwitch(_ sender: Any) {
        if (switchOutlet.isOn) {
            switchOutlet.isOn = false
        }
        else {
            switchOutlet.isOn = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        switchOutlet.isOn = switchStatus
        
        let rootRef = Database.database().reference()
        let query = rootRef.child("Users").queryOrdered(byChild: "loginName")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let value = child.value as? NSDictionary
                let loginName = value?["loginName"] as? String ?? ""
                print(loginName)
                let user = User(loginName: loginName as NSString)
                var userExist = false
                for member in self.model.userList {
                    if member.loginName == user.loginName {
                        userExist = true
                    }
                }
                if (!userExist) {
                    self.model.insertUser(user: user)
                }
                print(String(describing: self.model.userList.count))
            }
        }
        
        let userID = Auth.auth().currentUser?.uid
        rootRef.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let loginName = value?["loginName"] as? String ?? ""
            print(loginName)
            if (self.switchStatus) {
                var isAdded = false
                for each in (self.bill?.item)! {
                    for people in each.member {
                        if (String(describing: people.loginName) == loginName) {
                            isAdded = true
                        }
                    }
                    if (!isAdded) {
                        each.member.append(User(loginName: loginName as NSString))
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
        
    
    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
                    print(String(describing: model.userList.count))
                    destination.model = model
                    destination.switchStatus = switchStatus
                }
            }
        }
        
        if segue.identifier == "summarySegue" {
            if let destination = segue.destination as? SummaryViewController {
                destination.bill = bill!
                destination.model = model
                destination.switchStatus = switchStatus
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "summarySegue" {
            for each in (bill?.item)! {
                if each.member.isEmpty {
                    let alert  = UIAlertController(title: "Warning", message: "Did not assign \(each.name!)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return false
                }
            }
        }
        return true
    }
    
}
