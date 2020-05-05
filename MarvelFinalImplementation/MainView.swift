//
//  MainView.swift
//  MarvelFinalImplementation
//
//  Created by Fernando Cardenas on 16.04.20.
//  Copyright © 2020 fernandocardenasm. All rights reserved.
//

import Combine
import SwiftUI

struct MainView: View {
    enum Page: String {
        case signin
        case home
    }
    
    private let appState = DIContainer.defaultValue.appState
    private var cancellableSet: Set<AnyCancellable> = []
    
    @ObservedObject var viewRouter = ViewRouter()
    

    var body: some View {
        VStack {
            something()
        }
    }
    
    func something() -> some View {
        switch viewRouter.page {
        case .home:
            return AnyView(HomeView())
        case .signin:
            return AnyView(SigninView())
        }
    }
}

import FirebaseAuth

class ViewRouter: ObservableObject {

    enum Page: String {
        case signin
        case home
    }

    private let appState = DIContainer.defaultValue.appState
    private var cancellableSet: Set<AnyCancellable> = []

    @Published var page: Page = .signin

    init() {
        appState
            .receive(on: RunLoop.main)
            .sink { state in
                self.page = state.login.loggedIn ? .home : .signin
        }.store(in: &cancellableSet)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
