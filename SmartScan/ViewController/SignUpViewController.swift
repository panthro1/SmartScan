//
//  SignUpViewController.swift
//  SmartScan
//
//  Created by Carin Gan on 4/21/18.
//  Copyright © 2018 Carin Gan. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var loginName: UITextField!
    @IBOutlet weak var password: UITextField!
    var collision = false
    
    var user: User?
    let model = Database()
    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = #imageLiteral(resourceName: "blank ")
        picker.delegate = self
        self.photo.layer.cornerRadius = self.photo.frame.size.width / 2
        self.photo.clipsToBounds = true
    }

    func nameCollision() {
        for user in model.userList {
            if (loginName!.text! == user.loginName) {
                collision = true
            }
            else {
                collision = false
            }
        }
    }
    
    // Camera action
    @IBAction func didTap(_ sender: Any) {
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
        if segue.identifier == "signUpSegue" {
            if let destination = segue.destination as? HomeViewController {
                destination.username = loginName.text!
                destination.hi.text = "Hi, " + loginName.text! + "!"
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "signUpSegue" {
            if (loginName!.text!.isEmpty) {
                let alert  = UIAlertController(title: "Warning", message: "Login Name is empty", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            }
            
            if (password!.text!.isEmpty) {
                let alert  = UIAlertController(title: "Warning", message: "Password is empty", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            }
            
            nameCollision()
            
            if (collision == true) {
                let alert  = UIAlertController(title: "Warning", message: "Login Name already been used", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            }
            
            else {
                self.user = User()
                user?.loginName = loginName.text!
                user?.password = password.text!
                user?.photo = photo.image!
                model.addUser(user: user!)
                return true
            }
        }
        return true
    }
}
