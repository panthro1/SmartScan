//
//  ViewController.swift
//  SmartScan
//
//  Created by Carin Gan on 4/20/18.
//  Copyright © 2018 Carin Gan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var login_button: UIButton!
    @IBOutlet weak var signup_button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login_button.backgroundColor = UIColor(red: 248/255, green: 249/255, blue: 211/255, alpha: 1)
        signup_button.backgroundColor = UIColor(red: 248/255, green: 249/255, blue: 211/255, alpha: 1)
        login_button.layer.cornerRadius = 20
        signup_button.layer.cornerRadius = 20
    }

}

