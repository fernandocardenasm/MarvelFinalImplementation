//
//  LoginService.swift
//  MarvelFinalImplementation
//
//  Created by Fernando Cardenas on 23.02.20.
//  Copyright © 2020 fernandocardenasm. All rights reserved.
//

import Combine
import Foundation

protocol FirebaseLoginService {
    var isLoggedIn: Bool { get }

    func createUser(withEmail email: String, password: String) -> AnyPublisher<Void, Error>

    func signIn(withEmail email: String, password: String) -> AnyPublisher<Void, Error>

    func signOut() throws
}

class FirebaseLoginServiceImpl<Authentication: FBAuth>: FirebaseLoginService {
    let auth: Authentication

    init(auth: Authentication) {
        self.auth = auth
    }

    var isLoggedIn: Bool {
        auth.currentUser != nil
    }

    func createUser(withEmail email: String, password: String) -> AnyPublisher<Void, Error> {
        Deferred { [auth] in
            return Future<Void, Error> { promise in
                auth.createUser(withEmail: email.lowercased(), password: password) { (authDataResult, error) in
                    if let error = error {
                        promise(.failure(error))
                    }
                    else if let _ = authDataResult {
                        promise(.success(()))
                    }
                    else {
                        promise(.failure(NSError(domain: "", code: 100, userInfo: nil)))
                        print("This is an unknown error for createUser")
                    }
                }
            }
        }.eraseToAnyPublisher()
    }

    func signIn(withEmail email: String, password: String) -> AnyPublisher<Void, Error> {

        Deferred { [auth] in
            return Future<Void, Error> { promise in
                auth.signIn(withEmail: email.lowercased(), password: password) { (authDataResult, error) in
                    if let error = error {
                        promise(.failure(error))
                    }
                    else if let _ = authDataResult {
                        promise(.success(()))
                    }
                    else {
                        promise(.failure(NSError(domain: "", code: 100, userInfo: nil)))
                        print("This is an unknown error for createUser")
                    }
                }
            }
        }.eraseToAnyPublisher()
    }

    func signOut() throws {
        try auth.signOut()
    }
}
