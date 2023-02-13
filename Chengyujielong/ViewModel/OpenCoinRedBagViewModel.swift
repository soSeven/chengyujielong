//
//  OpenCoinRedBagViewModel.swift
//  Chengyujielong
//
//  Created by liqi on 2020/9/28.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxSwift
import RxCocoa

class OpenCoinRedBagViewModel: ViewModel, ViewModelType {
    
    struct Input {
        var request: Observable<Void>
    }
    
    struct Output {
        let success: PublishSubject<OpenCoinRedBagModel?>
    }
    
    func transform(input: Input) -> Output {
        
        let success = PublishSubject<OpenCoinRedBagModel?>()
        
        input.request.subscribe(onNext: { [weak self] j in
            guard let self = self else { return }
            self.request().subscribe(onNext: { m in
                success.onNext(m)
            }, onError: { error in
                
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)

        return Output(success: success)
    }
    
    // MARK: - Request
    
    func request() -> Observable<OpenCoinRedBagModel?> {
        
        return NetManager.requestObj(.openRedBag, type: OpenCoinRedBagModel.self).trackError(error).trackActivity(loading)
        
    }
    
    
}
