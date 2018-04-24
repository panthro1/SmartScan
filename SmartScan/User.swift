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
    var loginName: NSString? = ""
    var password: NSString? = ""
    var photo: UIImage = #imageLiteral(resourceName: "blank ")
    var payment: Decimal? = 0
    
    init(loginName: NSString) {
        self.loginName = loginName
    }
}
