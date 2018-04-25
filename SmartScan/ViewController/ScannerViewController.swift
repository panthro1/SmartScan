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
    
    @IBOutlet weak var photo: UIImageView!
    let picker = UIImagePickerController()
    let bill = Bill()
    
    @IBAction func unwindToScanner(segue: UIStoryboardSegue) {}

    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = #imageLiteral(resourceName: "camera")
        picker.delegate = self
    }
    
    @IBAction func logOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
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
                destination.photo = photo
                destination.bill.item = []
             }
        }
    }

}

