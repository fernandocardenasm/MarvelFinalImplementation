//
//  ViewControllerFactory.swift
//  MarvelFinalImplementation
//
//  Created by Fernando Cardenas on 25.01.21.
//  Copyright © 2021 fernandocardenasm. All rights reserved.
//

import Combine
import Firebase
import UIKit
import SwiftUI

protocol ViewControllerFactory {
    
    func homeViewController() -> UIViewController
    
//    func signInViewController() -> UIViewController
    
    func signUpViewController() -> UIViewController
}

final class SwiftUIFactory: ViewControllerFactory {
    func homeViewController() -> UIViewController {
        UIHostingController(rootView: HomeView())
    }

//    func signInViewController() -> UIViewController {
//        UIHostingController(rootView: SigninView())
//    }

    func signUpViewController() -> UIViewController {
        UIHostingController(rootView: SignupView())
    }
}

final class SwiftUINavigationAdapter {
    private let navigation: LoginNavigationStore
    
    init(navigation: LoginNavigationStore) {
        self.navigation = navigation
    }
    
    func startSignin() {
        withAnimation {
            navigation.currentView = .signin
        }
    }
    
    func startSignup() {
        withAnimation {
            navigation.currentView = .signup
        }
    }
}

final class NavigationControllerRouter {
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func startSignin() {
        let viewModel = LoginViewModel()
        var view = SigninView(loginViewModel: viewModel)
        
        viewModel.loginFinished.sink {
            print("Login finished")
        }
        .store(in: &cancellableSet)
        
        viewModel.signupButtonPressed.sink { [weak self] in
            self?.startSignup()
        }
        .store(in: &cancellableSet)
        
        let controller = UIHostingController(rootView: view)
        show(controller)
    }
    
    func startSignup() {
        var view = SignupView()
        let viewModel = SignUpViewModel()
        view.signupViewModel = viewModel
        
        let controller = UIHostingController(rootView: view)
        show(controller)
    }
    
    private func show(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension View {

    func onNavigation(_ action: @escaping () -> Void) -> some View {
        let isActive = Binding(
            get: { false },
            set: { newValue in
                if newValue {
                    action()
                }
            }
        )
        return NavigationLink(
            destination: EmptyView(),
            isActive: isActive
        ) {
            self
        }
    }

    func navigation<Item, Destination: View>(
        item: Binding<Item?>,
        @ViewBuilder destination: (Item) -> Destination
    ) -> some View {
        let isActive = Binding(
            get: { item.wrappedValue != nil },
            set: { value in
                if !value {
                    item.wrappedValue = nil
                }
            }
        )
        return navigation(isActive: isActive) {
            item.wrappedValue.map(destination)
        }
    }

    func navigation<Destination: View>(
        isActive: Binding<Bool>,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        overlay(
            NavigationLink(
                destination: isActive.wrappedValue ? destination() : nil,
                isActive: isActive,
                label: { EmptyView() }
            )
        )
    }

}

extension NavigationLink {

    init<T: Identifiable, D: View>(item: Binding<T?>,
                                   @ViewBuilder destination: (T) -> D,
                                   @ViewBuilder label: () -> Label) where Destination == D? {
        let isActive = Binding(
            get: { item.wrappedValue != nil },
            set: { value in
                if !value {
                    item.wrappedValue = nil
                }
            }
        )
        self.init(
            destination: item.wrappedValue.map(destination),
            isActive: isActive,
            label: label
        )
    }

}


protocol BaseCoordinator {
    func start()
}

extension BaseCoordinator {
    func coordinate(to coordinator: BaseCoordinator) {
        coordinator.start()
    }
}

final class AppCoordinator: BaseCoordinator {
    private weak var window: UIWindow?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let coordinator = RootMasterCoordinator(window: window)
        coordinate(to: coordinator)
    }
}

final class RootMasterCoordinator: BaseCoordinator {
    private weak var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        let navController = UINavigationController()
        let loginCoordinator = NavigationControllerRouter(navController, factory: SwiftUIFactory())
        loginCoordinator.startSignin()

        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
    }
    
    func showSignup() {
        
    }
}
