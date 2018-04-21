//
//  LoginViewController.swift
//  SmartScan
//
//  Created by Carin Gan on 4/21/18.
//  Copyright © 2018 Carin Gan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginName: UITextField!
    @IBOutlet weak var password: UITextField!
    var notUser = true
    var matchPassword = false
    
    let model = Database()
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notUser = true
        matchPassword = false
    }
    
    func checkUser() {
        for user in model.userList {
            if (loginName!.text! == user.loginName) {
                notUser = false
            }
        }
    }
    
    func passwordMatch() {
        for user in model.userList {
            if (loginName!.text! == user.loginName) {
                if (password!.text! == user.password) {
                    matchPassword = true
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            if let destination = segue.destination as? HomeViewController {
                destination.username = loginName.text!
                destination.hi.text = "Hi, " + loginName.text! + "!"
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "loginSegue" {
            checkUser()
            passwordMatch()
            
            if (notUser == true) {
                let alert  = UIAlertController(title: "Warning", message: "Not a user", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            }
            
            if (matchPassword == false) {
                let alert  = UIAlertController(title: "Warning", message: "Login Name and Password Unmatch", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        return true
    }

}
