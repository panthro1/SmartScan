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
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        self.navigationController?.isNavigationBarHidden = true
        login_button.backgroundColor = UIColor(red: 239/255, green: 250/255, blue: 250/255, alpha: 1)
        signup_button.backgroundColor = UIColor(red: 239/255, green: 250/255, blue: 250/255, alpha: 1)
        login_button.layer.cornerRadius = 20
        signup_button.layer.cornerRadius = 20
        login_button.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        signup_button.contentVerticalAlignment = UIControlContentVerticalAlignment.center

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
}

