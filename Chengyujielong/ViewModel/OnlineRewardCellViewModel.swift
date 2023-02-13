//
//  OnlineRewardCellViewModel.swift
//  Chengyujielong
//
//  Created by liqi on 2020/10/15.
//  Copyright © 2020 Kaka. All rights reserved.
//

import RxSwift
import RxCocoa

class OnlineRewardCellViewModel: NSObject {
    
    var duration : Int!
    var hasReceive = BehaviorRelay<Int>(value: 0)
    var canReceive = BehaviorRelay<Int>(value: 0)
    var max : Int!
    var min : Int!
    var type : Int!
    var watchVideos : Int!
    var number : String!
    
    let openReward = PublishSubject<AllTaskCellViewModel>()
    
    init(model: OnlineReward) {
        
        super.init()
        
        duration = model.duration
        hasReceive.accept(model.hasReceive)
        hasReceive.subscribe(onNext: { h in
            model.hasReceive = h
        }).disposed(by: rx.disposeBag)
        max = model.max
        min = model.min
        type = model.type
        watchVideos = model.watchVideos
        number = model.number
        
        
    }
}
