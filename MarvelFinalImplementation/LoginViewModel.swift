//
//  SigninViewModel.swift
//  MarvelFinalImplementation
//
//  Created by Fernando Cardenas on 06.04.20.
//  Copyright © 2020 fernandocardenasm. All rights reserved.
//

import Combine
import FirebaseAuth

class LoginViewModel: ObservableObject {

    private let loginService: LoginService = FirebaseLoginServiceImpl(auth: Auth.auth())

    // Input
    @Published var email = ""
    @Published var password = ""
    @Published var signinButtonPressed = false

    // Oupt
    @Published var singinButtonEnabled = false
    var loginFinished = PassthroughSubject<Void, Never>()
    var signupButtonPressed = PassthroughSubject<Void, Never>()

    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        // Setup isValid
        Publishers.CombineLatest(areFieldsValidPublisher(), $signinButtonPressed).receive(on: RunLoop.main)
            .map { fieldsValid, pressed in
                fieldsValid && !pressed
            }
            .assign(to: \.singinButtonEnabled, on: self)
            .store(in: &cancellableSet)
        
        $signinButtonPressed.sink { [weak self] pressed in
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
                    print("Login Successful")
                    self?.loginFinished.send()
                case .failure(let error):
                    print("SignIn - Error: \(error)")
                }
                self?.signinButtonPressed = false
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
