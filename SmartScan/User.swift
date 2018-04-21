//
//  User.swift
//  SmartScan
//
//  Created by Carin Gan on 4/21/18.
//  Copyright © 2018 Carin Gan. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    var loginName: String? = ""
    var password: String? = ""
    var photo: UIImage = #imageLiteral(resourceName: "blank ")
    
    var bills: [Bill] = []

    func addBill(bill: Bill) {
        bills.append(bill)
    }
}
