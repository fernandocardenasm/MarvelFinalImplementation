//
//  ContentView.swift
//  MarvelFinalImplementation
//
//  Created by Fernando Cardenas on 22.02.20.
//  Copyright © 2020 fernandocardenasm. All rights reserved.
//

import SwiftUI
import Combine


struct SigninView: View {
    @ObservedObject private var loginViewModel = LoginViewModel()
    @State var presentingSignUpView = false

    var body: some View {
        VStack {
            Text("Sign In")
            TextField("Enter your email...", text: $loginViewModel.email)
            TextField("Enter your password...", text: $loginViewModel.password)
            Button("Sign In") {
                self.loginViewModel.buttonPressed = true
            }.disabled(!loginViewModel.buttonEnabled)

            ActivityIndicator(shouldAnimate: $loginViewModel.buttonPressed)

            Button("Sign up") {
                self.presentingSignUpView = true
            }.sheet(isPresented: $presentingSignUpView) {
                SignupView(presentedAsModal: self.$presentingSignUpView)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
    }
}
