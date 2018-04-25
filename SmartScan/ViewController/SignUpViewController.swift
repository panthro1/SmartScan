//
//  SignUpViewController.swift
//  SmartScan
//
//  Created by Carin Gan on 4/21/18.
//  Copyright © 2018 Carin Gan. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var loginName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    private let refUser = Database.database().reference(withPath: "Users")
    
    var user: User?
    let model = InnerDatabase()
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        photo.image = #imageLiteral(resourceName: "blank ")
        picker.delegate = self
        self.photo.layer.cornerRadius = self.photo.frame.size.width / 2
        self.photo.clipsToBounds = true
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let user = user {
                print("Sign Up Successfully. \(user.uid)")
                let newUser = User(loginName: (self.loginName.text!.capitalized) as NSString, email: (self.email.text!) as NSString)
                let newUserArray = ["loginName": newUser.loginName as! NSString, "email": newUser.email]
                let userRef = self.refUser.child((Auth.auth().currentUser?.uid)!)
                userRef.setValue(newUserArray)
            }
        }
    }
    
    // Camera action
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
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
            self.album()
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
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "signUpSegue" {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let correctFormat = emailTest.evaluate(with: email!.text!)
            
            if (!correctFormat) {
                let alert  = UIAlertController(title: "Warning", message: "Incorrect email format", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            }
            
            
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
            
            if (password!.text!.count < 6) {
                let alert  = UIAlertController(title: "Warning", message: "Password less than 6 characters", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
}
