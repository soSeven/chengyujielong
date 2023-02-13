//
//  AllTaskPopViewModel.swift
//  Chengyujielong
//
//  Created by liqi on 2020/9/30.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxSwift
import RxCocoa

class AllTaskPopViewModel: ViewModel, ViewModelType {
    
    struct Input {
        var request: Observable<Int>
    }
    
    struct Output {
        let success: PublishSubject<AllTaskRewardModel?>
    }
    
    func transform(input: Input) -> Output {
        
        let success = PublishSubject<AllTaskRewardModel?>()
        
        input.request.subscribe(onNext: { [weak self] id in
            guard let self = self else { return }
            self.request(id: id).subscribe(onNext: { m in
                success.onNext(m)
            }, onError: { error in
                
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)

        return Output(success: success)
    }
    
    // MARK: - Request
    
    func request(id: Int) -> Observable<AllTaskRewardModel?> {
        
        return NetManager.requestObj(.acceptAllTask(id: id), type: AllTaskRewardModel.self).trackError(error).trackActivity(loading)
        
    }
    
    
}
