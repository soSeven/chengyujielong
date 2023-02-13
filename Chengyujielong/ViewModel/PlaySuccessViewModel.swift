//
//  PlaySuccessViewModel.swift
//  Chengyujielong
//
//  Created by liqi on 2020/10/12.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxSwift
import RxCocoa

class PlaySuccessViewModel: ViewModel, ViewModelType {
    
    struct Input {
        var request: Observable<(Int, Int, String)>
    }
    
    struct Output {
        let success: PublishSubject<PlaySuccessModel?>
        let failure: PublishSubject<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let success = PublishSubject<PlaySuccessModel?>()
        let failure = PublishSubject<Void>()
        
        input.request.subscribe(onNext: { [weak self] (level, video, cash) in
            guard let self = self else { return }
//            self.request(level: level, video: video, cash: cash).subscribe(onNext: { m in
//                success.onNext(m)
//            }, onError: { error in
//                failure.onNext(())
//            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)

        return Output(success: success, failure: failure)
    }
    
    // MARK: - Request
    
    func request(level: Int, video: Int, cash: String) -> Observable<PlaySuccessModel?> {
        
        return NetManager.requestObj(.passGameAward(checkpoint: level, video: video, red_packet: cash), type: PlaySuccessModel.self).trackError(error).trackActivity(loading)
        
    }
    
    
}
