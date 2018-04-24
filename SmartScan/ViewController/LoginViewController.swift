//
//  LoginViewController.swift
//  SmartScan
//
//  Created by Carin Gan on 4/21/18.
//  Copyright © 2018 Carin Gan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    var notUser = true
    var matchPassword = false
    
    let model = InnerDatabase()
    var handle : DatabaseHandle?
    var loginError : String?
    

    @IBAction func didTapLogin(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!, completion: {(user, error) in
            if user != nil {
                print("sign in successful")
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
            else {
                let currentError = error?.localizedDescription
                print(currentError!)
                let alert  = UIAlertController(title: "Warning", message: "Error: \(currentError!)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
