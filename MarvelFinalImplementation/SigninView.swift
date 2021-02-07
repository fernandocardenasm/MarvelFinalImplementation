//
//  ContentView.swift
//  MarvelFinalImplementation
//
//  Created by Fernando Cardenas on 22.02.20.
//  Copyright © 2020 fernandocardenasm. All rights reserved.
//

import SwiftUI
import Combine
import Firebase


struct SigninView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @State var presentingSignUpView = false
    
    var body: some View {
        VStack {
            Text("Welcome to the Marvel World")
                .padding(.vertical, 60)
                .font(.marvelRegular)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            LoginFieldsView(email: $loginViewModel.email,
                            password: $loginViewModel.password)
                .padding(.horizontal, 60)

            Button("Sign In") {
                self.loginViewModel.signinButtonPressed = true
            }
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40)
            .background(Color.marvelBlue)
            .opacity(loginViewModel.singinButtonEnabled ? 1 : 0.3)
            .foregroundColor(.white)
            .cornerRadius(40)
            .padding(.vertical, 10)
            .padding(.horizontal, 60)
            .disabled(!loginViewModel.singinButtonEnabled)

            ActivityIndicator(shouldAnimate: $loginViewModel.signinButtonPressed)

            Text("Do not have an account?")
                .foregroundColor(.white)
                .padding()
            Button("Sign up here") {
                self.loginViewModel.signupButtonPressed.send()
            }
            Spacer()
        }
        .background(Color.marvelRed)
        .onAppear{ print("Appeared") }
    }
}

extension Font {
    static var marvelRegular: Font {
        Font.custom("Marvel-Regular", size: 30)
    }
}


extension Color {
    static var marvelRed: Color {
        Color(UIColor(red: 226/255.0, green: 54/255.0, blue: 54/255.0, alpha: 1.0))
    }

    static var marvelBlue: Color {
        Color(UIColor(red: 81/255.0, green: 140/255.0, blue: 202/255.0, alpha: 1.0))
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        SigninView()
//    }
//}
