//
//  FBAuthentication.swift
//  MarvelFinalImplementation
//
//  Created by Fernando Cardenas on 22.02.20.
//  Copyright © 2020 fernandocardenasm. All rights reserved.
//

import FirebaseAuth

protocol FBAuth {
    associatedtype EndUser: FBUser
    associatedtype DataResult: FBAuthDataResult
    typealias DataResultCallback = (DataResult?, Error?) -> Void

    var currentUser: EndUser? { get }

    func createUser(withEmail email: String, password: String, completion: DataResultCallback?)

    func signIn(withEmail email: String, password: String, completion: DataResultCallback?)

    func signOut() throws    
}

extension Auth: FBAuth {}

protocol FBUser {
    var isAnonymous: Bool { get }
}

extension User: FBUser {}

protocol FBAuthDataResult {
    associatedtype EndUser: FBUser
    var user: EndUser { get }
}

extension AuthDataResult: FBAuthDataResult {}

