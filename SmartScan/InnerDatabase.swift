//
//  InnerDatabase.swift
//  
//
//  Created by Carin Gan on 4/22/18.
//

import Foundation

class InnerDatabase: NSObject {
    var userList: [User] = []
    
    func addUser(user: User) {
        userList.append(user)
    }
    
//    func getUser(name: String) -> User? {
//        for user in userList {
//            if user.loginName == name {
//                return user
//            }
//        }
//        return nil
//    }
}

