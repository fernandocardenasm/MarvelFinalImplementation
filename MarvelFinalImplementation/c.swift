//
//  ViewControllerFactory.swift
//  MarvelFinalImplementation
//
//  Created by Fernando Cardenas on 25.01.21.
//  Copyright © 2021 fernandocardenasm. All rights reserved.
//

import Firebase
import UIKit
import SwiftUI

protocol ViewControllerFactory {
    
    func homeViewController() -> UIViewController
    
    func signInViewController() -> UIViewController
    
    func signUpViewController() -> UIViewController
}

final class SwiftUIFactory: ViewControllerFactory {
    func homeViewController() -> UIViewController {
        UIHostingController(rootView: HomeView())
    }
    
    func signInViewController() -> UIViewController {
        UIHostingController(rootView: SigninView())
    }
    
    func signUpViewController() -> UIViewController {
        UIHostingController(rootView: SignupView())
    }
}

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let loginCoordinator = LoginCoordinator(
            navController: navigationController,
            factory: SwiftUIFactory(),
            loginService: FirebaseLoginServiceImpl(auth: FirebaseAuth.Auth.auth())
        )
        loginCoordinator.start()
    }
}

final class LoginCoordinator {
    
    private weak var navController: UINavigationController?
    private let factory: ViewControllerFactory
    private let loginService: FirebaseLoginService
    
    init(navController: UINavigationController,
         factory: ViewControllerFactory,
         loginService: FirebaseLoginService) {
        self.navController = navController
        self.factory = factory
        self.loginService = loginService
    }
    
    func start() {
        if loginService.loggedIn {
            show(factory.homeViewController())
        } else {
            show(factory.signInViewController())
        }
    }
    
    private func show(_ viewController: UIViewController) {
        navController?.pushViewController(viewController, animated: true)
    }
}
