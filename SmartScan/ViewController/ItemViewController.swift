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
    var itemName: String?
    var price: String?
    let model = InnerDatabase()
    var members: [User] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        item.text = itemName!
        priceDisplay.text = price!
        print("member count = " + String(members.count))
    }
    

    @IBAction func unwindToItem(segue: UIStoryboardSegue) {}
    
    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = model.userList[indexPath.row].loginName! as String
        return cell
    }

    // MARK: - Navigation


}
