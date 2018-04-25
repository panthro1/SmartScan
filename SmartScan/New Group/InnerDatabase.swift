//
//  InnerDatabase.swift
//  
//
//  Created by Carin Gan on 4/22/18.
//

import Foundation

class InnerDatabase: NSObject {
    var userList: [User] = []
    
    func insertUser(user: User) {
        userList.append(user)
    }
}

