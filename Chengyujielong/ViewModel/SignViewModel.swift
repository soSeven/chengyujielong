//
//  SignViewModel.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/8/14.
//  Copyright © 2020 LQ. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt
//import RxDataSources

class SignViewModel: ViewModel, ViewModelType {
    
    struct Input {
        var clickOnline: Observable<Void>
        var requestOnline: Observable<OnlineRewardCellViewModel>
        
        var clickSign: Observable<Void>
        var requestSign: Observable<SignReward>
    }
    
    struct Output {
        let list: BehaviorRelay<[SignReward]>
        
        let onlineList: BehaviorRelay<[OnlineRewardCellViewModel]>
        let onlineBtnState: BehaviorRelay<(Int, Int)>
        let onlineSuccess: PublishRelay<HomeOnlineSignModel?>
        let onlineClick: PublishRelay<OnlineRewardCellViewModel>
        
        let signSuccess: PublishRelay<HomeSignModel?>
        let signClick: PublishRelay<SignReward>
        let signBtnState: BehaviorRelay<(Int, SignReward?)>
    }
    
    func transform(input: Input) -> Output {
        
        let signListModels = UserManager.shared.user?.signReward ?? []
        let list = BehaviorRelay<[SignReward]>(value: signListModels)
        
        let onlineListModels = UserManager.shared.user?.onlineReward.map({ OnlineRewardCellViewModel(model: $0)}) ?? []
        let onlineList = BehaviorRelay<[OnlineRewardCellViewModel]>(value: onlineListModels)
        
        let onlineBtnState = BehaviorRelay<(Int, Int)>(value: (0, 0))
        
        let signBtnState = BehaviorRelay<(Int, SignReward?)>(value: (0, nil))
        
        let canReceive = signListModels.filter{ $0.hasReceive == 0 && $0.canReceive > 0 }
        if canReceive.count > 0 {
            signBtnState.accept((0, nil))
        } else {
            let nextReceive = signListModels.filter{ $0.hasReceive == 0 }
            var next = nextReceive.first
            if next == nil {
                next = signListModels.first
            }
            signBtnState.accept((1, next))
        }
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).startWith(0).subscribe(onNext: { time in
            let dif = Int(OnlineTimeManager.shared.getDifSeconds())
            let needReceive = onlineListModels.filter{ $0.hasReceive.value == 0 }
            let canReceive = needReceive.filter{$0.duration * 60 <= dif}
            canReceive.forEach{ i in
                if i.canReceive.value == 0 {
                    i.canReceive.accept(1)
                }
            }
            if canReceive.count > 0 {
                onlineBtnState.accept((1, 0))
            } else if needReceive.count > 0 {
                let first = needReceive[0]
                var timeDif = first.duration * 60 - dif
                if timeDif < 0 {
                    timeDif = 0
                }
                onlineBtnState.accept((2, timeDif))
            } else {
                onlineBtnState.accept((0, 0))
            }
        }).disposed(by: rx.disposeBag)
        
        let onlineClick = PublishRelay<OnlineRewardCellViewModel>()
        input.clickOnline.subscribe(onNext: {
            let canReceive = onlineListModels.filter{ $0.hasReceive.value == 0 && $0.canReceive.value > 0 }
            if canReceive.count > 0 {
                onlineClick.accept(canReceive[0])
            }
        }).disposed(by: rx.disposeBag)
            
        let onlineSuccess = PublishRelay<HomeOnlineSignModel?>()
        input.requestOnline.subscribe(onNext: { [weak self] m in
            guard let self = self else { return }
            MobClick.event("sign_login", attributes: [
                "day" : m.duration ?? 0
            ])
            self.requestOnlineReward(duration: m.duration.string, number: m.number).subscribe(onNext: { rewardModel in
                m.hasReceive.accept(1)
                if let u = UserManager.shared.user, let r = rewardModel{
                    u.redPacket = r.redPacket
                    u.goldCoin = r.goldCoin
                    UserManager.shared.login.accept((u, .change))
                }
                onlineSuccess.accept(rewardModel)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        let signClick = PublishRelay<SignReward>()
        input.clickSign.subscribe(onNext: {
            let canReceive = signListModels.filter{ $0.hasReceive == 0 && $0.canReceive > 0 }
            if canReceive.count > 0 {
                signClick.accept(canReceive[0])
            }
        }).disposed(by: rx.disposeBag)
        
        let signSuccess = PublishRelay<HomeSignModel?>()
        input.requestSign.subscribe(onNext: {[weak self] s in
            guard let self = self else { return }
            MobClick.event("sign_login", attributes: [
                "day" : s.day
            ])
            self.requestRewardSign().subscribe(onNext: { m in
                if let u = UserManager.shared.user, let r = m {
                    u.redPacket = r.redPacket
                    u.goldCoin = r.goldCoin
                    UserManager.shared.login.accept((u, .change))
                }
                s.hasReceive = 1
                s.canReceive = 0
                signSuccess.accept(m)
                
                let canReceive = signListModels.filter{ $0.hasReceive == 0 && $0.canReceive > 0 }
                if canReceive.count > 0 {
                    signBtnState.accept((0, nil))
                } else {
                    let nextReceive = signListModels.filter{ $0.hasReceive == 0 }
                    var next = nextReceive.first
                    if next == nil {
                        next = signListModels.first
                    }
                    signBtnState.accept((1, next))
                }
                
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return Output(list: list, onlineList: onlineList, onlineBtnState: onlineBtnState, onlineSuccess: onlineSuccess, onlineClick: onlineClick, signSuccess: signSuccess, signClick: signClick, signBtnState: signBtnState)
    }
    
    // MARK: - Request
    
    func requestOnlineReward(duration: String, number: String) -> Observable<HomeOnlineSignModel?> {

        return NetManager.requestObj(.rewardOnline(duration: duration, number: number), type: HomeOnlineSignModel.self).trackError(error).trackActivity(loading)

    }
    
    private func requestRewardSign() -> Observable<HomeSignModel?>{
        
        return NetManager.requestObj(.rewardSign, type: HomeSignModel.self).asObservable()
        
    }
    
    
}
