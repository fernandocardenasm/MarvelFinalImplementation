//
//  SignupViewModel.swift
//  MarvelFinalImplementation
//
//  Created by Fernando Cardenas on 06.04.20.
//  Copyright © 2020 fernandocardenasm. All rights reserved.
//

import Combine
import FirebaseAuth

class SignUpViewModel: ObservableObject {

    private let loginService: LoginService = FirebaseLoginServiceImpl(auth: Auth.auth())

    // Input
    @Published var email = ""
    @Published var password = ""
    @Published var buttonPressed = false

    // Oupt
    @Published var buttonEnabled = false
    @Published var signUpSuccess = false

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

            self?.signup()
        }
        .store(in: &cancellableSet)
    }

    func signup() {
        loginService.createUser(withEmail: email, password: password).subscribe(on: DispatchQueue.global())
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { [weak self] result in
            switch result {
            case .finished:
                self?.signUpSuccess = true
            case .failure(let error):
                self?.signUpSuccess = false
                print("SignUp - Error: \(error)")
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
        Publishers.CombineLatest(isEmailValidPublisher(),
                                 isPasswordValidPublisher())
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { emailValid, passwordValid in
                return emailValid && passwordValid
            }
            .eraseToAnyPublisher()
    }
}
