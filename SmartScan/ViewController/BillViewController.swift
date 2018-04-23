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

class BillViewController: UIViewController, G8TesseractDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var photo: UIImageView?
    @IBOutlet weak var tableView: UITableView!
    var textView: UITextView!
    var results : [String] = []
    var prices : [String] = []
    var itemName : [String] = []
    
    let model = InnerDatabase()
    var username : String?
    
    @IBOutlet weak var mySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.delegate = self
            tesseract.image = photo?.image?.g8_blackAndWhite()
            tesseract.recognize()
            textView.text = tesseract.recognizedText
            print(tesseract.recognizedText)
        }
        
        let regex = textView.text.regex()
        print(regex)
        let regex2 = textView.text.regex2()
        print(regex2)
        let regex3 = textView.text.regex3()
        print(regex3)
        
        results = results + regex + regex2 + regex3
        print(results)
        
        for item in results {
            prices = prices + item.getPrice()
            itemName = itemName + item.getItem()
            
        }
        print(itemName)
        print(prices)
    }
    
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        print("Recognition progress \(tesseract.progress)%")
    }
    
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false // return true if you need to interrupt tesseract before it finishes
    }

    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath)
        cell.textLabel?.text = itemName[indexPath.row]
        cell.detailTextLabel?.text = prices[indexPath.row]
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemSegue" {
            if let destination = segue.destination as? ItemViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    destination.item = itemName[indexPath.row]
                    destination.price = prices[indexPath.row]
                }
                if mySwitch.isOn {
//                    if let user = model.getUser(name: username!) {
//                        destination.users.append(user)
//                    }
                }
            }
        }
    }
    
}

extension String {
    func regex() -> [String]
    {
        let pat = "([^\\d\\W]?)+[ ]+([^\\d\\W]?)+[ ]\\w+[ ]\\d+\\‘\\d\\d"
        
        do {
            let string = self as NSString
            let regex = try NSRegularExpression(pattern: pat, options: .caseInsensitive)
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range).replacingOccurrences(of: "‘", with: ".").lowercased()
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return[]
        }
    }
    
    func regex2() -> [String]
    {
        let pat = "([^\\d\\W]?)+[ ]+([^\\d\\W]?)+[ ]\\w+[ ]\\d+\\,\\d\\d"
        
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
    
    func regex3() -> [String]
    {
        let pat = "([^\\d\\W]?)+[ ]+([^\\d\\W]?)+[ ]\\w+[ ]\\d+\\.\\d\\d"
        
        
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
        let pat = "\\d+\\.\\d\\d"
        
        
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
        let pat = "([^\\d\\W]?)+[ ]+([^\\d\\W]?)+[ ]\\w+[ ]"
        
        
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


