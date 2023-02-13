//
//  LotteryViewModel.swift
//  CrazyMusic
//
//  Created by liqi on 2020/9/17.
//  Copyright © 2020 LQ. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftExt

class LotteryViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let request: Observable<Void>
        let requestLottery: Observable<Void>
    }
    
    struct Output {
        let success: BehaviorRelay<ConfigureWithdrawalDrawShow?>
        let listFailure: PublishSubject<Void>
        let step: PublishSubject<Void>
        let lotteryFinished: PublishSubject<LotteryModel?>
        let lotteryError: PublishSubject<Void>
    }

    func transform(input: Input) -> Output {
        
        let success = BehaviorRelay<ConfigureWithdrawalDrawShow?>(value: nil)
        let listFailure = PublishSubject<Void>()
        
        input.request.subscribe(onNext: { _ in
            let currentCash = UserManager.shared.user?.redPacket.float() ?? 0
            let model = UserManager.shared.configure?.withdrawalDrawShow.first(where: { m -> Bool in
                return Float(m.min) <= currentCash && currentCash <= Float(m.max)
            })
            guard let m = model else {
                listFailure.onNext(())
                return
            }
            success.accept(m)
        }).disposed(by: rx.disposeBag)
        
        let step = PublishSubject<Void>()
        let lotteryFinished = PublishSubject<LotteryModel?>()
        let lotteryError = PublishSubject<Void>()
        input.requestLottery.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let finished = PublishSubject<Void>()
            var disposeBag = DisposeBag()
            let firstTime = Int.random(in: 1000...4000)
            Observable<Int>.interval(.milliseconds(50), scheduler: MainScheduler.instance).subscribe(onNext: { i in
                if firstTime < i * 50 {
                    finished.onNext(())
                    disposeBag = DisposeBag()
                    return
                }
                step.onNext(())
            }).disposed(by: disposeBag)
            Observable.zip(finished.asObserver(), self.requestLottery()).subscribe(onNext: { (_, m) in
                guard let m = m else {
                    lotteryError.onNext(())
                    return
                }
                if let u = UserManager.shared.login.value.0 {
                    if m.type == 2 {
                        u.redPacket = m.result
                    } else if m.type == 1 {
                        u.goldCoin = m.result.int ?? 0
                    } else {
                        u.lastWithdrawalChanceResult = m.result
                        u.withdrawalChanceCountdown.accept(AppDefine.getCashTotalTime)
                    }
                    UserManager.shared.login.accept((u, .change))
                }
                lotteryFinished.onNext(m)
            }, onError: { _ in
                lotteryError.onNext(())
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)

        return Output(success: success, listFailure: listFailure, step: step, lotteryFinished:lotteryFinished, lotteryError: lotteryError)
    }
    
    // MARK: - Request
    
    func requestLottery() -> Observable<LotteryModel?> {
        
        return NetManager.requestObj(.lottery, type: LotteryModel.self).trackError(error)
        
    }
    
    
}
