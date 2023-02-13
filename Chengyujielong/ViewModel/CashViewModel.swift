//
//  CashViewModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/13.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

struct CashPriceModel {
    let cash : Int
    let level : Int
    let text: String?
}

fileprivate struct WeChatInfo {
    let unionid : String
    let openid : String
    let nickname : String
    let avatar : String
    let sex : Int
}

class CashViewModel: ViewModel, ViewModelType {
    
    weak var controller: UIViewController?
    
    struct Input {
        var request: Observable<Void>
        var cash: Observable<CashPriceModel>
        var requestWeChat: Observable<Void>
    }
    
    struct Output {
        var items: BehaviorRelay<[CashPriceModel]>
        let showErrorView: BehaviorRelay<Bool>
        let showEmptyView: BehaviorRelay<Bool>
        let success: PublishSubject<CashPriceModel>
    }
    
    func transform(input: Input) -> Output {
        
        let items = BehaviorRelay<[CashPriceModel]>(value: [])
        let showErrorView = BehaviorRelay<Bool>(value: false)
        let showEmptyView = BehaviorRelay<Bool>(value: false)
        let success = PublishSubject<CashPriceModel>()
        
//        input.requestClean.subscribe(onNext: {[weak self] b in
//            guard let self = self else { return }
//            if b {
//                self.requestClean().subscribe(onNext: {
//                    
//                }).disposed(by: self.rx.disposeBag)
//            }
//        }).disposed(by: rx.disposeBag)
        
        input.request.subscribe(onNext: { _ in
            let i1 = CashPriceModel(cash: 3000, level: UserManager.shared.configure?.constField.checkpointwithdrawal ?? 0, text: "无门槛")
            let i2 = CashPriceModel(cash: 3000000, level: 3500, text: nil)
            let i3 = CashPriceModel(cash: 5000000, level: 3500, text: nil)
            let i4 = CashPriceModel(cash: 10000000, level: 3500, text: nil)
            items.accept([i1, i2, i3, i4])
        }).disposed(by: rx.disposeBag)
        
        input.cash.subscribe(onNext: { [weak self] m in
            guard let self = self else { return }
            self.requestCash().subscribe(onNext: { getCash in
                success.onNext(m)
                guard let u = UserManager.shared.user else { return }
                guard let getCash = getCash else { return }
                u.redPacket = getCash.redPacket
                u.withdrawalTime = Date().string()
                UserManager.shared.login.accept((u, .change))
            }, onError: { error in
                
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        input.requestWeChat.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.requestWechat().subscribe(onNext: { info in
                if let u = UserManager.shared.login.value.0 {
                    u.avatar = info.avatar
                    u.nickname = info.nickname
                    u.openid = info.openid
                    UserManager.shared.login.accept((u, .change))
                }
            }, onError: { error in
                
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)

        return Output(items: items,
                      showErrorView: showErrorView,
                      showEmptyView: showEmptyView,
                      success: success)
    }
    
    // MARK: - Request
    
//    private func requestClean() -> Observable<Void> {
//
//        return NetManager.requestResponse(.clearDraw).asObservable().trackError(error)
//
//    }
    
    private func requestCash() -> Observable<GetCashModel?> {
        
        return NetManager.requestObj(.getCash, type: GetCashModel.self).asObservable().trackError(error).trackActivity(loading)
        
    }
    
    private func requestWechat() -> Observable<WeChatInfo> {
        return getWeChat().asObservable().trackError(error).trackActivity(loading)
    }
    
    private func getWeChat() -> Single<WeChatInfo> {
        
        return Single<UMSocialUserInfoResponse>.create { single in
            UMSocialManager.default()?.getUserInfo(with: .wechatSession, currentViewController: nil, completion: { (result, error) in
                if let _ = error {
                    single(.error(NetError.error(code: 9999, msg: "绑定失败")))
                } else {
                    if let r = result as? UMSocialUserInfoResponse {
                        single(.success(r))
                    } else {
                        single(.error(NetError.error(code: 9999, msg: "绑定失败")))
                    }
                }
            })
            return Disposables.create()
            
        }.flatMap { re -> Single<WeChatInfo> in
            
            let unionid = re.unionId ?? ""
            let openid = re.openid ?? ""
            let nickname = re.name ?? ""
            let avatar = re.iconurl ?? ""
            var sex = 3
            switch re.unionGender {
            case "男":
                sex = 1
            case "女":
                sex = 2
            default:
                break
            }
            
            return NetManager.requestResponse(.bindWeChat(openid: openid, sex: sex, unionid: unionid, avatar: avatar, nickName: nickname)).flatMap { _ -> Single<WeChatInfo> in
                return Single<WeChatInfo>.create { s in
                    s(.success(WeChatInfo(unionid: unionid, openid: openid, nickname: nickname, avatar: avatar, sex: sex)))
                    return Disposables.create()
                }
            }
            }.timeout(.seconds(20), scheduler: MainScheduler.instance).debug()
        
    }
    
}
