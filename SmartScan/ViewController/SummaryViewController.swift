//
//  SummaryViewController.swift
//  SmartScan
//
//  Created by Carin Gan on 4/21/18.
//  Copyright © 2018 Carin Gan. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var model = InnerDatabase()
    var bill = Bill()
    var allUsers : [User] = []
    var singlePrices : [(String, Float)] = []
    var switchStatus : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calculate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        for all in model.userList {
            all.payment = 0
        }
    }
    
    func calculate() {
        print(bill.item)
        for each in bill.item {
            if let itemPrice = each.price {
                let price = Float(itemPrice)! / Float(each.member.count)
                print(String(price))
                singlePrices.append((each.name!, price))
            }
        }
        for each in model.userList {
            for item in each.item {
                for (key, value) in singlePrices {
                    if item.name == key {
                        each.payment += value
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    
    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var relevantUsers = 0
        for all in model.userList {
            if !all.item.isEmpty {
                relevantUsers += 1
                allUsers.append(all)
            }
        }
        return relevantUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath)
        cell.textLabel?.text = allUsers[indexPath.row].loginName as String?
        let s = NSString(format: "%.2f", allUsers[indexPath.row].payment)
        cell.detailTextLabel?.text = s as String
        return cell
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            for all in allUsers {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["\(all.email! as String)"])
                mail.setMessageBody("Please pay \(all.payment)", isHTML: true)
                present(mail, animated: true)
            }
        } else {
            let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
            sendMailErrorAlert.show()
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "unwindToScanner" {
            if !MFMailComposeViewController.canSendMail() {
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BillViewController {
            destination.bill = bill
            destination.model = model
            destination.switchStatus = switchStatus!
        }
    }

}
