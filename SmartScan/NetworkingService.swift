//
//  NetworkingService.swift
//  SmartScan
//
//  Created by Carin Gan on 4/23/18.
//  Copyright © 2018 Carin Gan. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

struct NetworkingService {
//    let ref = Database.database().reference()
//    let storageRef = Storage.storage().reference()
//
//    func saveInfo(user: User!, username: String, password: String) {
//        let userInfo = ["email": user.email!, "username": username, "password": password, "photoUrl": String(user.photoURL!)]
//        let userRef = ref.child("users").childByAutoId()
//        userRef.setValue(userInfo)
//
//        signIn(email: user.email!, password: password)
//    }
//
//    func signIn(email: String, password: String) {
//        Auth.auth()?.signInWithEmail(email, password: password, completion {(user, error) in
//            if error == nil {
//                if let user = user {
//                    print("user signed in successfully")
//                }
//            }
//            else print(error!.LocalizedError)
//        })
//    }
//
//    func setUserInfo(user: User!, username: String!, password: password, data: NSData!) {
//        let imagePath = "profileImage\(user.uid)/userPic.jpg"
//        let imageRef = storageRef.child(imagePath)
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpeg"
//        imageRef.putData(data, metadata: metaData) { (metaData, error} in
//        if error == nil {
//            let changeRequest =
//        }
//        else print(error!.LocalizedError)
//
//    }
}
