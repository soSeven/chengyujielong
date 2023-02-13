//
//  UserManager.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/15.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import NSObject_Rx

enum UserLoginType {
    case phone(mobile: String, code: String)
    case aliAu(token: String)
    case wechat(openId: String, nickName: String, avatar: String, sex: Int)
    case apple(openId: String, nickName: String)
}

enum LoginStatus: Int {
    case notLogin
    case login
    case change
    case loginOut
}

class UserManager: NSObject {
    
    static let shared = UserManager()
    
    let login = BehaviorRelay<(UserModel?, LoginStatus)>(value: (nil, .loginOut))
    
    private let loading = ActivityIndicator()
    
    private let parsedError = PublishSubject<NetError>()
    private let error = ErrorTracker()
    
    private let onView = UIApplication.shared.keyWindow
    
    private let userPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "") + "/userinfo"
    
    var isLogin: Bool {
        let s = login.value
        return s.1 != .loginOut && s.1 != .notLogin
    }
    
    var isCheck: Bool {
        if let check = configure?.constField.checkVersion, let current = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           check == current {
            return true
        }
        return false
    }
    
    var user: UserModel? {
        return login.value.0
    }
    
    var configure: ConfigureModel?
    
    override init() {
        super.init()
        setupBinding()
    }
    
    private func setupBinding() {
        
        if let view = onView {
            error.asObservable().map { (error) -> NetError? in
                print(error)
                if let e = error as? NetError {
                    return e
                }
                return NetError.error(code: -1111, msg: error.localizedDescription)
            }.filterNil().bind(to: view.rx.toastError).disposed(by: rx.disposeBag)

            loading.asObservable().bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
        }

//        login.subscribe(onNext: {[weak self] user in
//            guard let self = self else { return }
//            if let u = user.0 {
//                NSKeyedArchiver.archiveRootObject(u, toFile: self.userPath)
//            } else {
//                try? FileManager.default.removeItem(atPath: self.userPath)
//            }
//        }).disposed(by: rx.disposeBag)
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let u = self.user, u.withdrawalChanceCountdown.value > 0 {
                let c = u.withdrawalChanceCountdown.value - 1
                u.withdrawalChanceCountdown.accept(c)
            }
            if let u = self.user, u.hasDrawTime.value > 0 {
                let c = u.hasDrawTime.value - 1
                u.hasDrawTime.accept(c)
            }
        }).disposed(by: rx.disposeBag)
        
    }
    
    
    // MARK: - Login
    
    func updateUser() {
        if isLogin {
            let update = NetManager.requestObj(.updateUser(), type: UserModel.self)
            update.asObservable().trackError(error).subscribe(onNext: {[weak self] newUser in
                guard let self = self else { return }
                newUser?.token = self.login.value.0?.token
                self.login.accept((newUser, .change))
            }, onError: { error in
//                self.login.accept(nil)
            }).disposed(by: rx.disposeBag)
        }
    }
    
    // MARK: - Login
    
    func loginUser() -> Single<Void> {
        
        return Single<Void>.create { single in
            
            let login = NetManager.requestObj(.login, type: LoginUserModel.self)
            login.asObservable().trackActivity(self.loading).trackError(self.error).subscribe(onNext: { loginUser in
                guard let loginUser = loginUser else { return }
//                let update = NetManager.requestObj(.updateUser(token: user.token, userId: user.id), type: UserModel.self)
                let configure = NetManager.requestObj(.configure(token: loginUser.token, userId: loginUser.id), type: ConfigureModel.self)
                configure.flatMap { cf -> Single<UserModel?> in
                    self.configure = cf
                    return NetManager.requestObj(.updateUser(token: loginUser.token, userId: loginUser.id), type: UserModel.self)
                }.subscribe (onSuccess: { user in
                    guard let user = user else { return }
//                    updateUser.token = user.token
//                    updateUser.isNew = user.isNew
//                    updateUser.channel = user.channel
                    user.isNew = loginUser.isNew
                    self.login.accept((user, .login))
                    // MARK: -warning ---
//                    cf?.const.remandiOS = 1
//                    self.configure = cf 
                    single(.success(()))
                }, onError: { error in
                    single(.error(error))
                }).disposed(by: self.rx.disposeBag)

//                let zip = Observable.zip(update.asObservable(), configure.asObservable())
//                zip.trackActivity(self.loading).trackError(self.error).subscribe(onNext: { updateUser, cf in
//                    guard let updateUser = updateUser else { return }
//                    updateUser.token = user.token
//                    updateUser.isNew = user.isNew
//                    updateUser.channel = user.channel
//                    self.login.accept((updateUser, .login))
//                    // MARK: -warning ---
////                    cf?.const.remandiOS = 1
//                    self.configure = cf
//                    single(.success(()))
//                }, onError: { error in
//                    single(.error(error))
//                }).disposed(by: self.rx.disposeBag)
            }, onError: { error in
                single(.error(error))
            }).disposed(by: self.rx.disposeBag)
            
            return Disposables.create()
        }
    }
    
}

