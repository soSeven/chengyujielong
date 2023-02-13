//
//  TodayTaskPopViewModel.swift
//  Chengyujielong
//
//  Created by liqi on 2020/9/30.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxSwift
import RxCocoa

class TodayTaskPopViewModel: ViewModel, ViewModelType {
    
    struct Input {
        var request: Observable<Int>
    }
    
    struct Output {
        let success: PublishSubject<TodayTaskRewardModel?>
        let failure: PublishSubject<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let success = PublishSubject<TodayTaskRewardModel?>()
        let failure = PublishSubject<Void>()
        
        input.request.subscribe(onNext: { [weak self] id in
            guard let self = self else { return }
            self.request(id: id).subscribe(onNext: { m in
                success.onNext(m)
            }, onError: { error in
                failure.onNext(())
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)

        return Output(success: success, failure: failure)
    }
    
    // MARK: - Request
    
    func request(id: Int) -> Observable<TodayTaskRewardModel?> {
        
        return NetManager.requestObj(.acceptTodayTask(id: id), type: TodayTaskRewardModel.self).trackError(error).trackActivity(loading)
        
    }
    
    
}
