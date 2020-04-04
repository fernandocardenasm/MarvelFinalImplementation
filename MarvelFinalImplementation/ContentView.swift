//
//  ContentView.swift
//  MarvelFinalImplementation
//
//  Created by Fernando Cardenas on 22.02.20.
//  Copyright © 2020 fernandocardenasm. All rights reserved.
//

import SwiftUI
import Combine
import FirebaseAuth

class LoginViewModel: ObservableObject {

    private let loginService: FirebaseLoginService = FirebaseLoginServiceImpl(auth: Auth.auth())

    // Input
    @Published var email = ""
    @Published var password = ""
    @Published var buttonPressed = false

    // Oupt
    @Published var buttonEnabled = false

    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        // Setup isValid
        Publishers.CombineLatest(areFieldsValidPublisher(), $buttonPressed).receive(on: RunLoop.main)
            .map { fieldsValid, pressed in
                fieldsValid && !pressed
        }
        .assign(to: \.buttonEnabled, on: self)
        .store(in: &cancellableSet)

        $buttonPressed.sink { [weak self] pressed in
            guard pressed else { return }

            self?.signIn()

        }
        .store(in: &cancellableSet)
    }

    func signIn() {
        loginService.signIn(withEmail: email, password: password).subscribe(on: DispatchQueue.global())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print("SignIn - Error: \(error)")
                }
                self?.buttonPressed = false
                },
                  receiveValue: { _ in

            })
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
            }
        .eraseToAnyPublisher()
    }
}

struct ActivityIndicator: UIViewRepresentable {
    @Binding var shouldAnimate: Bool

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        UIActivityIndicatorView()
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        shouldAnimate ? uiView.startAnimating() : uiView.stopAnimating()
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
                self.loginViewModel.buttonPressed = true
            }) {
                Text("Sign In")
            }.disabled(!loginViewModel.buttonEnabled)
            ActivityIndicator(shouldAnimate: $loginViewModel.buttonPressed)
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
