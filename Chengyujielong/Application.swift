//
//  Application.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import Swinject
import RxCocoa
import RxSwift
//import YLUISDK


final class Application: NSObject {
    
    static let shared = Application()
    internal let container = Container()
    private var appCoordinator: Coordinator!
    var window: UIWindow!
    
    func configureDependencies() {
        
        container.register(LaunchViewController.self) { r in
            let c = LaunchViewController()
            return c
        }
        
        container.register(HomeViewController.self) { r in
            let c = HomeViewController()
//            c.viewModel = r.resolve(HomeViewModel.self)!
            return c
        }
        
        container.register(TestHomeViewController.self) { r in
            let c = TestHomeViewController()
            return c
        }
        
        container.register(CashViewModel.self) { r in
            let vm = CashViewModel()
            return vm
        }
        container.register(GetCashViewController.self) { r in
            let cash = GetCashViewController()
            cash.viewModel = r.resolve(CashViewModel.self)!
            return cash
        }

        container.register(GetCashRecordViewController.self) { r in
            let record = GetCashRecordViewController()
            return record
        }
        
        /// 网页
        container.register(WebViewController.self) { r in
            return WebViewController()
        }

    }
    
    func configureMainInterface(in window: UIWindow) {
        
        let launch = container.resolve(LaunchViewController.self)!
        launch.completion = { [weak self] in
            guard let self = self else { return }
            let nav = NavigationController()
            self.appCoordinator = HomeCoordinator(container: self.container, navigationController: nav)
            self.appCoordinator.start()
            window.rootViewController = nav
        }
        window.rootViewController = launch
        
    }
    
    
}

