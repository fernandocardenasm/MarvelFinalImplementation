//
//  LoginService.swift
//  MarvelFinalImplementation
//
//  Created by Fernando Cardenas on 23.02.20.
//  Copyright © 2020 fernandocardenasm. All rights reserved.
//

import Combine
import FirebaseAuth
import Foundation

protocol FirebaseLoginService {
    func createUser(withEmail email: String, password: String) -> AnyPublisher<Void, Error>

    func signIn(withEmail email: String, password: String) -> AnyPublisher<Void, Error>

    func signOut() throws
}

struct FirebaseLoginServiceImpl<Authentication: FBAuth>: FirebaseLoginService {
    let auth: Authentication
    let appState: Store<AppState>

    init(auth: Authentication, appState: Store<AppState>) {
        self.auth = auth
        self.appState = appState
    }
    
    private var loggedIn: Bool {
        auth.currentUser != nil
    }
        
    func createUser(withEmail email: String, password: String) -> AnyPublisher<Void, Error> {
        Deferred {
            return Future<Void, Error> { promise in
                self.auth.createUser(withEmail: email.lowercased(), password: password) { (authDataResult, error) in
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
                        self.appState.value.login.loggedIn = self.loggedIn
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
        appState.value.login.loggedIn = loggedIn
    }
}

import SwiftUI

struct AppState {
    var login = Login()
}

extension AppState {
    struct Login {
        var loggedIn: Bool = Auth.auth().currentUser != nil
    }
}

struct DIContainer: EnvironmentKey {
    
    // Observations: - Not sure why we have default, if we could have private(set) defaultValue,
    // R/ So the container is init only once and not everytime we call defaultValue
    // - Maybe only init is enough
    
    let appState: Store<AppState>
    let interactors: Interactors
    
    static var defaultValue: Self { Self.default }
    
    private static let `default` = DIContainer(appState: AppState(), interactors: .stub)
    
    init(appState: Store<AppState>, interactors: DIContainer.Interactors) {
        self.appState = appState
        self.interactors = interactors
    }
    
    init(appState: AppState, interactors: DIContainer.Interactors) {
        self.init(appState: Store(appState), interactors: interactors)
    }
}

extension DIContainer {
    struct Interactors {
        static var stub: Self {
            .init()
        }
    }
}

typealias Store<State> = CurrentValueSubject<State, Never>

extension Store {
    subscript<T>(keyPath: WritableKeyPath<Output, T>) -> T where T: Equatable {
        get { value[keyPath: keyPath] }
        set {
            var value = self.value
            if value[keyPath: keyPath] != newValue {
                value[keyPath: keyPath] = newValue
                self.value = value
            }
        }
    }
}

extension EnvironmentValues {
    var injected: DIContainer {
        get { self [DIContainer.self] }
        set { self [DIContainer.self] = newValue}
    }
}
