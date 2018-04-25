//
//  ItemHistoryViewController.swift
//  SmartScan
//
//  Created by Carin Gan on 4/21/18.
//  Copyright © 2018 Carin Gan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ItemHistoryViewController: UIViewController {
    
    var model = InnerDatabase()
    var bill = Bill()
    var switchStatus : Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "unwindToBillFromAdd" {
            
            if (itemName!.text!.isEmpty) {
                let alert  = UIAlertController(title: "Warning", message: "Item Name is empty", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            }
            
            if (itemPrice!.text!.isEmpty) {
                let alert  = UIAlertController(title: "Warning", message: "Price is empty", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            }
            
            let priceRegEx = "\\d+[\\.]\\d\\d"
            let priceTest = NSPredicate(format:"SELF MATCHES %@", priceRegEx)
            let correctFormat = priceTest.evaluate(with: itemPrice!.text!)
            
            if (!correctFormat) {
                let alert  = UIAlertController(title: "Warning", message: "Incorrect price format", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToBillFromAdd" {
            if let destination = segue.destination as? BillViewController {
                
                
                let newItem = Item()
                newItem.price = itemPrice.text!
                newItem.name = itemName.text!.capitalized
                newItem.member = []
                if (switchStatus!) {
                    let userID = Auth.auth().currentUser?.uid
                    let ref = Database.database().reference()
                    ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as? NSDictionary
                        let loginName = value?["loginName"] as? String ?? ""
                        print(loginName)
                        newItem.member.append(loginName)
                        for all in self.model.userList {
                            if (all.loginName! as String) == loginName {
                                all.item.append(newItem)
                            }
                        }
                    })
                }
                bill.item.append(newItem)
                destination.model = model
                destination.bill = bill
                destination.switchStatus = switchStatus!
            }
        }
    }
}
