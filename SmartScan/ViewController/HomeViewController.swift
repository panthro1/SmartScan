//
//  HomeViewController.swift
//  SmartScan
//
//  Created by Carin Gan on 4/21/18.
//  Copyright © 2018 Carin Gan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    var username: String?
    @IBOutlet weak var hi: UILabel!
    
    var photo: UIImageView!
    let picker = UIImagePickerController()
    @IBOutlet weak var tableView: UITableView!
    
    let database = Database()
    var user = User()
    var bills: [Bill] = []
    var bill: Bill?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for currentUser in database.userList {
            if username == currentUser.loginName {
                user = currentUser
                bills = currentUser.bills
            }
        }
        tableView.dataSource = self
        tableView.delegate = self
        picker.delegate = self
    }
    
    //Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)
        cell.textLabel?.text = bills[indexPath.row].date
        cell.detailTextLabel?.text = bills[indexPath.row].total
        return cell
    }
    
    //Scanner
    @IBAction func didTapScanner(_ sender: Any) {
        let alertController = UIAlertController(title: "Media Types", message: "Select the media source for your profile picture", preferredStyle: .alert)
        
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
        if segue.identifier == "scannerSegue" {
            if let destination = segue.destination as? ScannerViewController {
                destination.photo.image = photo.image
            }
        }
        
        if segue.identifier == "historySegue" {
            if let destination = segue.destination as? HistoryViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    destination.bill = bills[indexPath.row]
                }
            }
        }
    }

}
