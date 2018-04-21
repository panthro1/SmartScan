//
//  Database.swift
//  SmartScan
//
//  Created by Carin Gan on 4/21/18.
//  Copyright © 2018 Carin Gan. All rights reserved.
//

import Foundation

class Database: NSObject {
    var userList: [User] = []
    
    func addUser(user: User) {
        userList.append(user)
        userList.sort(by: { $0.loginName! < $1.loginName! })
    }
}

