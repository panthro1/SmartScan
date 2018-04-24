//
//  SummaryViewController.swift
//  SmartScan
//
//  Created by Carin Gan on 4/21/18.
//  Copyright © 2018 Carin Gan. All rights reserved.
//

import UIKit
import Foundation

class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var model = InnerDatabase()
    var bill = Bill()
    var singlePrices : [(String, Float)] = []
    var switchStatus : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        calculate()
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
        return model.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath)
        cell.textLabel?.text = (model.userList[indexPath.row].loginName) as String?
        let s = NSString(format: "%.2f", model.userList[indexPath.row].payment)
        cell.detailTextLabel?.text = s as String
        return cell
    }

}
