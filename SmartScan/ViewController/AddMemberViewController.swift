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

    let model = InnerDatabase()
    
    @IBOutlet weak var tableView: UITableView!
    
    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(model.userList.count)
        return model.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath)
        cell.textLabel?.text = model.userList[indexPath.row].loginName! as String
        return cell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Navigation

}
