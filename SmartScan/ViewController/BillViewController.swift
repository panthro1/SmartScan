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
    @IBOutlet weak var textView: UITextView!
    
    var results : [String] = []
    var prices : [String] = []
    var itemName : [String] = []
    
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
                    for each in (self.bill?.item)! {
                        for people in each.member {
                            if (people == loginName) {
                                isAdded = true
                            }
                        }
                        if (!isAdded) {
                            each.member.append(loginName)
                            for all in self.model.userList {
                                if (all.loginName as String? == loginName) {
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
                let email = value?["email"] as? String ?? ""
                let user = User(loginName: loginName as NSString, email: email as NSString)
                var userExist = false
                for member in self.model.userList {
                    if member.loginName == user.loginName {
                        userExist = true
                    }
                }
                if (!userExist) {
                    self.model.insertUser(user: user)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
                bill?.item.append(item)
            }
        }
        
        print(bill?.item.count)
    }

//    override func viewDidDisappear(_ animated: Bool) {
//        bill?.item = []
//    }
    
    @IBAction func unwindToBill(segue: UIStoryboardSegue) {}
    
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
                trimmedStrings.append((temp?.capitalized)!)
            }
        }
        return trimmedStrings
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
                    destination.model = model
                    destination.switchStatus = switchStatus
                    destination.photo = photo
                }
            }
        }
        
        if segue.identifier == "summarySegue" {
            if let destination = segue.destination as? SummaryViewController {
                print(bill!)
                destination.bill = bill!
                destination.model = model
                destination.switchStatus = switchStatus
                destination.photo = photo
            }
        }
        
        if let destination = segue.destination as? ScannerViewController {
            destination.bill.item = []
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

