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
            Text("Welcome to the Marvel world")
                       .padding()
                       .font(.largeTitle)
                       .foregroundColor(.white)
                .multilineTextAlignment(.center)

            LoginFieldsView(email: $loginViewModel.email, password: $loginViewModel.password)
                .padding(.horizontal, 60)

            Button("Sign In") {
                self.loginViewModel.buttonPressed = true
            }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(40)
                .padding(.vertical, 10)
                .padding(.horizontal, 60)

            .disabled(!loginViewModel.buttonEnabled)

            ActivityIndicator(shouldAnimate: $loginViewModel.buttonPressed)

            Text("Do not have an account?").foregroundColor(.white).padding()
            Button("Sign up here") {
                self.presentingSignUpView = true
            }.sheet(isPresented: $presentingSignUpView) {
                SignupView(presentedAsModal: self.$presentingSignUpView)
            }
            Spacer()
        }.background(Color.red)
    }
}

struct LoginButtonStyle: ButtonStyle {

    @Binding var enabled: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
      configuration.label
        .background(background(configuration: configuration))
        .foregroundColor(.white)
        .cornerRadius(40)
        .padding(.vertical, 10)
        .padding(.horizontal, 60)
    }

    func background(configuration: Self.Configuration) -> Color {
        if configuration.isPressed {
            return Color.orange
        } else if enabled {
            return Color.blue
        } else {
            return Color.gray
        }
    }
}

struct LoginFieldsView: View {
    @Binding var email: String
    @Binding var password: String

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.circle")
                TextField("Enter your email...", text: $email)
                    .foregroundColor(.white)
            }.padding(.vertical, 10)

            HStack {
                Image(systemName: "lock.circle")
                TextField("Enter your password...", text: $password)
                    .foregroundColor(.white)
            }
                .padding(.vertical, 10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
    }
}
