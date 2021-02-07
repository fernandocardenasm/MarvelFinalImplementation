//
//  HomeView.swift
//  MarvelFinalImplementation
//
//  Created by Fernando Cardenas on 14.04.20.
//  Copyright © 2020 fernandocardenasm. All rights reserved.
//

import Combine
import FirebaseAuth
import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            Text("HomeView")
            .navigationBarItems(trailing:
                Button("logout") {
                    print("Tapped")
                    self.viewModel.buttonPressed.send(())
                }
            )
        }
    }
}

class HomeViewModel: ObservableObject {
    private let loginService: LoginService = FirebaseLoginServiceImpl(auth: Auth.auth())
    
    var buttonPressed = PassthroughSubject<Void, Never>()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        buttonPressed.sink { _ in
            do {
                try self.loginService.signOut()
                DIContainer.defaultValue.appState.value.login.loggedIn = DIContainer.defaultValue.appState.value.login.loggedIn
            }
            catch {
                
            }
        }.store(in: &cancellableSet)
    }
}


class LoginNavigationStore: ObservableObject {
    enum CurrentView {
        case signin
        case signup
    }
    
    @Published var currentView: CurrentView? = nil
    
    @ViewBuilder
    var view: some View {
        switch currentView {
        case .signin:
            SignupView()
        case .signup:
            SignupView()
        case .none:
            EmptyView()
        }
    }
}

struct LoginNavigationView: View {
    @ObservedObject var store: LoginNavigationStore
    
    var body: some View {
        store.view
            .transition(AnyTransition
                            .opacity
                            .combined(with: .move(edge: .trailing))
        ).id(UUID())
    }
}
