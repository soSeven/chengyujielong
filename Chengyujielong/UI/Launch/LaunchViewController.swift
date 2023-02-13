//
//  LaunchViewController.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/14.
//  Copyright © 2020 LQ. All rights reserved.
//

import UIKit
import SwiftEntryKit
//import BUAdSDK
import RxSwift

class LaunchViewController: ViewController {
    
    var completion: (()->())?
    private var loading = false
    
//    var ad: BUSplashAdView!
    
    let key = "app_auth_key_1"

    override func viewDidLoad() {
        super.viewDidLoad()
        if let launchView = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "LaunchScreen").view {
            view.addSubview(launchView)
            launchView.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
        
        login()
        
    }
    
    private func login() {
        SwiftEntryKit.dismiss()
        self.loading = true
//        let zip = Observable.zip(UserManager.shared.loginUser().asObservable(), addAd().asObservable())
//        UserManager.shared.loginUser().asObservable().subscribe(onNext: {[weak self] u in
//            guard let self = self else { return }
            self.loading = false
            if let _ = UserDefaults.standard.object(forKey: self.key) {
                self.completion?()
            } else {
                PopView.show(view: AuthPopView(action: {[weak self] in
                    guard let self = self else { return }
                    UserDefaults.standard.set(self.key, forKey: self.key)
                    self.completion?()
                }), needAd: false, needNav: true)
            }
//        }, onError: { _ in
//            self.loading = false
//            let message = MessageAlert()
//            let title = "温馨提示"
//            let text = "请求网络失败，请检查网络是否连接"
//            message.titleLbl.text = title
//            message.msgLbl.text = text
//            message.show()
//            message.leftBtn.rx.tap.subscribe(onNext: {[weak self] _ in
//                guard let self = self else { return }
//                self.login()
//            }).disposed(by: self.rx.disposeBag)
//            message.rightBtn.rx.tap.subscribe(onNext: { _ in
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//                } else {
//                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
//                }
//            }).disposed(by: self.rx.disposeBag)
//        }).disposed(by: rx.disposeBag)
    }
    
//    private func addAd() -> Single<BUSplashAdView?> {
//        return Single<BUSplashAdView?>.create { [weak self] single -> Disposable in
//            guard let self = self else {
//                single(.success(nil))
//                return Disposables.create()
//            }
//            guard let _ = UserDefaults.standard.object(forKey: self.key) else {
//                single(.success(nil))
//                return Disposables.create()
//
//            }
//            let ad = BUSplashAdView(slotID: "887387439", frame: .init(x: 0, y: 0, width: UIDevice.screenWidth, height: UIDevice.screenHeight - 97 - UIDevice.safeAreaBottom))
//            ad.rootViewController = self
//            ad.loadAdData()
//            ad.backgroundColor = .clear
//            self.view.addSubview(ad)
//            ad.rx.didCompleteWithError.subscribe(onNext: { error in
//                single(.success(ad))
//            }).disposed(by: self.rx.disposeBag)
//            ad.rx.didCompleteWithAuthorization.subscribe(onNext: { error in
//                single(.success(nil))
//            }).disposed(by: self.rx.disposeBag)
//            return Disposables.create()
//        }
//    }

}
