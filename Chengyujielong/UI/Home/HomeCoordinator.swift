//
//  HomeCoordinator.swift
//  Chengyujielong
//
//  Created by yellow on 2020/9/8.
//  Copyright © 2020 Kaka. All rights reserved.
//

import Foundation
import Swinject


class HomeCoordinator: NavigationCoordinator {
    
    var navigationController: UINavigationController
    var container: Container
    
    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }
    
    func start() {
        let home = container.resolve(TestHomeViewController.self)!
        home.delegate = self
        navigationController.pushViewController(home, animated: true)
    }
    
}

extension HomeCoordinator: TestHomeViewControllerDelegate {
    
    func homeDidSign(controller: TestHomeViewController) {
//        let view = HomeSignView.init(frame: UIScreen.main.bounds)
//        _ = view.getOnlineTime()
//        PopView.show(view:view)
        
        PopView.show(view: HomeSignPopView())
    }
    
    func homeDidLottery(controller: TestHomeViewController) {
        
    }
    
    func homeDidHowPlay(controller: TestHomeViewController) {
        
        let howPlayView = HomeHowPlayView(frame: UIScreen.main.bounds)
        PopView.show(view: howPlayView)
    }
    
    func homeDidOpenRedBag(controller: TestHomeViewController) {
        PopView.show(view: OpenCoinRedBagView(action: {
            
        }))
    }
    
    func homeDidGetCash(controller: TestHomeViewController) {
        let getCash = container.resolve(GetCashViewController.self)!
        getCash.delegate = self
        navigationController.pushViewController(getCash)
    }
    
    
}

extension HomeCoordinator: HomeViewControllerDelegate {
    func homeShowAD(controller: HomeViewController) {
        
    }
    
        
    func homeDidGetCash(controller: HomeViewController) {
        let getCash = container.resolve(GetCashViewController.self)!
        navigationController.pushViewController(getCash)
    }
    
    func homeExchangeRadPacket(controller: HomeViewController) {
        PopView.show(view: OpenCoinRedBagView(action: {
            
        }))
    }
}

extension HomeCoordinator: GetCashViewControllerDelegate {
    
    func cashSelectedPlayMusic(controller: GetCashViewController) {
        navigationController.popViewController(animated: true)
    }
    
    func cashSelectedProtocol(controller: GetCashViewController) {
        let web = container.resolve(WebViewController.self)!
        web.url = NetAPI.getHtmlProtocol(type: .settlement)
        navigationController.pushViewController(web)
    }

    func cashSelectedRecord(controller: GetCashViewController) {
        let record = container.resolve(GetCashRecordViewController.self)!
        navigationController.pushViewController(record)
    }

}


