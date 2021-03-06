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
    var bill = Bill()
    var switchStatus : Bool = false
    var results : [String] = []
    var prices : [String] = []
    var itemName : [String] = []
    var newName : String?
    var newPrice : String?
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var switchOutlet: UISwitch!
    @IBAction func mySwitch(_ sender: Any) {
        if (!switchOutlet.isOn) {
            switchStatus = false
        }
        else {
            switchStatus  = true
            let userID = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let loginName = value?["loginName"] as? String ?? ""
                print(loginName)
                var isAdded = false
                for each in (self.bill.item) {
                        for people in each.member {
                            if (people == loginName) {
                                isAdded = true
                            }
                        }
                        if (!isAdded) {
                            each.member.append(loginName)
                            for all in self.model.userList {
                                if ((all.loginName! as String) == loginName) {
                                    all.item.append(each)
                                }
                            }
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        print("Recognition progress \(tesseract.progress)%")
    }
    
    func clean(items: [String]) -> [String] {
        var trimmedStrings : [String] = []
        for each in items {
            if each[each.startIndex] == " " {
                var trimmedString = each.substring(fromIndex: 1)
                trimmedString = trimmedString.replace(target: "'", withString:" ")
                trimmedString = trimmedString.replace(target: "‘", withString:" ")
                trimmedStrings.append(trimmedString.capitalized)
            }
            else {
                var temp : String?
                temp = each.replace(target: "'", withString:" ")
                temp = each.replace(target: "‘", withString:" ")
                trimmedStrings.append(each.capitalized)
            }
        }
        return trimmedStrings
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (bill.item.isEmpty) {
            if let tesseract = G8Tesseract(language: "eng") {
                tesseract.delegate = self
                tesseract.image = photo?.image?.g8_blackAndWhite()
                tesseract.recognize()
                textView.text = tesseract.recognizedText
                print(tesseract.recognizedText)
            }
            
            var results = textView.text.regex()
            print(results)
            results = clean(items: results)
            
            for item in results {
                prices = prices + item.getPrice()
                itemName = itemName + item.getItem()
            }
            
            print(itemName)
            print(prices)
            
            if !results.isEmpty {
                for i in 0...results.count - 1 {
                    let item = Item()
                    item.member = []
                    item.name = itemName[i]
                    item.price = prices[i]
                    bill.item.append(item)
                }
            }
            
            print(bill.item.count)
            
        }
        
        switchOutlet.isOn = switchStatus
        
        let rootRef = Database.database().reference()
        let query = rootRef.child("Users").queryOrdered(byChild: "loginName")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let value = child.value as? NSDictionary
                let loginName = value?["loginName"] as? String ?? ""
                let email = value?["email"] as? String ?? ""
                let user = User(loginName: loginName as NSString, email: email as NSString)
                var userExist = false
                for member in self.model.userList {
                    if member.loginName == user.loginName {
                        userExist = true
                    }
                }
                if (!userExist) {
                    self.model.userList.append(user)
                }
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func unwindToBill(segue: UIStoryboardSegue) {}
    @IBAction func unwindToBillFromAdd(segue: UIStoryboardSegue) {}

    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bill.item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath)
        cell.textLabel?.text = bill.item[indexPath.row].name
        cell.detailTextLabel?.text = bill.item[indexPath.row].price
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let itemToRemove = bill.item[indexPath.row]
            bill.item.remove(at: indexPath.row)
            
            // remove item in user
            for all in model.userList {
                if all.item.contains(itemToRemove) {
                    if let remove = all.item.index(of: itemToRemove) {
                        all.item.remove(at: remove)
                    }
                }
            }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemSegue" {
            if let destination = segue.destination as? ItemViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    destination.currentItem = bill.item[indexPath.row]
                    destination.bill = bill
                    destination.model = model
                    destination.switchStatus = switchStatus
                }
            }
        }
        
        if segue.identifier == "itemHistorySegue" {
            if let destination = segue.destination as? ItemHistoryViewController {
                destination.bill = bill
                destination.model = model
                destination.switchStatus = switchStatus
            }
        }
        
        if segue.identifier == "summarySegue" {
            if let destination = segue.destination as? SummaryViewController {
                destination.bill = bill
                destination.model = model
                destination.switchStatus = switchStatus
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "summarySegue" {
            for each in (bill.item) {
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


extension String {
    func regex() -> [String]
    {
        let pat = "([^\\d\\W]?)+[ ]\\w+[ ]\\d+(\\.|,|‘)\\d\\d"
        
        
        do {
            let string = self as NSString
            let regex = try NSRegularExpression(pattern: pat, options: .caseInsensitive)
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range).replacingOccurrences(of: ",", with: ".").lowercased()
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return[]
        }
    }
    
    func getPrice() -> [String]
    {
        let pat = "\\d+(\\.|,|‘)\\d\\d"
        
        
        do {
            let string = self as NSString
            let regex = try NSRegularExpression(pattern: pat, options: .caseInsensitive)
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range)
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return[]
        }
    }
    
    func getItem() -> [String]
    {
        let pat = "(\\w+[A-Z][a-z]?)[ ]?(\\w+)[ ]"
        
        
        do {
            let string = self as NSString
            let regex = try NSRegularExpression(pattern: pat, options: .caseInsensitive)
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range)
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return[]
        }
    }
    
}

extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
        
    }
    
}
