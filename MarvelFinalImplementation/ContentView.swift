//
//  ContentView.swift
//  MarvelFinalImplementation
//
//  Created by Fernando Cardenas on 22.02.20.
//  Copyright © 2020 fernandocardenasm. All rights reserved.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    // Input
    @Published var email = ""
    @Published var password = ""

    // Oupt
    @Published var isValid = false

    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        // Setup isValid
        areFieldsValidPublisher().receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: \.isValid, on: self)
        .store(in: &cancellableSet)
    }

    func isEmailValidPublisher() -> AnyPublisher<Bool, Never> {
        $email.debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                input.count > 5
        }
        .eraseToAnyPublisher()
    }

    func isPasswordValidPublisher() -> AnyPublisher<Bool, Never> {
        $password.debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                input.count > 5
        }.eraseToAnyPublisher()
    }

    func areFieldsValidPublisher() -> AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isEmailValidPublisher(), isPasswordValidPublisher()).debounce(for: 0.2, scheduler: RunLoop.main)
            .map { emailValid, passwordValid in
                return emailValid && passwordValid
            }.print()
        .eraseToAnyPublisher()
    }
}

struct ContentView: View {
    @ObservedObject private var loginViewModel = LoginViewModel()

    var body: some View {
        VStack {
            Text("Sign In")
            TextField("Enter your email...", text: $loginViewModel.email)
            TextField("Enter your password...", text: $loginViewModel.password)
            Button(action: {
                print("tapped!")
            }) {
                Text("Sign In")
            }.disabled(!loginViewModel.isValid)
        }
    }

    func sigIn() {

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
