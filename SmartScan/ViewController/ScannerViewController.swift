//
//  ScannerViewController.swift
//  SmartScan
//
//  Created by Carin Gan on 4/21/18.
//  Copyright © 2018 Carin Gan. All rights reserved.
//

import UIKit
import TesseractOCR
import FirebaseAuth

class ScannerViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate {

    var username: String?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var photo: UIImageView!
    let picker = UIImagePickerController()
    let bill = Bill()

    var results : [String] = []
    var prices : [String] = []
    var itemName : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = #imageLiteral(resourceName: "receipt2")
        picker.delegate = self
        
        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.delegate = self
            tesseract.image = photo?.image?.g8_blackAndWhite()
            tesseract.recognize()
            textView.text = tesseract.recognizedText
            print(tesseract.recognizedText)
        }
        
        let results = textView.text.regex()
        print(results)
        
        for item in results {
            prices = prices + item.getPrice()
            itemName = itemName + item.getItem()
        }
    
        print(itemName)
        print(prices)

        for i in 0...results.count - 1 {
            let item = Item()
            item.member = []
            item.name = itemName[i]
            item.price = prices[i]
            bill.item.append(item)
        }
        
        print(bill.item.count)
    }
    
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        print("Recognition progress \(tesseract.progress)%")
    }
    
    //Camera
    @IBAction func didTapImage(_ sender: Any) {
        let alertController = UIAlertController(title: "Media Types", message: "Select the media source for your image", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            _ in
        }
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) {
            _ in
            self.library()
        }
        
        let photoAlbumAction = UIAlertAction(title: "Saved Photo Album", style: .default) {
            _ in
            self.library()
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {
            _ in
            self.camera()
        }
        
        alertController.addAction(libraryAction)
        alertController.addAction(photoAlbumAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func camera() {
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func library() {
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func album() {
        picker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.photo.image = chosenImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "billSegue" {
            if let destination = segue.destination as? BillViewController {
                destination.bill = bill
            }
        }
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
        let pat = "([^\\d\\W]?)+[ ]\\w+[ ]"
        
        
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

