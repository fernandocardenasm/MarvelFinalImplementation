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
    private let loginService: FirebaseLoginService = FirebaseLoginServiceImpl(auth: Auth.auth(), appState: DIContainer.defaultValue.appState)
    
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
